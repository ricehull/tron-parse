package main

import (
	"fmt"

	"github.com/tronprotocol/grpc-gateway/core"
	"tron-parse/explorer/core/utils"
)

var (
	TransferIndex   = "transfers"
	TransferType    = "transfer"
	TransferMapping = []byte(`
{
    "properties": {
        "Amount": {
            "type": "long"
        },
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
        "Data": {
            "type": "keyword"
        },
        "Hash": {
            "type": "keyword"
        },
        "Owner": {
            "type": "keyword"
        },
        "To": {
            "type": "keyword"
        },
        "TokenID": {
            "type": "keyword"
        }
    }
}
`)
)

// TransferInfo ...
type TransferInfo struct {
	BlockID          int64
	CreateTime       int64
	Hash             string
	Confiremd        bool
	ContractType     int32
	ContractTypeName string
	Owner            string

	To      string
	TokenID string
	Amount  int64
	Data    string
}

func handleTransfer(trxInfo *TransactionInfo) string {
	ctxDetail := utils.GetContractFromRaw(utils.HexDecode(trxInfo.ContractRaw))
	if nil == ctxDetail {
		return ""
	}

	ctx, ok := ctxDetail.(*core.TransferContract)
	if !ok {
		return ""
	}

	opType := "create"
	if trxInfo.Confiremd {
		opType = "index"
	}

	ret := fmt.Sprintf(`{"%v":{"_index":"%v", "_type": "%v", "_id":"%v"}}%v`,
		opType, TransferIndex, TransferType, trxInfo.Hash, "\n")

	tmp := &TransferInfo{
		BlockID:          trxInfo.BlockID,
		CreateTime:       trxInfo.CreateTime,
		Hash:             trxInfo.Hash,
		Confiremd:        trxInfo.Confiremd,
		ContractType:     trxInfo.ContractType,
		ContractTypeName: trxInfo.ContractTypeName,
		Owner:            trxInfo.Owner,

		To:      utils.Base58EncodeAddr(ctx.ToAddress),
		TokenID: "",
		Amount:  ctx.Amount,
		Data:    trxInfo.Data,
	}
	ret += utils.ToJSONStr(tmp)
	ret += "\n"
	return ret
}

func handleTransferAsset(trxInfo *TransactionInfo) string {
	ctxDetail := utils.GetContractFromRaw(utils.HexDecode(trxInfo.ContractRaw))
	if nil == ctxDetail {
		return ""
	}

	ctx, ok := ctxDetail.(*core.TransferAssetContract)
	if !ok {
		return ""
	}

	opType := "create"
	if trxInfo.Confiremd {
		opType = "index"
	}

	ret := fmt.Sprintf(`{"%v":{"_index":"transfers", "_type": "transfer", "_id":"%v"}}%v`, opType, trxInfo.Hash, "\n")
	tmp := &TransferInfo{
		BlockID:          trxInfo.BlockID,
		CreateTime:       trxInfo.CreateTime,
		Hash:             trxInfo.Hash,
		Confiremd:        trxInfo.Confiremd,
		ContractType:     trxInfo.ContractType,
		ContractTypeName: trxInfo.ContractTypeName,
		Owner:            trxInfo.Owner,

		To:      utils.Base58EncodeAddr(ctx.ToAddress),
		TokenID: string(ctx.AssetName),
		Amount:  ctx.Amount,
		Data:    trxInfo.Data,
	}
	ret += utils.ToJSONStr(tmp)
	ret += "\n"
	return ret
}
