package main

import (
	"bytes"
	"fmt"
	"io/ioutil"
	"net/http"
	"testing"
	"time"

	"github.com/valyala/fasthttp"
	"tron-parse/explorer/core/grpcclient"
)

func TestGenIdx(*testing.T) {

	indexName := "transactions"

	url := "http://localhost:9200"

	fmt.Println(ESDeleteIndex(url, indexName))

	fmt.Println(ESCreateIndex(url, indexName))

	// fmt.Println(ESAddMapping(url, indexName, "block", BlockInfoMaping))
	fmt.Println(ESAddMapping(url, "transactions", "transaction", TransactionMapping))

	return
	buff := &bytes.Buffer{}

	req, err := http.NewRequest("PUT", url, buff)
	if err != nil || nil == req {
		fmt.Printf("create request failed:%v\n", err)
		return
	}

	client := &http.Client{}
	resp, err := client.Do(req)
	if nil != err || nil == resp {
		fmt.Printf("request failed:%v\n", err)
		return
	}
	respBody, err := ioutil.ReadAll(resp.Body)
	resp.Body.Close()
	if err != nil {
		fmt.Printf("read resp failed:%v\n", err)
		return
	}
	fmt.Printf("[%s]\n", respBody)
}

func bulkStoreTest(indexName, typeName string, data []byte) {

	url := "http://localhost:9200"
	URI := fmt.Sprintf("%v/%v/%v/%v", url, indexName, typeName, "_bulk")

	c := &fasthttp.Client{}

	req, resp := fasthttp.AcquireRequest(), fasthttp.AcquireResponse()
	defer fasthttp.ReleaseRequest(req)
	defer fasthttp.ReleaseResponse(resp)

	req.Header.SetMethod("POST")
	req.Header.Set("Content-Type", "application/x-ndjson")
	req.SetBody(data)

	req.SetRequestURI(URI)

	err := c.Do(req, resp)
	fmt.Printf("err:%v\nresp:%s\n", err, resp.Body())

}

func TestFC(*testing.T) {
	indexName := "transactions"

	url := "http://localhost:9200/" + indexName

	c := &fasthttp.Client{}

	req, resp := fasthttp.AcquireRequest(), fasthttp.AcquireResponse()
	defer fasthttp.ReleaseRequest(req)
	defer fasthttp.ReleaseResponse(resp)

	req.Header.SetMethod("PUT")

	req.SetRequestURI(url)

	err := c.Do(req, resp)
	fmt.Printf("err:%v\nresp:%s\n", err, resp.Body())
}

func TestBK(*testing.T) {

	ts := time.Now()
	url := "http://localhost:9200"
	blocks := make([]byte, 0)
	bulkStoreTest("blocks", "block", blocks)
	fmt.Printf("store block cost:%v\n", time.Since(ts))
	fmt.Println(ESBulkStore(url, "blocks", "block", blocks))
	fmt.Printf("store block cost:%v\n", time.Since(ts))
	ts = time.Now()
	// bulkStore(url, "transactions", "transaction", trans)
	// fmt.Printf("store transaction cost:%v\n", time.Since(ts))

}

func getBlockTTTT() {
	client := grpcclient.GetRandomWallet()
	blocks, _ := client.GetBlockByLatestNum(2)

	b, t, l := ESConvertBlocksBulk(blocks, false)

	fmt.Printf("%s\n\n%s\n\n%v\n", b, t, l)
	ESBulkStore("http://localhost:9200", "", "", t)
}

func TestX(*testing.T) {
	getBlockTTTT()
}
