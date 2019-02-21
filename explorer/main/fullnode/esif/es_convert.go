package main

import (
	"github.com/tronprotocol/grpc-gateway/core"
	"tron-parse/explorer/core/grpcclient"
)

func getTransactionInfo(trxHash string) (*core.TransactionInfo, error) {
	client := grpcclient.GetRandomWallet()
	trxInfo, err := client.GetTransactionInfoByID(trxHash)
	client.Close()
	return trxInfo, err
}
