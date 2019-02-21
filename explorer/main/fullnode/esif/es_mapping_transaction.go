package main

import (
	"encoding/json"

	"github.com/golang/protobuf/proto"
	"github.com/tronprotocol/grpc-gateway/core"
	"tron-parse/explorer/core/utils"
)

// TransactionInfo ...
type TransactionInfo struct {
	BlockID          int64
	CreateTime       int64
	Hash             string
	Confiremd        bool
	Owner            string
	To               string
	Signature        string
	ContractType     int32
	ContractTypeName string
	ContractRaw      string
	ContractDetail   interface{}
	Result           interface{}
	RawCreateTime    int64
	RefBlockNum      int64
	RefBlockByte     string
	RefBlockHash     string
	Expiration       int64
	Data             string
	FeeLimit         int64
	Script           string
}

// Transaction Mapping ...
var (
	TransactionIndex = "transactions"
	TransactionType  = "transaction"

	TransactionMapping = []byte(`
{
	"properties": {
		"BlockID": {
			"type": "long"
		},
		"Confiremd": {
			"type": "boolean"
		},
		"ContractDetail": {
			"type": "nested",
			"properties": {
				"abbr": {
					"type": "text"
				},
				"account_address": {
					"type": "keyword"
				},
				"account_name": {
					"type": "keyword"
				},
				"amount": {
					"type": "long"
				},
				"asset_name": {
					"type": "text"
				},
				"call_value": {
					"type": "long"
				},
				"contract_address": {
					"type": "keyword"
				},
				"data": {
					"type": "keyword"
				},
				"description": {
					"type": "keyword"
				},
				"end_time": {
					"type": "long"
				},
				"exchange_id": {
					"type": "long"
				},
				"expected": {
					"type": "long"
				},
				"frozen_balance": {
					"type": "long"
				},
				"frozen_duration": {
					"type": "long"
				},
				"frozen_supply": {
					"type": "nested",
					"properties": {
						"frozen_amount": {
							"type": "long"
						},
						"frozen_days": {
							"type": "long"
						}
					}
				},
				"name": {
					"type": "text"
				},
				"new_contract": {
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
												"name": {
													"type": "keyword"
												},
												"type": {
													"type": "keyword"
												}
											}
										},
										"name": {
											"type": "text"
										},
										"outputs": {
											"type": "nested",
											"properties": {
												"name": {
													"type": "keyword"
												},
												"type": {
													"type": "keyword"
												}
											}
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
						"consume_user_resource_percent": {
							"type": "long"
						},
						"name": {
							"type": "text"
						},
						"origin_address": {
							"type": "keyword"
						}
					}
				},
				"num": {
					"type": "long"
				},
				"owner_address": {
					"type": "keyword"
				},
				"quant": {
					"type": "long"
				},
				"resource": {
					"type": "long"
				},
				"start_time": {
					"type": "long"
				},
				"to_address": {
					"type": "keyword"
				},
				"token_id": {
					"type": "text"
				},
				"total_supply": {
					"type": "long"
				},
				"trx_num": {
					"type": "long"
				},
				"type": {
					"type": "long"
				},
				"update_url": {
					"type": "keyword"
				},
				"url": {
					"type": "keyword"
				},
				"votes": {
					"type": "nested",
					"properties": {
						"vote_address": {
							"type": "keyword"
						},
						"vote_count": {
							"type": "long"
						}
					}
				}
			}
		},
		"ContractRaw": {
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
		"Data": {
			"type": "keyword"
		},
		"Expiration": {
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
		"RawCreateTime": {
			"type": "long"
		},
		"RefBlockByte": {
			"type": "keyword"
		},
		"RefBlockHash": {
			"type": "keyword"
		},
		"RefBlockNum": {
			"type": "long"
		},
		"Result": {
			"type": "nested",
			"properties": {
				"contractRet": {
					"type": "long"
				}
			}
		},
		"Script": {
			"type": "keyword"
		},
		"Signature": {
			"type": "keyword"
		},
		"To": {
			"type": "keyword"
		}
	}
}`)
)

// ConverTransaction ...
func ConverTransaction(transaction *core.Transaction, confirmed bool, blockID int64, createTime int64) *TransactionInfo {

	trxSig, _ := json.Marshal(transaction.Signature)
	_, ctxDetail := utils.GetContract(transaction.RawData.Contract[0])
	// ctxDetail, _ := utils.GetContractInfoObj(transaction.RawData.Contract[0])
	contractRaw, _ := proto.Marshal(transaction.RawData.Contract[0])
	ownerAddr, toAddr := utils.GetTransactionAddress(transaction)
	ret := &TransactionInfo{
		BlockID:          blockID,
		CreateTime:       createTime,
		Hash:             utils.HexEncode(utils.CalcTransactionHash(transaction)),
		Confiremd:        confirmed,
		Owner:            ownerAddr,
		To:               toAddr,
		Signature:        utils.HexEncode(trxSig),
		ContractType:     int32(transaction.RawData.Contract[0].Type),
		ContractTypeName: transaction.RawData.Contract[0].Type.String(),
		ContractRaw:      utils.HexEncode(contractRaw),
		ContractDetail:   ctxDetail,
		Result:           transaction.Ret,
		RawCreateTime:    transaction.RawData.Timestamp,
		RefBlockNum:      transaction.RawData.RefBlockNum,
		RefBlockByte:     utils.HexEncode(transaction.RawData.RefBlockBytes),
		RefBlockHash:     utils.HexEncode(transaction.RawData.RefBlockHash),
		Expiration:       transaction.RawData.Expiration,
		Data:             utils.HexEncode(transaction.RawData.Data),
		FeeLimit:         transaction.RawData.FeeLimit,
		Script:           utils.HexEncode(transaction.RawData.Scripts),
	}

	return ret
}
