package esif

import (
	"encoding/json"
	"fmt"

	"github.com/valyala/fasthttp"
)

// Test if output raw request and resp
var Test bool

var jsonCtx = map[string]string{"Content-Type": "application/json"}
var ndjsonCtx = map[string]string{"Content-Type": "application/x-ndjson"}

// ESBulkStore ...
func ESBulkStore(url, indexName, typeName string, data []byte) (*ESResp, error) {
	if 0 == len(data) {
		return nil, nil
	}
	route := fmt.Sprintf("%v/%v/_bulk", indexName, typeName)
	return esRequest(url, route, "POST", ndjsonCtx, data)
}

// ESCreateIndex ...
func ESCreateIndex(url, indexName string) (*ESResp, error) {
	return esRequest(url, indexName, "PUT", nil, nil)
}

// ESDeleteIndex ...
func ESDeleteIndex(url, indexName string) (*ESResp, error) {
	return esRequest(url, indexName, "DELETE", nil, nil)
}

// ESAddMapping ...
func ESAddMapping(url, indexName string, typeName string, data []byte) (*ESResp, error) {
	route := fmt.Sprintf("%v/_mapping/%v", indexName, typeName)
	return esRequest(url, route, "PUT", jsonCtx, data)
}

// ESSearch ...
func ESSearch(url, indexName, typeName string, data []byte) (*ESResp, error) {
	route := fmt.Sprintf("%v/%v/_search", indexName, typeName)
	return esRequest(url, route, "POST", jsonCtx, data)
}

// ESWlcySearch ...
func ESWlcySearch(url, route string, data []byte) (*ESResp, error) {
	return esRequest(url, route, "POST", jsonCtx, data)
}

// ESQueryRaw ...
func ESQueryRaw(url, query string) ([]byte, error) {
	return esRequestRaw(url, "", "POST", jsonCtx, []byte(query))
}

func esRequest(url string, route string, method string, head map[string]string, data []byte) (*ESResp, error) {

	URI := fmt.Sprintf("%v/%v", url, route)
	// c := &fasthttp.Client{}

	req, resp := fasthttp.AcquireRequest(), fasthttp.AcquireResponse()
	defer fasthttp.ReleaseRequest(req)
	defer fasthttp.ReleaseResponse(resp)

	req.Header.SetMethod(method)
	for key, val := range head {
		req.Header.Set(key, val)
	}
	if nil != data {
		req.SetBody(data)
	}

	req.SetRequestURI(URI)

	err := fasthttp.Do(req, resp)

	esResp := &ESResp{}
	err = json.Unmarshal(resp.Body(), esResp)
	if Test {
		fmt.Printf("raw req:%v\n\nQuery:%s\n\nraw resp:%s\n", URI, data, resp.Body())
		fmt.Printf("err:%v\nresp:%#v\n", err, esResp)
	}
	if esResp.Status != 0 || 0 < len(esResp.Error) {
		esResp.Errors = true
	}

	return esResp, err
}

func esRequestRaw(url string, route string, method string, head map[string]string, data []byte) ([]byte, error) {

	URI := fmt.Sprintf("%v/%v", url, route)
	// c := &fasthttp.Client{}

	req, resp := fasthttp.AcquireRequest(), fasthttp.AcquireResponse()
	defer fasthttp.ReleaseRequest(req)
	defer fasthttp.ReleaseResponse(resp)

	req.Header.SetMethod(method)
	for key, val := range head {
		req.Header.Set(key, val)
	}
	if nil != data {
		req.SetBody(data)
	}

	req.SetRequestURI(URI)

	err := fasthttp.Do(req, resp)

	if Test {
		fmt.Printf("raw req:%v\n\nQuery:%s\n\nraw resp:%s\n", URI, data, resp.Body())
	}

	return resp.Body(), err
}

// ESResp ...
type ESResp struct {
	Took   int                    `json:"took"`
	Errors bool                   `json:"erros"`
	Error  map[string]interface{} `json:"error"`
	Status int                    `json:"status"`
	Items  []interface{}          `json:"items"`
	Hits   ESHits                 `json:"hits"`
}

// ESHits ...
type ESHits struct {
	Total int        `json:"total"`
	Hits  []ESHitOne `json:"hits"`
}

// ESHitOne ...
type ESHitOne struct {
	Index  string      `json:"_index"`
	Type   string      `json:"_type"`
	ID     string      `json:"_id"`
	Source interface{} `json:"_source"`
}

var esURLChan chan string

func getESURL() string {
	return <-esURLChan
}

func releaseESURL(url string) {
	esURLChan <- url
}
