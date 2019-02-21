package main

import (
	"fmt"
	"sync"

	"github.com/tronprotocol/grpc-gateway/core"
	"tron-parse/explorer/core/grpcclient"
	"tron-parse/explorer/core/utils"
)

// FuncUpdate ...
type FuncUpdate func(trxHash string, blockID int64, trxInfo *core.TransactionInfo) error

type transactionInfoTask struct {
	TrxHash string
	BlockID int64
	Updater FuncUpdate
}

// TrxInfoWorker ...
type TrxInfoWorker struct {
	TaskChan chan *transactionInfoTask

	clients chan *grpcclient.Wallet

	quit chan struct{}
}

// Push ...
func (tiw *TrxInfoWorker) Push(trxHash string, blockID int64, updater FuncUpdate) {
	defer func() {
		if panErr := recover(); nil != panErr {
			fmt.Printf("Push TrxInfo Worker failed:%v\n", panErr)
		}
	}()
	tiw.TaskChan <- &transactionInfoTask{
		trxHash, blockID, updater,
	}
}

// Start ...
func (tiw *TrxInfoWorker) Start() {
	workCnt := len(tiw.clients)
	for i := 0; i < workCnt; i++ {
		go tiw.worker()
	}
}

// Stop ...
func (tiw *TrxInfoWorker) Stop() {
	select {
	case <-tiw.quit:
		return
	default:
		close(tiw.quit)
	}
	restTask := len(tiw.TaskChan)
	fmt.Printf("trxInfoWorker rest task:%v\n", restTask)

	client := <-tiw.clients
	var err error
	for i := 0; i < restTask; i++ {
		task := <-tiw.TaskChan
		if nil == task {
			continue
		}

		tryCnt := 5
		for tryCnt > 0 {
			client, err = tiw.handleTask(client, task)
			if nil == err {
				break
			}
			tryCnt--
		}
	}
}

func (tiw *TrxInfoWorker) worker() {
	client := <-tiw.clients
	if nil == client {
		client = grpcclient.GetRandomWallet()
	}
	var totalTask int64

	var task *transactionInfoTask
	var err error
workLoop:
	for {
		task = nil
		select {
		case task = <-tiw.TaskChan:
		case <-tiw.quit:
			break workLoop
		}
		if nil == task {
			continue workLoop
		}

		client, err = tiw.handleTask(client, task)
		if nil != err {
			fmt.Printf("update smart ctx failed:[%v], err:%v\n", task.TrxHash, err)
			tiw.TaskChan <- task
		} else {
			// fmt.Printf("update smart ctx success:[%v]\n", task.TrxHash)
			totalTask++
		}
	}
	tiw.clients <- client
	fmt.Printf("worker quit, total task handle:%v\n", totalTask)
}

func (tiw *TrxInfoWorker) handleTask(inClient *grpcclient.Wallet, task *transactionInfoTask) (client *grpcclient.Wallet, err error) {
	client = inClient
	if nil == client {
		client = grpcclient.GetRandomWallet()
	}
	if nil == task {
		return
	}

	trxInfo, err1 := client.GetTransactionInfoByID(task.TrxHash)
	if nil != err1 || nil == trxInfo {
		fmt.Printf("GetTransactionInfoByID(%v) failed:%v-%v\n", task.TrxHash, trxInfo, err)
		client.Close()
		client = grpcclient.GetRandomWallet()
		return client, errGetTraxInfoByGRPCFailed
	}
	err = task.Updater(task.TrxHash, task.BlockID, trxInfo)
	return
}

var _onceTrxInfoWorker sync.Once
var _trxInfoWorker *TrxInfoWorker

var trxTaskLen = 5120
var trxWorkerCnt = 1

// GetTrxInfoWorker ...
func GetTrxInfoWorker() *TrxInfoWorker {
	_onceTrxInfoWorker.Do(func() {
		_trxInfoWorker = new(TrxInfoWorker)
		_trxInfoWorker.TaskChan = make(chan *transactionInfoTask, trxTaskLen)
		_trxInfoWorker.clients = make(chan *grpcclient.Wallet, trxWorkerCnt)
		for i := 0; i < trxWorkerCnt; i++ {
			_trxInfoWorker.clients <- grpcclient.GetRandomWallet()
		}
		_trxInfoWorker.quit = make(chan struct{})
		_trxInfoWorker.Start()
	})
	return _trxInfoWorker
}

func handleSmartCreateCtx(trxHash string, blockID int64) {
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
	dbb := getMysqlDB()
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

	AddRefreshAddress(trxInfo.ContractAddress)

	if nil != err {
		return err
	}
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

	dbb := getMysqlDB()
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
