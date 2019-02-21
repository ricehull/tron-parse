package main

import (
	"fmt"
	"sort"
	"time"

	"github.com/tronprotocol/grpc-gateway/core"
	"tron-parse/explorer/core/grpcclient"
)

var bulkFetchLimit = int64(10)
var maxErrCnt = 10

var wc1 *workerCounter

func getUnconfirmedBlock(minBlockID int64) int64 {
	fmt.Printf("get unconfirmed block info-->blockID:%v\n", minBlockID)

	client := grpcclient.GetRandomWallet()
	if nil != client {
		defer client.Close()
	}
	blocks, err := client.GetBlockByLatestNum(30)
	if nil != err || 0 == len(blocks) {
		return minBlockID
	}

	sort.Slice(blocks, func(i, j int) bool {
		return blocks[i].BlockHeader.RawData.Number < blocks[j].BlockHeader.RawData.Number
	})

	idx := 0
	for i, block := range blocks {
		if nil != block && nil != block.BlockHeader && nil != block.BlockHeader.RawData && block.BlockHeader.RawData.Number <= minBlockID {
			continue
		}
		idx = i
		break
	}
	if 0 < len(blocks[idx:]) {
		minBlockID = blocks[len(blocks)-1].BlockHeader.RawData.Number
		verifyStoreBlock(false, blocks[idx:], nil, client, 3)
	}
	return minBlockID
}

func getBlock(id int, b, e int64) {
	wc1.startOne()

	ts := time.Now()

	client := grpcclient.GetRandomWallet()
	taskID := fmt.Sprintf("[%04v|%v~%v|%v]", id, b, e, client.Target())

	if nil != client {
		defer client.Close()
	}
	dbc := grpcclient.GetRandomDatabase()
	if nil != client {
		defer dbc.Close()
	}

	le := getLatestNum(dbc)
	if le == 0 {
		wc1.stopOne()
		getBlock(id, b, e)
		return
	}

	if le < b && e > 0 { // begin position > latest end position, and e > 0 mean get old block
		wc1.stopOne()
		fmt.Printf("%v quit as no block need to sync:[%v ~ %v] latest block of main net is:%v\n", taskID, b, e, le)
		return
	}

	fmt.Printf("%v latestNum is [%v]\n", taskID, le)
	b = checkForkTask(id, "", le, b, e) // check if we need fork sub task

	bb := b
	cnt := int64(0)
	errCnt := 0
	newE := int64(0)

	blockBuf := make([]*core.Block, 0, 2000)
	blockIDs := make([]int64, 0, 2000)

	latestUnconfirmedBlockID := le

	tsWriteDB := time.Now()

	for {
		if needQuit() {
			break
		}

		if errCnt >= maxErrCnt {
			wc1.stopOne()
			getBlock(id, bb, e) // redo full bulk of block
			return
		}

		if e > 0 && b >= e {
			break
		}

		if id == 0 && b >= le {
			uncBlkCost := time.Now()
			le = getLatestNum(dbc)
			if le > latestUnconfirmedBlockID {
				latestUnconfirmedBlockID = getUnconfirmedBlock(le)
			} else {
				latestUnconfirmedBlockID = getUnconfirmedBlock(latestUnconfirmedBlockID)

			}

			uncBlkConsum := time.Since(uncBlkCost)
			if uncBlkConsum < 3*time.Second {
				time.Sleep(3*time.Second - uncBlkConsum)
			}

			runTaskCnt := wc1.currentWorker()
			fmt.Printf("Current working task:[%v]--max task:[%v], latest block id handled:%v\n", runTaskCnt, *gIntMaxWorker, newE)
			if e > 0 && 1 == runTaskCnt {
				fmt.Printf("Sync all data cost:%v\n", time.Since(ts))
				break
			}
			if needQuit() {
				break
			}
		}

		newE = b + bulkFetchLimit

		if e > 0 && newE > e {
			newE = e
		} else if e == 0 && newE > le {
			newE = le
		}

		blocks, err := client.GetBlockByLimitNext(b, newE)
		if nil != err {
			errCnt++
		}

		if len(blockBuf)+len(blocks) > cap(blockBuf) || time.Since(tsWriteDB) > 10*time.Second {
			ret := verifyStoreBlock(true, blockBuf, blockIDs, client, maxErrCnt-errCnt)
			if !ret {
				fmt.Printf("bulk get block(%v, %v) check store failed! error:%v\n", b, newE, err)
				errCnt += maxErrCnt
			}
			blockBuf = blockBuf[:0]
			blockIDs = blockIDs[:0]
			tsWriteDB = time.Now()
		}
		blockBuf = append(blockBuf, blocks...)
		blockIDs = append(blockIDs, genVerifyBlockIDList(b, newE)...)

		c := int64(len(blocks))
		cnt += c
		b += c
	}

	ret := verifyStoreBlock(true, blockBuf, blockIDs, client, maxErrCnt-errCnt)
	if !ret {
		fmt.Printf("bulk get block(%v, %v) check store failed\n", b, newE)
		errCnt += maxErrCnt
		wc1.stopOne()
		getBlock(id, bb, e)
		return
	}

	if id == 0 {
		for {
			runTaskCnt := wc1.currentWorker()
			fmt.Printf("Current working task:[%v]--max task:[%v], latest block id handled:%v\n", runTaskCnt, *gIntMaxWorker, newE)
			if e > 0 && 1 == runTaskCnt {
				fmt.Printf("Sync all data cost:%v, last block need to sync is [%v] done!\n", time.Since(ts), e)
				break
			}
			if needQuit() && 1 == runTaskCnt {
				fmt.Printf("Sync all data cost:%v, receive signal quit\n", time.Since(ts))
				break
			}
			time.Sleep(10 * time.Second)
		}
	}

	// fmt.Printf("%v Finish work, total cost:%v, total block:%v(%v), begin:%v, end:%v\n", taskID, time.Since(ts), cnt, b-bb, bb, b)

	wc1.stopOne()
}

