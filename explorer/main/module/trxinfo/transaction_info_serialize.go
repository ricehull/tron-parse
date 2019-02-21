package trxinfo

import (
	"fmt"

	"tron-parse/explorer/main/module/account"
	"tron-parse/explorer/main/module/rawmysql"

	"github.com/tronprotocol/grpc-gateway/core"
	"tron-parse/explorer/core/utils"
)

// HandleSmartCreateCtx ...
func HandleSmartCreateCtx(trxHash string, blockID int64) {
	GetTrxInfoWorker().Push(trxHash, blockID, updateSmartContract)
	// fmt.Printf("add create smart task, trxHash:[%v]\n", trxHash)
}

func handleTriggerSmartCtx(trxHash string, blockID int64) {
	// GetTrxInfoWorker().Push(trxHash, blockID, updateTrxInfo)
	// fmt.Printf("add create smart task, trxHash:[%v]\n", trxHash)
}

var (
	errInvalidDBTransaction    = fmt.Errorf("Invalid db transaction")
	errInvalidDBConnection     = fmt.Errorf("Invalid db connection")
	errInvalidTrxInfo          = fmt.Errorf("Invalid Trx info")
	errGetTraxInfoByGRPCFailed = fmt.Errorf("Get transactionInfo failed")
)

// updateSmartContract update create smart contract info and update it info to db
func updateSmartContract(trxHash string, blockID int64, trxInfo *core.TransactionInfo) error {
	if nil == trxInfo || nil == trxInfo.Receipt {
		fmt.Printf("[ERROR] invalid trx info for trx:[%v] block:[%v], trxInfo:%#v\n", trxHash, blockID, trxInfo)
		return errInvalidTrxInfo
	}
	dbb := rawmysql.GetMysqlDB()
	if nil == dbb {
		return errInvalidDBConnection
	}
	txn, err := dbb.Begin()
	if nil != err {
		return err
	}
	if nil == txn {
		return errInvalidDBTransaction
	}

	_, err = txn.Exec(`update contract_create_smart set contract_address = ? where block_id = ? and trx_hash = ?`, utils.Base58EncodeAddr(trxInfo.ContractAddress), blockID, trxHash)
	if nil != err {
		fmt.Printf("[ERROR] update create smart contract, trx_hash:[%v], blockID:[%v] failed:%v\n", trxHash, blockID, err)
		return err
	}
	err = txn.Commit()
	if nil != err {
		return err
	}
	account.GetSyncWorker().AppendTask2([][]byte{trxInfo.ContractAddress})
	// err = updateTrxInfo(trxHash, blockID, trxInfo)
	// if nil != err {
	// 	return err
	// }
	return err
}

// updateTrxInfo update create smart contract info and update it info to db
func updateTrxInfo(trxHash string, blockID int64, trxInfo *core.TransactionInfo) error {
	if nil == trxInfo || nil == trxInfo.Receipt {
		fmt.Printf("[ERROR] invalid trx info for trx:[%v] block:[%v], trxInfo:%#v\n", trxHash, blockID, trxInfo)
		return errInvalidTrxInfo
	}

	dbb := rawmysql.GetMysqlDB()
	if nil == dbb {
		return errInvalidDBConnection
	}
	txn, err := dbb.Begin()
	if nil != err {
		return err
	}
	if nil == txn {
		return errInvalidDBTransaction
	}

	_, err = txn.Exec(`insert into transaction_info (trx_hash, block_id, 
		id, block_num, block_timestamp, contract_address, contract_result, 
		receipt_energy_usage, receipt_energy_fee, receipt_origin_energy_usage, receipt_energy_usage_total, receipt_net_usage, receipt_net_fee,
		log, result, res_message, withdraw_amount, unfreeze_amount) values (?, ?,
		?, ?, ?, ?, ?,
		?, ?, ?, ?, ?, ?,
		?, ?, ?, ?, ?)`,
		trxHash, blockID,
		utils.HexEncode(trxInfo.Id), trxInfo.BlockNumber, trxInfo.BlockTimeStamp, utils.Base58EncodeAddr(trxInfo.ContractAddress), utils.ToJSONStr(trxInfo.ContractResult),
		trxInfo.Receipt.EnergyUsage, trxInfo.Receipt.EnergyFee, trxInfo.Receipt.OriginEnergyUsage, trxInfo.Receipt.EnergyUsageTotal, trxInfo.Receipt.NetUsage, trxInfo.Receipt.NetFee,
		utils.ToJSONStr(trxInfo.Log), trxInfo.Result, string(trxInfo.ResMessage), trxInfo.WithdrawAmount, trxInfo.UnfreezeAmount)
	if nil != err {
		fmt.Printf("[ERROR] insert transaction_info failed:%v\n", err)
		return err
	}
	err = txn.Commit()
	return err
}
