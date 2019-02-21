package main

import (
	"fmt"
	"sort"
	"testing"
	"time"

	"github.com/tronprotocol/grpc-gateway/core"
	"tron-parse/explorer/core/grpcclient"
	"tron-parse/explorer/main/module/rawmysql"
)

func TestGetLatestBlocks(*testing.T) {

	client := grpcclient.GetRandomWallet()
	if nil == client {
		fmt.Println("Get Wallet client failed")
		return
	}

	var maxBlockID, minBlockID int64
	for runTime := 5; runTime > 0; runTime-- {
		ts := time.Now()
		blocks, err := client.GetBlockByLatestNum(5)
		if nil != err {
			fmt.Printf("Get data failed:%v\n", err)
			continue
		}

		// fmt.Printf("\nerr:%v\ncnt:%v\ncost:%v\n\n", err, len(blocks), time.Since(ts))

		// for idx, block := range blocks {
		// 	fmt.Printf("%03d-->%v\n", idx, block.BlockHeader.RawData.Number)
		// }

		sort.Slice(blocks, func(i, j int) bool {
			return blocks[i].BlockHeader.RawData.Number > blocks[j].BlockHeader.RawData.Number
		})
		blockCnt := len(blocks)
		if 0 < blockCnt {
			minBlockID = blocks[blockCnt-1].BlockHeader.RawData.Number
			maxBlockID = blocks[0].BlockHeader.RawData.Number
			fmt.Printf("maxBlockID:%v, minBlockID:%v, len:%v cost:%v\n", maxBlockID, minBlockID, blockCnt, time.Since(ts))
			time.Sleep(3 * time.Second)
		}
	}

	// for idx, block := range blocks {
	// 	fmt.Printf("%03d-->%v\n", idx, block.BlockHeader.RawData.Number)
	// }
}

func TestStoreBlock(*testing.T) {
	initDB("tron:tron@tcp(mine:3306)/trone")
	rawmysql.DSN = "tron:tron@tcp(mine:3306)/trone"
	rawmysql.GetMysqlDB()

	cc := grpcclient.GetRandomWallet()

	sc := grpcclient.GetRandomSolidity()

	sb, err := sc.GetNowBlock()
	if nil == sb {
		return
	}
	fmt.Printf("solidity:--->%v--->block_id:%v\n", err, sb.BlockHeader.RawData.Number)
	startAccountDaemonNew()
	initDBLimit()

	blocks, err := cc.GetBlockByLatestNum(8)
	sort.Slice(blocks, func(i, j int) bool {
		return blocks[i].BlockHeader.RawData.Number > blocks[j].BlockHeader.RawData.Number
	})
	// blockCnt := len(blocks)
	// minBlockID := blocks[blockCnt-1].BlockHeader.RawData.Number
	maxBlockID := blocks[0].BlockHeader.RawData.Number
	for _, b := range blocks {
		fmt.Printf("full:---->block_id:%v\n", b.BlockHeader.RawData.Number)
		if b.BlockHeader.RawData.Number == sb.BlockHeader.RawData.Number {
			fmt.Printf("block_id:%v\n", b.BlockHeader.RawData.Number)

			verifyStoreBlock(true, []*core.Block{sb}, nil, nil, 0)
		}
	}
	ret := verifyStoreBlock(false, blocks, nil, nil, 0)
	fmt.Printf("store unconfirmed blocks ret:%v\n", ret)

	keys := make(map[int64]bool)
	sBlocks := make([]*core.Block, 0, 10)
	for {
		sb, err := sc.GetNowBlock()
		if nil == sb {
			return
		}
		_, ok := keys[sb.BlockHeader.RawData.Number]
		if !ok {
			fmt.Printf("solidity:--->%v--->block_id:%v\n", err, sb.BlockHeader.RawData.Number)
			sBlocks = append(sBlocks, sb)
			keys[sb.BlockHeader.RawData.Number] = true
			time.Sleep(3 * time.Second)
			if sb.BlockHeader.RawData.Number > maxBlockID {
				break
			}
		}
	}

	verifyStoreBlock(true, sBlocks, nil, nil, 0)
	fmt.Printf("store confirmed blocks ret:%v\n", ret)

	accWorker.WaitStop()
	for _, b := range blocks {
		if _, ok := keys[b.BlockHeader.RawData.Number]; ok {
			fmt.Printf("Update block:%v\n", b.BlockHeader.RawData.Number)
		} else {
			fmt.Printf("Unconfirmed block:%v\n", b.BlockHeader.RawData.Number)
		}
	}
}

func TestStore(*testing.T) {
	initDB("tron:tron@tcp(mine:3306)/trone")

	initDBLimit()
	startAccountDaemonNew()

	cc := grpcclient.GetRandomWallet()
	blocks, _ := cc.GetBlockByLatestNum(8)
	sort.Slice(blocks, func(i, j int) bool {
		return blocks[i].BlockHeader.RawData.Number > blocks[j].BlockHeader.RawData.Number
	})

	for _, b := range blocks {
		fmt.Printf("block_id:%v\n", b.BlockHeader.RawData.Number)
	}

	ret := verifyStoreBlock(false, blocks, nil, nil, 0)
	fmt.Printf("store unconfirmed blocks ret:%v\n", ret)
}

func TestUnconfirm(*testing.T) {

	initDB("tron:tron@tcp(mine:3306)/trone")
	rawmysql.DSN = "tron:tron@tcp(mine:3306)/trone"
	rawmysql.GetMysqlDB()

	initDBLimit()
	startAccountDaemonNew()

	wc1 = newWorkerCounter(*gIntMaxWorker)

	go func() {
		time.Sleep(30 * time.Second)
		close(quit)
	}()
	getUnconfirmdBlock()
}