func getBlockByIDs(blockIDs []int64, client *grpcclient.Wallet) ([]*core.Block, []int64) {
	ret := make([]*core.Block, 0, len(blockIDs))
	missingBlockID := make([]int64, 0)
	for _, id := range blockIDs {
		block, err := client.GetBlockByNum(id)
		if err == nil && nil != block && nil != block.BlockHeader && nil != block.BlockHeader.RawData && block.BlockHeader.RawData.Number == id {
			ret = append(ret, block)
		} else {
			missingBlockID = append(missingBlockID, id)
		}
	}

	return ret, missingBlockID
}

func getLatestNum(dbc *grpcclient.Database) int64 {
	prop, err := dbc.GetDynamicProperties()
	if nil == err && nil != prop {
		return prop.LastSolidityBlockNum
	}
	return 0
}

func checkForkTask(id int, taskID string, latestE, b, e int64) (newB int64) {
	newB = b
	if e == 0 {
		if id != 0 { // e == 0 only for task id == 0
			return
		}

		if latestE-b > *gInt64MaxWorkload {
			newB = latestE - *gInt64MaxWorkload
			forkBlockTask(id+1, b, newB)
		}
	} else {
		if e-b > *gInt64MaxWorkload {
			newB = e - *gInt64MaxWorkload
			forkBlockTask(id+1, b, newB)
		}
	}
	return
}

func forkBlockTask(id int, b, e int64) {
	go getBlock(id, b, e)
}

func genVerifyBlockIDList(b, e int64) (ret []int64) {
	for i := b; i < e; i++ {
		ret = append(ret, i)
	}
	return
}

func verifyStoreBlock(confirmed bool, blocks []*core.Block, blockIDCheckList []int64, client *grpcclient.Wallet, retryCnt int) bool {
	if len(blocks) == 0 {
		return true
	}
	_, succCnt, errCnt, blockList := storeBlocks(blocks, confirmed)
	_ = succCnt
	_ = errCnt

	sort.Slice(blockList, func(i, j int) bool { return blockList[i] < blockList[j] })

	missingBlockID := make([]int64, 0)
	blockCnt := len(blockList)
	for _, blockID := range blockIDCheckList {
		retIdx := sort.Search(blockCnt, func(idx int) bool { return blockList[idx] >= blockID })

		if retIdx < blockCnt && blockList[retIdx] == blockID {

		} else {
			missingBlockID = append(missingBlockID, blockID)
		}
	}
	if len(missingBlockID) > 0 {
		fmt.Printf("missing %v, try cnt remain:%v raw block size:%v, succ:%v, err:%v \n\tmissing blockIDs(%v):%v\n\tpull blockIDs(%v):%v\n", blockIDCheckList, retryCnt, len(blocks), succCnt, errCnt, len(missingBlockID), missingBlockID, len(blockList), blockList)

		if retryCnt <= 0 {
			return false
		}

		blocks, _ := getBlockByIDs(missingBlockID, client)

		return verifyStoreBlock(confirmed, blocks, missingBlockID, client, retryCnt-1)
	}

	return true

}
