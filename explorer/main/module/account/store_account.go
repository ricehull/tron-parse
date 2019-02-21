package account

import (
	"database/sql"
	"fmt"
	"time"

	"tron-parse/explorer/core/utils"
)

// StoreAccountBatch ...handle each
func StoreAccountBatch(accountList []*Account, dbb *sql.DB) bool {
	var startPos, accLen, step int
	accLen = len(accountList)
	step = 100
	for startPos+step < accLen {
		StoreAccount(accountList[startPos:startPos+step], dbb)
		startPos += step
	}
	return StoreAccount(accountList[startPos:], dbb)
}

// StoreAccount 将accountList保存到数据库
func StoreAccount(accountList []*Account, dbb *sql.DB) bool {
	if nil == dbb {
		return false
	}

	ts := time.Now()
	txn, err := dbb.Begin()
	if err != nil {
		fmt.Printf("get db failed:%v\n", err)
		return false
	}

	sqlI := `insert into tron_account 
		(account_name, address, balance, create_time, latest_operation_time, is_witness, asset_issue_name,
			frozen, allowance, latest_withdraw_time, latest_consume_time, latest_consume_free_time, votes,
			net_usage, free_net_used,
			free_net_limit, net_used, net_limit, total_net_limit, total_net_weight, asset_net_used, asset_net_limit
			, account_type, frozen_supply, is_committee, latest_asset_operation_time, account_resource, assets, 
			acc_res, energy_used, energy_limit, total_energy_limit, total_energy_weight, storage_used, storage_limit) values 
		(?, ?, ?, ?, ?, ?, ?,
			?, ?, ?, ?, ?, ?, ?, ?,
			?, ?, ?, ?, ?, ?, ?, ?,
			?, ?, ?, ?, ?, 
			?, ?, ?, ?, ?, ?, ?)`
	stmtI, err := txn.Prepare(sqlI)
	if nil != stmtI {
		defer stmtI.Close()
	}
	if nil != err {
		fmt.Printf("prepare insert tron_account SQL failed:%v, stmtI:%v\n", err, stmtI)
		return false
	}

	sqlU := `update tron_account set account_name = ?, balance = ?, latest_operation_time = ?, is_witness = ?, asset_issue_name = ?,
		frozen = ?, allowance = ?, latest_withdraw_time = ?, latest_consume_time = ?, latest_consume_free_time = ?, votes = ?, net_usage = ?,
		free_net_used = ?, free_net_limit = ?, net_used = ?, net_limit = ?, total_net_limit = ?, total_net_weight = ?, asset_net_used = ?, asset_net_limit = ?
		, account_type = ?, frozen_supply = ?, is_committee = ?, latest_asset_operation_time = ?, account_resource = ?, assets = ?, 
		acc_res = ?, energy_used = ?, energy_limit = ?, total_energy_limit = ?, total_energy_weight = ?, storage_used = ?, storage_limit = ?
		where address = ? `
	stmtU, err := txn.Prepare(sqlU)
	if nil != stmtU {
		defer stmtU.Close()
	}
	if nil != err {
		fmt.Printf("prepare update tron_account SQL failed:%v\n", err)
		return false
	}

	sqlBI := "insert into account_asset_balance (address, asset_name, balance) values (?, ?, ?)"
	stmtBI, err := txn.Prepare(sqlBI)
	if nil != stmtBI {
		defer stmtBI.Close()
	}
	if nil != err {
		fmt.Printf("prepare insert account_asset_balance SQL failed:%v\n", err)
		return false
	}

	sqlVI := "insert into account_vote_result (address, to_address, vote) values (?, ?, ?)"
	stmtVI, err := txn.Prepare(sqlVI)
	if nil != stmtVI {
		defer stmtVI.Close()
	}
	if nil != err {
		fmt.Printf("prepare insert account_vote_result SQL failed:%v\n", err)
		return false
	}

	insertCnt := 0
	updateCnt := 0
	errCnt := 0

	for _, acc := range accountList {

		_, err := stmtI.Exec(
			acc.Name,
			acc.Addr,
			acc.Raw.Balance,
			acc.Raw.CreateTime,
			acc.Raw.LatestOprationTime,
			acc.IsWitness,
			acc.AssetIssueName,
			acc.Fronzen,
			acc.Raw.Allowance,
			acc.Raw.LatestWithdrawTime,
			acc.Raw.LatestConsumeTime,
			acc.Raw.LatestConsumeFreeTime,
			acc.Votes,
			acc.Raw.NetUsage,
			acc.freeNetUsed,
			acc.freeNetLimit,
			acc.netUsed,
			acc.netLimit,
			acc.totalNetLimit,
			acc.totalNetWeight,
			acc.AssetNetUsed,
			acc.AssetNetLimit,
			acc.Raw.Type,
			utils.ToJSONStr(acc.Raw.FrozenSupply),
			acc.Raw.IsCommittee,
			utils.ToJSONStr(acc.Raw.LatestAssetOperationTime),
			utils.ToJSONStr(acc.Raw.AccountResource),
			utils.ToJSONStr(acc.Raw.Asset),
			utils.ToJSONStr(acc.ResRaw),
			acc.EnergyUsed,
			acc.EnergyLimit,
			acc.TotalEnergyLimit,
			acc.TotalEnergyWeight,
			acc.StorageUsed,
			acc.StorageLimit)

		if err != nil {
			// fmt.Printf("insert into account failed:%v-->[%v]\n", err, acc.Addr)

			result, err := stmtU.Exec(
				acc.Name,
				acc.Raw.Balance,
				acc.Raw.LatestOprationTime,
				acc.IsWitness,
				acc.AssetIssueName,
				acc.Fronzen,
				acc.Raw.Allowance,
				acc.Raw.LatestWithdrawTime,
				acc.Raw.LatestConsumeTime,
				acc.Raw.LatestConsumeFreeTime,
				acc.Votes,
				acc.Raw.NetUsage,
				acc.freeNetUsed,
				acc.freeNetLimit,
				acc.netUsed,
				acc.netLimit,
				acc.totalNetLimit,
				acc.totalNetWeight,
				acc.AssetNetUsed,
				acc.AssetNetLimit,
				acc.Raw.Type,
				utils.ToJSONStr(acc.Raw.FrozenSupply),
				acc.Raw.IsCommittee,
				utils.ToJSONStr(acc.Raw.LatestAssetOperationTime),
				utils.ToJSONStr(acc.Raw.AccountResource),
				utils.ToJSONStr(acc.Raw.Asset),
				utils.ToJSONStr(acc.ResRaw),
				acc.EnergyUsed,
				acc.EnergyLimit,
				acc.TotalEnergyLimit,
				acc.TotalEnergyWeight,
				acc.StorageUsed,
				acc.StorageLimit,
				acc.Addr)

			if err != nil {
				errCnt++
				// fmt.Printf("update account failed:%v-->[%v]\n", err, acc.Addr)
			} else {
				_ = result
				// _, err := result.RowsAffected()
				// if nil != err {
				// 	errCnt++
				// 	// fmt.Printf("update failed:%v, affectRow:%v--->%v\n", err, affectRow, acc.Addr)
				// } else {
				updateCnt++
				// }
				// fmt.Printf("update account ok!!!\n")
			}
		} else {
			insertCnt++
			// fmt.Printf("Insert account ok!!!\n")
		}

		result, err := txn.Exec("delete from account_asset_balance where address = ?", acc.Addr)
		_ = result

		for k, v := range acc.AssetBalance {
			_, err := stmtBI.Exec(acc.Addr, k, v)
			if nil != err {
				fmt.Printf("insert account_asset_balance failed:%v\n", err)
			}
		}

		result, err = txn.Exec("delete from account_vote_result where address = ?", acc.Addr)

		for _, vote := range acc.Raw.Votes {
			_, err := stmtVI.Exec(acc.Addr, utils.Base58EncodeAddr(vote.VoteAddress), vote.VoteCount)
			if nil != err {
				fmt.Printf("insert account_asset_balance failed:%v\n", err)
			}
		}

	}

	err = txn.Commit()
	if err != nil {
		fmt.Printf("connit block failed:%v\n", err)
		return false
	}
	fmt.Printf("store account OK, cost:%v, insertCnt:%v, updateCnt:%v, errCnt:%v, total source:%v\n", time.Since(ts), insertCnt, updateCnt, errCnt, len(accountList))

	return true
}
