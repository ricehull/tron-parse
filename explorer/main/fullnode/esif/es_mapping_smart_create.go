package main

import (
	"fmt"

	"github.com/tronprotocol/grpc-gateway/core"
	"tron-parse/explorer/core/utils"
)

// smart mapping
var (
	SmartCreateIndex   = "smartcreates"
	SmartCreateType    = "create"
	SmartCreateMapping = []byte(`
{
	"properties": {
		"ABI": {
			"type": "keyword"
		},
		"BlockID": {
			"type": "long"
		},
		"ByteCode": {
			"type": "keyword"
		},
		"CallTokenValue": {
			"type": "long"
		},
		"CallVaue": {
			"type": "long"
		},
		"Confiremd": {
			"type": "boolean"
		},
		"ConsumeUserResourcePercent": {
			"type": "long"
		},
		"ContractAddress": {
			"type": "keyword"
		},
		"ContractDetail": {
			"type": "nested",
			"properties": {
				"abi": {
					"type": "nested",
					"properties": {
						"entrys": {
							"type": "nested",
							"properties": {
								"constant": {
									"type": "boolean"
								},
								"inputs": {
									"type": "nested",
									"properties": {
										"indexed": {
											"type": "boolean"
										},
										"name": {
											"type": "keyword"
										},
										"type": {
											"type": "keyword"
										}
									}
								},
								"name": {
									"type": "keyword"
								},
								"outputs": {
									"type": "nested",
									"properties": {
										"type": {
											"type": "keyword"
										}
									}
								},
								"payable": {
									"type": "boolean"
								},
								"stateMutability": {
									"type": "long"
								},
								"type": {
									"type": "long"
								}
							}
						}
					}
				},
				"bytecode": {
					"type": "keyword"
				},
				"name": {
					"type": "keyword"
				},
				"origin_address": {
					"type": "keyword"
				}
			}
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
		"Hash": {
			"type": "keyword"
		},
		"Name": {
			"type": "keyword"
		},
		"OriginAddress": {
			"type": "keyword"
		},
		"OriginEnergyLimit": {
			"type": "long"
		},
		"Owner": {
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
)

// CreateSmartContractInfo ...
type CreateSmartContractInfo struct {
	BlockID          int64
	CreateTime       int64
	Hash             string
	Confiremd        bool
	ContractType     int32
	ContractTypeName string
	Owner            string

	CallTokenValue             int64
	TokenID                    string
	ContractAddress            string
	ABI                        string
	ByteCode                   string
	CallVaue                   int64
	ConsumeUserResourcePercent int64
	Name                       string
	OriginEnergyLimit          int64
	OriginAddress              string
	ContractDetail             interface{}
	TransactionInfo            interface{}
}

func handleCreateSmart(trxInfo *TransactionInfo) string {

	ctxDetail := utils.GetContractFromRaw(utils.HexDecode(trxInfo.ContractRaw))
	if nil == ctxDetail {
		return ""
	}

	ctx, ok := ctxDetail.(*core.CreateSmartContract)
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
		opType, SmartCreateIndex, SmartCreateType, trxInfo.Hash, "\n")

	contractAddr := ""

	trxResult, _ := getTransactionInfo(trxInfo.Hash)
	if nil != trxResult {
		contractAddr = utils.Base58EncodeAddr(trxResult.ContractAddress)
	}

	tmp := &CreateSmartContractInfo{
		BlockID:          trxInfo.BlockID,
		CreateTime:       trxInfo.CreateTime,
		Hash:             trxInfo.Hash,
		Confiremd:        trxInfo.Confiremd,
		ContractType:     trxInfo.ContractType,
		ContractTypeName: trxInfo.ContractTypeName,
		Owner:            trxInfo.Owner,

		CallTokenValue:             ctx.CallTokenValue,
		TokenID:                    string(ctx.TokenId),
		ContractAddress:            contractAddr,
		ABI:                        utils.ToJSONStr(ctx.NewContract.Abi),
		ByteCode:                   utils.HexEncode(ctx.NewContract.Bytecode),
		CallVaue:                   ctx.NewContract.CallValue,
		ConsumeUserResourcePercent: ctx.NewContract.ConsumeUserResourcePercent,
		Name:                       ctx.NewContract.Name,
		OriginEnergyLimit:          ctx.NewContract.OriginEnergyLimit,
		OriginAddress:              utils.Base58EncodeAddr(ctx.NewContract.OriginAddress),
		ContractDetail:             ctx.NewContract,
		TransactionInfo:            trxResult,
	}
	ret += utils.ToJSONStr(tmp)
	ret += "\n"
	return ret
}
