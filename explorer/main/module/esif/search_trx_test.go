package esif

import (
	"fmt"
	"testing"

	"tron-parse/explorer/core/utils"
)

func TestSearchTrans(*testing.T) {

	/*
		select block_id,owner_address,to_address,amount,
		asset_name,trx_hash,
		contract_type,confirmed,create_time
		from contract_transfer oo
		where 1=1 and (owner_address='TFMAHNTS35ZNL5Pr9XToVVekyAbE9ts65Y'  or to_address='TFMAHNTS35ZNL5Pr9XToVVekyAbE9ts65Y')   and oo.asset_name='' order by  oo.block_id desc limit 0, 20
	*/
	// retList, total, err := SearchUserTrx("TFMAHNTS35ZNL5Pr9XToVVekyAbE9ts65Y", 0, 20, []int64{1, 2})
	// retList, total, err := SearchUserTrx("TFMAHNTS35ZNL5Pr9XToVVekyAbE9ts65Y", 0, 20, []int64{2})
	SearchUserTrx("TFMAHNTS35ZNL5Pr9XToVVekyAbE9ts65Y", 0, 20, nil)

	// fmt.Printf("retList:%v\n, total:%v\n, err:%v\n", retList, total, err)
}

func TestGenTermsList(*testing.T) {
	fmt.Println(genTermsList([]int64{1, 2, 3, 4}))
}

func TestSearchTransaction(*testing.T) {
	hash := "ae740d5d2ef05e964fae6e958d88c005a18a67861a98da853a2c13cd545baee8"
	queryStr := fmt.Sprintf(`{
		"query": {
			"constant_score": {
				"filter": {
					"term": {"Hash":"%v"}
				}
			}
		}
	}
	`, hash)

	trxInfo, cnt, err := SearchTransaction(queryStr)
	fmt.Printf("cnt:%v\n, err:%v\n, trxInfo:%s\n", cnt, err, utils.ToJSONStr(trxInfo))
}
