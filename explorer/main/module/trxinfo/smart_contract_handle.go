package trxinfo

import (
	"fmt"
	"sync"
	"time"

	"github.com/tronprotocol/grpc-gateway/core"
	"tron-parse/explorer/core/grpcclient"
)

// FuncUpdate ...
type FuncUpdate func(trxHash string, blockID int64, trxInfo *core.TransactionInfo) error

type transactionInfoTask struct {
	TrxHash string
	BlockID int64
	Updater FuncUpdate
}

// SyncWorker ...
type SyncWorker struct {
	TaskChan chan *transactionInfoTask

	clients chan *grpcclient.Wallet

	quit chan struct{}
}

// Push ...
func (tiw *SyncWorker) Push(trxHash string, blockID int64, updater FuncUpdate) {
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
func (tiw *SyncWorker) Start() {
	workCnt := len(tiw.clients)
	for i := 0; i < workCnt; i++ {
		go tiw.worker()
	}
}

// Stop ...
func (tiw *SyncWorker) Stop() {
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

// StartStatusWatch ...
func (tiw *SyncWorker) StartStatusWatch() {
watchLoop:
	for {
		select {
		case <-tiw.quit:
			break watchLoop
		default:
			fmt.Printf("trxInfo rest task:%v\n", len(tiw.TaskChan))
			time.Sleep(10 * time.Second)
		}
	}
}

// RestTask ...
func (tiw *SyncWorker) RestTask() int {
	return len(tiw.TaskChan)
}

func (tiw *SyncWorker) worker() {
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

func (tiw *SyncWorker) handleTask(inClient *grpcclient.Wallet, task *transactionInfoTask) (client *grpcclient.Wallet, err error) {
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
var _trxInfoWorker *SyncWorker

var trxTaskLen = 5120
var trxWorkerCnt = 1

// GetTrxInfoWorker ...
func GetTrxInfoWorker() *SyncWorker {
	_onceTrxInfoWorker.Do(func() {
		_trxInfoWorker = new(SyncWorker)
		_trxInfoWorker.TaskChan = make(chan *transactionInfoTask, trxTaskLen)
		_trxInfoWorker.clients = make(chan *grpcclient.Wallet, trxWorkerCnt)
		for i := 0; i < trxWorkerCnt; i++ {
			_trxInfoWorker.clients <- grpcclient.GetRandomWallet()
		}
		_trxInfoWorker.quit = make(chan struct{})
		_trxInfoWorker.Start()
		go _trxInfoWorker.StartStatusWatch()
	})
	return _trxInfoWorker
}
