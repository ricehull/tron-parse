package main

import (
	"testing"

	"github.com/tronprotocol/grpc-gateway/core"
	"tron-parse/explorer/core/grpcclient"
)

func TestCreateSmart(*testing.T) {

	Test = true
	client := grpcclient.GetRandomWallet()
	// block, _ := client.GetBlockByNum(3844838)
	block, _ := client.GetBlockByNum(4156118)

	blocks := []*core.Block{block}

	url := "http://localhost:9200"
	ESDeleteIndex(url, SmartCreateIndex)
	ESCreateIndex(url, SmartCreateIndex)
	initESNodes(url)
	storeBlocks(blocks, true)
}
