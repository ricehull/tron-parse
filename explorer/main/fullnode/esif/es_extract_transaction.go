package main

import (
	"bytes"
	"fmt"

	"github.com/tronprotocol/grpc-gateway/core"
	"tron-parse/explorer/core/utils"
)

// ESConvertBlocksBulk ...
func ESConvertBlocksBulk(blocks []*core.Block, confirmed bool) ([]byte, []byte, []int64) {

	buff := &bytes.Buffer{}
	tranBuff := &bytes.Buffer{}
	blockIDs := make([]int64, 0, len(blocks))
	blockIDMap := make(map[int64]bool)

	opType := "create"
	if confirmed {
		opType = "index"
	}

	for _, block := range blocks {
		blockInfo := ConverBlock(block, confirmed)
		if nil == blockInfo {
			continue
		}
		_, ok := blockIDMap[blockInfo.ID]
		if !ok {
			blockIDMap[blockInfo.ID] = true
			blockIDs = append(blockIDs, blockInfo.ID)
		}

		buff.WriteString(fmt.Sprintf(`{"%v":{"_index":"%v", "_type": "%v","_id":%v}}%v`,
			opType, BlockIndex, BlockType, blockInfo.ID, "\n"))
		buff.WriteString(fmt.Sprintf("%s\n", utils.ToJSONStr(blockInfo)))
		tranBuff.Write(bulkTrans(block, confirmed))
	}

	return buff.Bytes(), tranBuff.Bytes(), blockIDs
}

func bulkTrans(block *core.Block, confirmed bool) []byte {
	buff := &bytes.Buffer{}

	opType := "create"
	if confirmed {
		opType = "index"
	}

	for _, tran := range block.Transactions {
		tranInfo := ConverTransaction(tran, confirmed, block.BlockHeader.RawData.Number, block.BlockHeader.RawData.Timestamp)
		if nil == tranInfo {
			continue
		}
		// if Test {
		// 	if 0 == len(detail) {
		// 		buff.WriteString(fmt.Sprintf(`{"index":{"_index":"%v", "_type": "%v", "_id":"%v"}}%v`,
		// 			TransactionIndex, TransactionType, tranInfo.Hash, "\n"))
		// 		buff.WriteString(fmt.Sprintf("%s\n", utils.ToJSONStr(tranInfo)))
		// 	} else {
		// 		buff.WriteString(detail)
		// 	}
		// } else {
		buff.WriteString(fmt.Sprintf(`{"%v":{"_index":"%v", "_type": "%v", "_id":"%v"}}%v`,
			opType, TransactionIndex, TransactionType, tranInfo.Hash, "\n"))
		buff.WriteString(fmt.Sprintf("%s\n", utils.ToJSONStr(tranInfo)))
		if *gParseCtx {
			detail := extractTransactionDetail(tranInfo)
			buff.WriteString(detail)
		}

		// }
	}

	return buff.Bytes()
}
func extractTransactionDetail(trxInfo *TransactionInfo) string {
	switch core.Transaction_Contract_ContractType(trxInfo.ContractType) {
	case core.Transaction_Contract_TransferContract:
		return handleTransfer(trxInfo)
	case core.Transaction_Contract_TransferAssetContract:
		return handleTransferAsset(trxInfo)
	case core.Transaction_Contract_CreateSmartContract:
		return handleCreateSmart(trxInfo)
	case core.Transaction_Contract_TriggerSmartContract:
		return handleTriggerSmart(trxInfo)
	case core.Transaction_Contract_ExchangeTransactionContract:
		return handleExchangeTrade(trxInfo)
	case core.Transaction_Contract_VoteWitnessContract:
	}
	return ""
}
