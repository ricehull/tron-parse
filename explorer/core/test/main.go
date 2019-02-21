package main

import (
	"fmt"
	"sync"
	"time"

	"tron-parse/explorer/core/grpcclient"
)

func main() {

	doJob(1000)
	time.Sleep(5 * time.Second)

	doJob(300)
	time.Sleep(6 * time.Second)

	doJob(400)
	time.Sleep(7 * time.Second)

	doJob(200)
	time.Sleep(8 * time.Second)

	doJob(300)
	time.Sleep(9 * time.Second)

	doJob(200)
	time.Sleep(9 * time.Second)

	doJob(300)
	time.Sleep(9 * time.Second)
}

var wg sync.WaitGroup

func doJob(n int) {
	ts := time.Now()
	for i := 0; i < n; i++ {
		wg.Add(1)
		go func() {
			c := grpcclient.GetRandomWallet()
			b, err := c.GetNowBlock()
			if nil != err || nil == b || nil == b.BlockHeader || nil == b.BlockHeader.RawData {
				fmt.Printf("client [%v-->%v] can't work\n", c.Target(), c.GetState())
			}
			c.Close()
			wg.Done()
		}()
	}
	wg.Wait()
	fmt.Printf("doJob Done work:[%v], cost:[%v]\n", n, time.Since(ts))
	fmt.Println(grpcclient.GetConnectionPoolState())
}
