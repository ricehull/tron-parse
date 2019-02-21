package account

import (
	"testing"

	"tron-parse/explorer/core/grpcclient"
	"tron-parse/explorer/core/utils"
	"tron-parse/explorer/main/module/rawmysql"
)

func TestStore(*testing.T) {

	rawmysql.DSN = "tron:tron@tcp(mine:3306)/tron"
	dbb := rawmysql.GetMysqlDB()

	addr := "TM7HkyTpM8puzrtDjVCZNTmost1v6gs16H"
	addr = "TPV6qxBbjPoGtS1qZbNDd5KK67JSc347zf"
	addr = "TGd936e6CRQ1hRCF6qo71ADnPHJYe1VbCa"
	addr = "TZEuGDUMUpBeNsdeh8vRs7Af9ZvhF4hGft"
	client := grpcclient.GetRandomSolidity()
	accRaw, _ := client.GetAccount(addr)
	utils.VerifyCall(accRaw, nil)
	c1 := grpcclient.GetRandomWallet()
	res, _ := c1.GetAccountResource(addr)

	acc := new(Account)
	acc.SetRaw(accRaw)
	acc.SetResRaw(res)
	StoreAccount([]*Account{acc}, dbb)
}
