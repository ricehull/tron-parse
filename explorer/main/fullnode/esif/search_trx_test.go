package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"testing"
)

func TestSearchTrans(*testing.T) {

	// strSQL := `SELECT block_id,owner_address,to_address,contract_type,trx_hash,create_time
	// FROM transactions
	// where owner_address='TFMAHNTS35ZNL5Pr9XToVVekyAbE9ts65Y' or to_address='TFMAHNTS35ZNL5Pr9XToVVekyAbE9ts65Y'  order by  block_id desc limit 0, 20`

	buff := &bytes.Buffer{}

	addr := "TFMAHNTS35ZNL5Pr9XToVVekyAbE9ts65Y"
	start := 0
	limit := 2

	buff.WriteString(fmt.Sprintf(`
	{
		"query": {
			"bool":{
				"should":[
					{ "term": {"Owner": "%v"} },
					{ "term": {"To": "%v"} }
				]
			}
		},
		"sort": [
			{
				"BlockID": "desc"
			}
		],
		"from":%v,
		"size":%v
	}
	`, addr, addr, start, limit))

	url := "https://wlcyapi.tronscan.org/es/transactions/"
	resp, err := ESWlcySearch(url, "", buff.Bytes())
	fmt.Printf("resp:%#v\n\nerr:%v\n", resp, err)

	if nil != resp && 0 < len(resp.Hits.Hits) {
		trxInfo := ConverToTrx(resp.Hits.Hits)

		for _, trx := range trxInfo {
			data, _ := json.MarshalIndent(trx, "", "    ")
			fmt.Printf("%s\n", data)
		}
	}
}

func ConverToTrx(raw []ESHitOne) []*TransactionInfo {
	ret := make([]*TransactionInfo, 0)

	for _, one := range raw {
		trx := &TransactionInfo{}
		rawData, _ := json.Marshal(one.Source)
		err := json.Unmarshal(rawData, trx)
		if nil == err {
			ret = append(ret, trx)
		}
	}

	return ret
}
