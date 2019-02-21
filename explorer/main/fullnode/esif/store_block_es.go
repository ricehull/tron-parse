package main

import (
	"fmt"
	"sort"
	"time"

	"github.com/tronprotocol/grpc-gateway/core"
)

var batchStoreESLimit = 100

// 穿行化db操作 succCnt, errCnt, blockIDList
func storeBlocks(blocks []*core.Block, confirmed bool) (retResult bool, retSuccCnt int64, retErrCnt int64, retIDs []int64) {
	if 0 == len(blocks) {
		return true, 0, 0, nil
	}
	sort.Slice(blocks, func(i, j int) bool {
		return blocks[i].BlockHeader.RawData.Number < blocks[j].BlockHeader.RawData.Number
	})

	ts := time.Now()
	var start, end int
	end = len(blocks)
	for start+batchStoreESLimit < end {
		_, st, ft, lt := batchStoreES(blocks[start:start+batchStoreESLimit], confirmed)
		start += batchStoreESLimit
		retSuccCnt += st
		retErrCnt += ft
		retIDs = append(retIDs, lt...)
	}
	_, st, ft, lt := batchStoreES(blocks[start:], confirmed)
	retSuccCnt += st
	retErrCnt += ft
	retIDs = append(retIDs, lt...)

	fmt.Printf("storeBlocks to ES, range:[%v~%v], count:[%v], cost:%v\n",
		blocks[0].BlockHeader.RawData.Number, blocks[len(blocks)-1].BlockHeader.RawData.Number, len(blocks), time.Since(ts))

	return
}

func batchStoreES(blocks []*core.Block, confirmed bool) (bool, int64, int64, []int64) {
	if 0 == len(blocks) {
		return true, 0, 0, nil
	}
	sort.Slice(blocks, func(i, j int) bool {
		return blocks[i].BlockHeader.RawData.Number < blocks[j].BlockHeader.RawData.Number
	})

	fmt.Printf("storeBlocks total:%v, start:%v to:%v\n", len(blocks), blocks[0].BlockHeader.RawData.Number,
		blocks[len(blocks)-1].BlockHeader.RawData.Number)

	blockBuf, trxBuf, blockIDs := ESConvertBlocksBulk(blocks, confirmed)

	url := getESURL()
	if 0 < len(url) {
		defer releaseESURL(url)
	}
	// fmt.Printf("get es url:[%v]\n", url)

	//// store transactions
	// ts := time.Now()
	resp, err := ESBulkStore(url, "", "", trxBuf)
	if nil != err || (nil != resp && resp.Errors) {
		fmt.Printf("store transactions  failed:%v, resp:%v\n", err, resp)
	}
	// fmt.Printf("store transaction of block count(%v) cost:%v\n", len(blocks), time.Since(ts))

	//// store blocks
	// ts = time.Now()
	resp, err = ESBulkStore(url, "", "", blockBuf)
	if nil != err || (nil != resp && resp.Errors) {
		fmt.Printf("store transactions failed:%v, resp:%v\n", err, resp)
	}
	// fmt.Printf("store block count(%v) cost:%v\n", len(blocks), time.Since(ts))

	return true, 0, 0, blockIDs
}
