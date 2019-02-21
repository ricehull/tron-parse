package main

import (
	"flag"
	"fmt"
	"os"
	"os/signal"
	"strings"
	"sync"
	"syscall"
	"time"

	"tron-parse/explorer/core/utils"
)

var gIntMaxWorker = flag.Int("worker", 60, "maximum worker for fetch blocks")
var gInt64MaxWorkload = flag.Int64("workload", 1000, "maximum workload for each worker")
var gStartBlokcID = flag.Int64("start_block", 0, "block num start to synchronize")
var gEndBlokcID = flag.Int64("end_block", 0, "block num end to synchronize, default 0 means run as daemon")

var gNetType = flag.String("net", "main", "connect to main net or test net, default main net")

var gNetName = flag.String("net_name", "", "net name, now we have main net and shasta net(node list group), both have test test")

var gESNodes = flag.String("es_node", "http://47.52.142.218:9200,http://47.52.142.218:9200,http://47.52.142.218:9200", "es node url list seperated by \",\"")

var gAction = flag.String("action", "sync", "program action, sync: synchronize data to es; reindex: recreate index")

var gTest = flag.Bool("test", false, "if open test")
var quit = make(chan struct{}) // quit signal channel

var gParseCtx = flag.Bool("parseContract", false, "if need parse transaction to contract detail")
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

func main() {
	flag.Parse()

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

	fmt.Printf("NetName:[%v], NetType:[%v], ESNodes:[%v]\n", netName, netType, *gESNodes)

	initESNodes(*gESNodes)

	signalHandle()

	if *gTest {
		Test = true
	}

	if "reindex" == *gAction {
		resetESIndex()
		return
	}
	// checkIndex()

	getAllBlocks()
	if !needQuit() {
		close(quit)
	}

	fmt.Println("Wait other daemon quit .......")

	fmt.Println("fullnode QUIT")
}

func initESNodes(nodeList string) {
	list := strings.Split(nodeList, ",")

	esURLChan = make(chan string, len(list))
	for _, node := range list {
		esURLChan <- node
	}
}

func getAllBlocks() {
	wc1 = newWorkerCounter(*gIntMaxWorker)
	ts := time.Now()
	getBlock(0, *gStartBlokcID, *gEndBlokcID)
	fmt.Printf("get all blocks cost:%v\n", time.Since(ts))
}

func resetESIndex() {
	url := getESURL()
	defer releaseESURL(url)

	ESDeleteIndex(url, BlockIndex)
	ESCreateIndex(url, BlockIndex)
	ESAddMapping(url, BlockIndex, BlockType, BlockInfoMaping)

	ESDeleteIndex(url, TransactionIndex)
	ESCreateIndex(url, TransactionIndex)
	ESAddMapping(url, TransactionIndex, TransactionType, TransactionMapping)

	ESDeleteIndex(url, ExchangeIndex)
	ESCreateIndex(url, ExchangeIndex)
	ESAddMapping(url, ExchangeIndex, ExchangeTradeType, ExchangeTradeMapping)

	ESDeleteIndex(url, SmartIndex)
	ESCreateIndex(url, SmartIndex)
	ESAddMapping(url, SmartIndex, SmartTriggerType, SmartTriggerMapping)

	ESDeleteIndex(url, TransferIndex)
	ESCreateIndex(url, TransferIndex)
	ESAddMapping(url, TransferIndex, TransferType, TransferMapping)

	ESDeleteIndex(url, SmartCreateIndex)
	ESCreateIndex(url, SmartCreateIndex)
	ESAddMapping(url, SmartCreateIndex, SmartCreateType, SmartCreateMapping)
}
