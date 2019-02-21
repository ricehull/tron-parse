package esif

import (
	"encoding/json"
	"fmt"
)

// search URL
var (
	ESBlockSearchURL       = "https://wlcyapi.tronscan.org/es/blocks/"
	ESTransactionSearchURL = "https://wlcyapi.tronscan.org/es/transactions/"
)

func genTermsList(in []int64) string {
	if 1 == len(in) {
		return fmt.Sprintf("%v", in)
	}
	ret := fmt.Sprintf("[%v,", in[0])
	for _, val := range in[1:] {
		ret += fmt.Sprintf("%v,", val)
	}
	ret = ret[:len(ret)-1]
	ret += "]"
	return ret
}

// SearchUserTrx ....
func SearchUserTrx(addr string, start, limit int64, ctxType []int64) ([]*TransactionInfo, int, error) {

	ctxTypeStr := ""
	matchCnt := ""
	if 0 < len(ctxType) {
		ctxTypeStr = fmt.Sprintf(`,
					{ 
						"terms": 
						{
							"ContractType": %v
						}
					}
				`, genTermsList(ctxType))
		matchCnt = `,
				"minimum_should_match" : 2`
	}

	queryStr := fmt.Sprintf(`
	{
		"query": {
			"bool":{
				"should":[
					{ "term": {"Owner": "%v"} },
					{ "term": {"To": "%v"} }%v
				]%v
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
	`, addr, addr, ctxTypeStr, matchCnt, start, limit)

	return SearchTransaction(queryStr)
}

// SearchTransaction search transaction
func SearchTransaction(query string) ([]*TransactionInfo, int, error) {
	url := "https://wlcyapi.tronscan.org/es/transactions/"
	resp, err := ESWlcySearch(url, "", []byte(query))
	// fmt.Printf("resp:%#v\n\nerr:%v\n", resp, err)
	_ = err

	if nil != resp && 0 < len(resp.Hits.Hits) {
		trxInfo := convertESHitOneToTrx(resp.Hits.Hits)
		return trxInfo, resp.Hits.Total, nil

		// for _, trx := range trxInfo {
		// 	data, _ := json.MarshalIndent(trx, "", "    ")
		// 	fmt.Printf("%s\n", data)
		// }
	}
	return nil, 0, nil
}

func convertESHitOneToTrx(raw []ESHitOne) []*TransactionInfo {
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
