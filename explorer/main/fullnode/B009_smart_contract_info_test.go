package main

import (
	"fmt"
	"testing"

	"tron-parse/explorer/core/grpcclient"
	"tron-parse/explorer/core/utils"
)

func TestSmartCtxInfo(*testing.T) {
	utils.TestNet = true
	initDB("tron:tron@tcp(mine:3306)/troney")
	client := grpcclient.GetRandomWallet()
	trxHash := "0a70e08bd9e04b16f4978d8c63d74fb88b8d99c8825426c18f36539201c6681c" // create smart contract trx
	// trxHash = "02e4075784e65b3e0f4127c413548d71c106cf66c04d45151938e25817019f32"  // trigger smart contract trx
	// trxHash = "f42346f069458dc6c9d3d1645427433953eb56e8e069ca3806beb914228858a5"
	// trxHash = "08b7c0edd4922907aad4ecf487bba56daeed22a0a6d80257b14711933dc5ddcc"
	// trxHash = "39fa5df6a550f070ebf820860125f5cf6f2c0d64c81f0ce3af9bf6e734846223"
	trxHash = "5addf3f807750418a7352438ffd43249813b20fb517fa87f927c31db5dbcc416"
	blockID := int64(475700)
	blockID = 845700
	trxInfo, err := client.GetTransactionInfoByID(trxHash)
	if nil != err {
		fmt.Printf("get trx info failed:%v\n", err)
		return
	}
	fmt.Printf("%v\n%v\n%v\n", blockID, utils.ToJSONStr(trxInfo), err)
	if nil != trxInfo {
		fmt.Printf("ctx addr:%v\n%s",
			utils.Base58EncodeAddr(trxInfo.ContractAddress),
			trxInfo.ResMessage)
	}
	err = updateSmartContract(trxHash, blockID, trxInfo)
	fmt.Printf("result:%v", err)
}
