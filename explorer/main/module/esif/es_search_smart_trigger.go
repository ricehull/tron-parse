package esif

import (
	"bytes"
	"fmt"
)

// SearchSmartTrigger ...
func SearchSmartTrigger() (*ESResp, error) {

	// func ESWlcySearch(url, route string, data []byte) (*ESResp, error) {
	// 	return esRequest(url, route, "POST", jsonCtx, data)
	// }

	url := "http://testwlcyapi.tronscan.org/esg/smart/trigger/"

	buff := &bytes.Buffer{}

	//// 按照 owner 聚合，前100个，带callValue sum 降序， size = 0, 不返回过滤的数据， OK
	//// 排序的 order 后出现的优先排序, 如下是按照 sum_amount， 再按照 max_block_id 排序
	buff.WriteString(`{
		"query": {
			"bool": {
				"must": [
					{ "term": {"To": "TWY8dqZun9EU4tA3B4icnCE77HrP5FN7be" } },
					{ "term": {"ContractRet": 1 } },
					{ "term": {"Confiremd": true} },
					{ "prefix": {"CallData": "7365870b"} },
					{ "range": {
						"CreateTime": {
							"gte": 1542474195000
							"lt": 1542474294000
						}
					} }
				]
			}
		},
		"sort": [
			{
				"BlockID": "desc"
			}
		],
		"size":3
	} `)

	/*
			"aggs": {
			"Owner": {
				"terms": {
					"field": "Owner",
					"size": 10,
					"order": {
						"max_block_id": "desc",
						"sum_amount": "desc"
					}
				},
				"aggs": {
					"sum_amount": {
						"sum": { "field": "CallValue" }
					},
					"max_block_id": {
						"max": { "field": "BlockID" }
					}
				}
			}
		},
	*/

	//// 使用 bucket_sort 对聚合结果进行处理， bucket_sort 是保留字，支持 sort, size, from
	// buff.WriteString(`{
	// 	"size":0,
	// 	"query": {
	// 		"bool": {
	// 			"must": [
	// 				{ "term": {"To": "TWY8dqZun9EU4tA3B4icnCE77HrP5FN7be" } },
	// 				{ "term": {"ContractRet": 1 } },
	// 				{ "term": {"Confiremd": true} },
	// 				{ "prefix": {"CallData": "7365870b"} }
	// 			]
	// 		}
	// 	},
	// 	"aggs": {
	// 		"Owner":{
	// 			"terms": {
	// 				"field": "Owner"
	// 			},
	// 			"aggs": {
	// 				"sum_amount": {
	// 					"sum": {
	// 						"field": "CallValue"
	// 					}
	// 				},
	// 				"sum_bucket_sort": {
	// 					"bucket_sort": {
	// 						"sort": [
	// 							{
	// 								"sum_amount": {
	// 									"order": "desc"
	// 								}
	// 							}
	// 						],
	// 						"size": 20,
	// 						"from": 0
	// 					}
	// 				}
	// 			}
	// 		}
	// 	}
	// }`)
	ret, err := ESWlcySearch(url, "", buff.Bytes())

	fmt.Printf("ret:%v\nerr:%v\n", ret, err)

	return ret, err

}

// SearchSmartTriggerQueryRaw ...
func SearchSmartTriggerQueryRaw(url, queryString string) ([]byte, error) {
	return ESQueryRaw(url, queryString)
}
