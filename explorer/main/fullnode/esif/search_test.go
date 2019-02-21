package main

import (
	"bytes"
	"fmt"
	"testing"
)

func TestSearch(*testing.T) {
	buff := &bytes.Buffer{}

	buff.WriteString(`{
		"sort":[
			{
				"_id":"desc"
			}
		],
		"from":20,
		"size":3,
		"query":{

		}
	}`)

	url := "http://localhost:9200"
	// urlBlock := "http://wlcyapi.tronscan.org/es/blocks/"
	resp, err := ESSearch(url, "blocks", "block", buff.Bytes())

	fmt.Printf("%#v\n\n%v\n", resp, err)
}

func TestSearchTrx(*testing.T) {
	buff := &bytes.Buffer{}

	buff.WriteString(`{
		"query" : {
			"constant_score" : { 
				"filter" : {
					"term" : { 
						"ContractType" : 31
					}
				}
			}
		}
	}`)

	url := "http://localhost:9200"
	url = "http://testwlcyapi.tronscan.org/esg/blocks/"
	_ = url
	// urlBlock := "http://wlcyapi.tronscan.org/es/blocks/"
	urlTransaction := "http://wlcyapi.tronscan.org/es/transactions/"
	// resp, err := ESWlcySearch(urlBlock, "", buff.Bytes())
	resp, err := ESWlcySearch(urlTransaction, "", buff.Bytes())

	fmt.Printf("%#v\n\n%v\n", resp, err)
}

func TestSearchTrxA(*testing.T) {
	buff := &bytes.Buffer{}

	//// nested search, ok
	buff.WriteString(`{
		"query" : {
			"bool" : {
				"must": [
					{
					 "term" :{ "ContractTypeName": "TriggerSmartContract" }
					},
					{
						"nested": {
							"path" : "ContractDetail",
							"query" : {
								"bool": {
									"must": [
										{ "term": {"ContractDetail.owner_address": "QV6pXuh0p0nmUVtS6fTKj8gRn77x"} }
									]
								}
							}
						}
					}
				]
			}
		},
		"sort": [
			{
				"BlockID": "desc"
			}
		]
	}`)

	// buff.Reset()

	// buff.WriteString(`{
	// 	"query" : {
	// 		"bool" : {
	// 			"must": [
	// 				{ "term": { "Confiremd": true } }
	// 			]
	// 		}
	// 	},
	// 	"sort": [
	// 		{
	// 			"BlockID": "desc"
	// 		}
	// 	]
	// }`)

	// buff.WriteString(`{
	// 	"query" : {
	// 		"ContractDetail": {
	// 			"prefix": {
	// 				"data": "dutcsg"
	// 			}
	// 		}
	// 	}
	// }`)

	url := "http://localhost:9200"
	resp, err := ESSearch(url, "transactions", "transaction", buff.Bytes())

	fmt.Printf("%#v\n\n%v\n", resp, err)
}

func TestSearchBlock(*testing.T) {
	// blockID := `3922647 3922648 3922649 3922650 3922651 3922652
	// 3922653 3922654 3922655 3922656 3922657 3922658 3922659 3922660 3922661 3922662 3922663 3922664
	// 3922665 3922666 3922667 3922668 3922669 3922670 3922671 3922672 3922673`

	url := "http://wlcyapi.tronscan.org/es/blocks/"

	buff := &bytes.Buffer{}

	buff.WriteString(`
	{
		"query": {
			"terms": { "ID": [3922649,3922648,3922647] }
		}
	}
	`)

	resp, err := ESWlcySearch(url, "", buff.Bytes())

	fmt.Printf("%#v\n%v\n", resp, err)
}
