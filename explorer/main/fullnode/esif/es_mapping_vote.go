package main

// VoteContractInfo ...
type VoteContractInfo struct {
	BlockID          int64
	CreateTime       int64
	Hash             string
	Confiremd        bool
	ContractType     int32
	ContractTypeName string
	Owner            string

	Votes   []interface{}
	Support bool
}

// func extractTransactionDetail(block *core.Block, confirmed bool, transaction *core.Transaction) string {
// 	switch transaction.RawData.
// 	return ""
// }

// func handleVoteWitness(trxInfo *TransactionInfo) string {
// 	ctxDetail := utils.GetContractFromRaw(utils.HexDecode(trxInfo.ContractRaw))
// 	if nil == ctxDetail {
// 		return ""
// 	}

// 	ctx, ok := ctxDetail.(*core.VoteWitnessContract)
// 	if !ok {
// 		return ""
// 	}

// 	Vote

// 	ret := fmt.Sprintf(`{"index":{"_index":"transfers", "_type": "transfer", "_id":"%v"}}%v`, trxInfo.Hash, "\n")
// 	tmp := &VoteContractInfo{
// 		BlockID:          trxInfo.BlockID,
// 		CreateTime:       trxInfo.CreateTime,
// 		Hash:             trxInfo.Hash,
// 		Confiremd:        trxInfo.Confiremd,
// 		ContractType:     trxInfo.ContractType,
// 		ContractTypeName: trxInfo.ContractTypeName,
// 		Owner:            trxInfo.Owner,

// 		Votes:   ctx.Votes,
// 		Support: ctx.Support,
// 	}
// 	ret += utils.ToJSONStr(tmp)
// 	ret += "\n"
// 	return ret
// }
