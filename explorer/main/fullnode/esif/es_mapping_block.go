package main

import (
	"github.com/golang/protobuf/proto"
	"github.com/tronprotocol/grpc-gateway/core"
	"tron-parse/explorer/core/utils"
)

// BlockInfo ...
type BlockInfo struct {
	ID         int64
	Hash       string
	ParentHash string
	Confiremd  bool
	TrxNum     int
	Size       int
	Witness    string
	CreateTime int64
	TxTrieRoot string
}

// ConverBlock ...
func ConverBlock(block *core.Block, confiremd bool) *BlockInfo {
	blockRaw, _ := proto.Marshal(block)

	ret := &BlockInfo{
		ID:         block.BlockHeader.RawData.Number,
		Hash:       utils.HexEncode(utils.CalcBlockHash(block)),
		ParentHash: utils.HexEncode(block.BlockHeader.RawData.ParentHash),
		Confiremd:  confiremd,
		TrxNum:     len(block.Transactions),
		Size:       len(blockRaw),
		Witness:    utils.Base58EncodeAddr(block.BlockHeader.RawData.WitnessAddress),
		CreateTime: block.BlockHeader.RawData.Timestamp,
		TxTrieRoot: utils.HexEncode(block.BlockHeader.RawData.TxTrieRoot),
	}
	return ret
}

// BlockInfoMaping
var (
	BlockIndex      = "blocks"
	BlockType       = "block"
	BlockInfoMaping = []byte(`
{
	"properties": {
		"Confiremd": {
			"type": "boolean"
		},
		"CreateTime": {
			"type": "long"
		},
		"Hash": {
			"type": "keyword"
		},
		"ID": {
			"type": "long"
		},
		"ParentHash": {
			"type": "keyword"
		},
		"Size": {
			"type": "long"
		},
		"TrxNum": {
			"type": "long"
		},
		"TxTrieRoot": {
			"type": "keyword"
		},
		"Witness": {
			"type": "keyword"
		}
	}
}
`)
)
