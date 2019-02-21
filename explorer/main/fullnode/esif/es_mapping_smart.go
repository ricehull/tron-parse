package main

import (
	"fmt"

	"github.com/tronprotocol/grpc-gateway/core"
	"tron-parse/explorer/core/utils"
)

// smart mapping
var (
	SmartIndex          = "smarts"
	SmartTriggerType    = "trigger"
	SmartTriggerMapping = []byte(`
{
    "properties": {
        "BlockID": {
            "type": "long"
        },
        "CallData": {
            "type": "keyword"
        },
        "CallTokenValue": {
            "type": "long"
        },
        "CallValue": {
            "type": "long"
        },
        "Confiremd": {
            "type": "boolean"
        },
        "ContractRet": {
            "type": "long"
        },
        "ContractRetString": {
            "type": "keyword"
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
        "FeeLimit": {
            "type": "long"
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
        },
        "TransactionInfo": {
			"type": "nested",
            "properties": {
                "blockNumber": {
                    "type": "long"
                },
                "blockTimeStamp": {
                    "type": "long"
                },
                "contractResult": {
                    "type": "text",
                    "fields": {
                        "keyword": {
                            "type": "keyword",
                            "ignore_above": 256
                        }
                    }
                },
                "contract_address": {
                    "type": "keyword"
                },
                "fee": {
                    "type": "long"
                },
                "id": {
                    "type": "keyword"
                },
                "log": {
        			"type": "nested",
                    "properties": {
                        "address": {
                            "type": "keyword"
                        },
                        "data": {
                            "type": "keyword"
                        },
                        "topics": {
                            "type": "keyword"
                        }
                    }
                },
                "receipt": {
			        "type": "nested",
                    "properties": {
                        "energy_usage_total": {
                            "type": "long"
                        },
                        "net_fee": {
                            "type": "long"
                        },
                        "net_usage": {
                            "type": "long"
                        },
                        "origin_energy_usage": {
                            "type": "long"
                        },
                        "result": {
                            "type": "long"
                        }
                    }
                },
                "resMessage": {
                    "type": "text",
                    "fields": {
                        "keyword": {
                            "type": "keyword",
                            "ignore_above": 256
                        }
                    }
                },
                "result": {
                    "type": "long"
                }
            }
        }
    }
}
`)

/* tr
,
        "TransactionInfo": {
			"type": "nested",
            "properties": {
                "blockNumber": {
                    "type": "long"
                },
                "blockTimeStamp": {
                    "type": "long"
                },
                "contractResult": {
                    "type": "text",
                    "fields": {
                        "keyword": {
                            "type": "keyword",
                            "ignore_above": 256
                        }
                    }
                },
                "contract_address": {
                    "type": "keyword"
                },
                "fee": {
                    "type": "long"
                },
                "id": {
                    "type": "keyword"
                },
                "log": {
        			"type": "nested",
                    "properties": {
                        "address": {
                            "type": "keyword"
                        },
                        "data": {
                            "type": "keyword"
                        },
                        "topics": {
                            "type": "keyword"
                        }
                    }
                },
                "receipt": {
			        "type": "nested",
                    "properties": {
                        "energy_usage_total": {
                            "type": "long"
                        },
                        "net_fee": {
                            "type": "long"
                        },
                        "net_usage": {
                            "type": "long"
                        },
                        "origin_energy_usage": {
                            "type": "long"
                        },
                        "result": {
                            "type": "long"
                        }
                    }
                },
                "resMessage": {
                    "type": "text",
                    "fields": {
                        "keyword": {
                            "type": "keyword",
                            "ignore_above": 256
                        }
                    }
                },
                "result": {
                    "type": "long"
                }
            }
        }
*/
)

// TriggerSmartContractInfo ...
type TriggerSmartContractInfo struct {
	BlockID          int64
	CreateTime       int64
	Hash             string
	Confiremd        bool
	ContractType     int32
	ContractTypeName string
	Owner            string

	To                string
	CallValue         int64
	CallData          string
	CallTokenValue    int64
	TokenID           string
	ContractRet       int64
	ContractRetString string
	FeeLimit          int64

	// TransactionInfo interface{}
}

func handleTriggerSmart(trxInfo *TransactionInfo) string {
	ctxDetail := utils.GetContractFromRaw(utils.HexDecode(trxInfo.ContractRaw))
	if nil == ctxDetail {
		return ""
	}

	ctx, ok := ctxDetail.(*core.TriggerSmartContract)
	if !ok {
		return ""
	}

	result, ok := trxInfo.Result.([]*core.Transaction_Result)
	if !ok || 0 == len(result) {
		return ""
	}

	// trxResultReal, _ := getTransactionInfo(trxInfo.Hash)

	opType := "create"
	if trxInfo.Confiremd {
		opType = "index"
	}

	ret := fmt.Sprintf(`{"%v":{"_index":"%v", "_type": "%v", "_id":"%v"}}%v`,
		opType, SmartIndex, SmartTriggerType, trxInfo.Hash, "\n")

	tmp := &TriggerSmartContractInfo{
		BlockID:          trxInfo.BlockID,
		CreateTime:       trxInfo.CreateTime,
		Hash:             trxInfo.Hash,
		Confiremd:        trxInfo.Confiremd,
		ContractType:     trxInfo.ContractType,
		ContractTypeName: trxInfo.ContractTypeName,
		Owner:            trxInfo.Owner,

		To:                utils.Base58EncodeAddr(ctx.ContractAddress),
		CallValue:         ctx.CallValue,
		CallData:          utils.HexEncode(ctx.Data),
		CallTokenValue:    ctx.CallTokenValue,
		TokenID:           string(ctx.TokenId),
		ContractRet:       int64(result[0].ContractRet),
		ContractRetString: result[0].ContractRet.String(),
		FeeLimit:          int64(trxInfo.FeeLimit),
		// TransactionInfo:   "",
	}

	ret += utils.ToJSONStr(tmp)
	ret += "\n"
	return ret
}
