package main

import (
	"flag"
	"os"
	"os/signal"
	"sync"
	"syscall"
	"time"

	"fmt"

	_ "github.com/go-sql-driver/mysql"
	"tron-parse/explorer/core/utils"
)

var gIntMaxWorker = flag.Int("worker", 60, "maximum worker for fetch blocks")
var gStrMysqlDSN = flag.String("dsn", "tron:tron@tcp(172.16.21.224:3306)/tron", "mysql connection string(DSN)")
var gInt64MaxWorkload = flag.Int64("workload", 10000, "maximum workload for each worker")
var gStartBlokcID = flag.Int64("start_block", 0, "block num start to synchronize")
var gEndBlokcID = flag.Int64("end_block", 0, "block num end to synchronize, default 0 means run as daemon")

// var gRedisDSN = flag.String("redisDSN", "127.0.0.1:6379", "redis DSN")
var gMaxErrCntPerNode = flag.Int("max_err_per_node", 10, "max error before we try to other node")
var gIntHandleAccountInterval = flag.Int("account_handle_interval", 3, "account info synchronize handle minmum interval in seconds")
var gMaxTrxDB = flag.Int("trxdb_oper_cnt", 8, "the block/transaction db operation routine limit at the same time")
var gNetType = flag.String("net", "main", "connect to main net or test net, default main net")
var gAccountWorkerQueue = flag.Int("acc_worker_queue", 100000, "account address queue size for sync")

var gAccUniqBufferTime = flag.Int("acc_uniq_buffer_time", 10, "account sync unqiue buffer data time gap in second")
var gAccRecordPerCommit = flag.Int("acc_record_per_commit", 1000, "account sync to db record count per transaction")

var gNetName = flag.String("net_name", "", "net name, now we have main net and shasta net(node list group), both have test test")

var quit = make(chan struct{}) // quit signal channel
var wg sync.WaitGroup

func signalHandle() {
	sigs := make(chan os.Signal, 1)

	signal.Notify(sigs, syscall.SIGINT, syscall.SIGTERM)

	go func() {
		for {
			sig := <-sigs
			fmt.Printf("Receive signal:%v\n", sig)
			if !needQuit() {
				close(quit)
			}
		}
	}()
}

func needQuit() bool {
	select {
	case <-quit:
		return true
	default:
		return false
	}
}

func startDaemon() {
	if *gEndBlokcID == 0 { // do not start daemon if end_block is not zero
		go startAssetDaemon()
		go startWintnessDaemon()
		go startNodeDaemon()
	}
	// startRedisAccountRefreshPush()
	startAccountDaemonNew()
	GetTrxInfoWorker() // init TrxInfoWorker()
}

func main() {
	flag.Parse()
	initDBLimit()

	var netName = "main"
	var netType = "main"

	if *gNetType == "test" {
		utils.TestNet = true
		// setTestNetRedisKey()
		netType = "test"
	}
	if utils.NetShasta == *gNetName {
		utils.NetName = utils.NetShasta
		netName = utils.NetShasta
	}

	fmt.Printf("NetName:[%v], NetType:[%v]\n", netName, netType)

	maxErrCnt = *gMaxErrCntPerNode

	signalHandle()

	initDB(*gStrMysqlDSN)

	startDaemon()

	getAllBlocks()
	if !needQuit() {
		close(quit)
	}

	fmt.Println("Wait other daemon quit .......")
	wg.Wait()
	GetTrxInfoWorker().Stop()
	accWorker.WaitStop()

	fmt.Println("fullnode QUIT")
}

func getAllBlocks() {
	wc1 = newWorkerCounter(*gIntMaxWorker)
	ts := time.Now()
	getBlock(0, *gStartBlokcID, *gEndBlokcID)
	fmt.Printf("get all blocks cost:%v\n", time.Since(ts))
}
