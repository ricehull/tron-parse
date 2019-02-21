package main

import (
	"fmt"

	"github.com/tronprotocol/grpc-gateway/core"
	"tron-parse/explorer/core/utils"
)

// maping ...
var (
	ExchangeIndex     = "exchanges"
	ExchangeTradeType = "trade"

	ExchangeTradeMapping = []byte(`
{
    "properties": {
        "BlockID": {
            "type": "long"
        },
        "Confiremd": {
            "type": "boolean"
        },
        "ContractType": {
            "type": "long"
        },
        "ContractTypeName": {
            "type": "keyword"
        },
        "CreateTime": {
            "type": "long"
        },
        "ExchangeID": {
            "type": "long"
        },
        "Expected": {
            "type": "long"
        },
        "FeeLimit": {
            "type": "long"
        },
        "Hash": {
            "type": "keyword"
        },
        "Owner": {
            "type": "keyword"
        },
        "Quant": {
            "type": "long"
        },
        "TokenID": {
            "type": "keyword"
        }
    }
}
`)
)

// ExchangeTransactionInfo ...
type ExchangeTransactionInfo struct {
	BlockID          int64
	CreateTime       int64
	Hash             string
	Confiremd        bool
	ContractType     int32
	ContractTypeName string
	Owner            string

	ExchangeID int64
	TokenID    string
	Quant      int64
	Expected   int64
}

func handleExchangeTrade(trxInfo *TransactionInfo) string {
	ctxDetail := utils.GetContractFromRaw(utils.HexDecode(trxInfo.ContractRaw))
	if nil == ctxDetail {
		return ""
	}

	ctx, ok := ctxDetail.(*core.ExchangeTransactionContract)
	if !ok {
		return ""
	}

	result, ok := trxInfo.Result.([]*core.Transaction_Result)
	if !ok || 0 == len(result) {
		return ""
	}

	opType := "create"
	if trxInfo.Confiremd {
		opType = "index"
	}

	ret := fmt.Sprintf(`{"%v":{"_index":"%v", "_type": "%v", "_id":"%v"}}%v`,
		opType, ExchangeIndex, ExchangeTradeType, trxInfo.Hash, "\n")

	tmp := &ExchangeTransactionInfo{
		BlockID:          trxInfo.BlockID,
		CreateTime:       trxInfo.CreateTime,
		Hash:             trxInfo.Hash,
		Confiremd:        trxInfo.Confiremd,
		ContractType:     trxInfo.ContractType,
		ContractTypeName: trxInfo.ContractTypeName,
		Owner:            trxInfo.Owner,

		ExchangeID: ctx.ExchangeId,
		TokenID:    string(ctx.TokenId),
		Quant:      ctx.Quant,
		Expected:   ctx.Expected,
	}
	ret += utils.ToJSONStr(tmp)
	ret += "\n"
	return ret
}
