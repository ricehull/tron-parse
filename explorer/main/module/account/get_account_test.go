package account

import (
	"fmt"
	"testing"

	"tron-parse/explorer/main/module/rawredis"

	"tron-parse/explorer/core/grpcclient"
	"tron-parse/explorer/core/utils"
)

func TestGetAcc(*testing.T) {
	accs, err := GetRawAccount([]string{
		"TMuA6YqfCeX8EhbfYEg5y7S4DqzSJireY9",
		"TAahLbGTZk6YuCycii72datPQEtyC5x231",
		"TV9QitxEJ3pdiAUAfJ2QuPxLKp9qTTR3og",
	})

	fmt.Printf("%v\n%v\n", err, utils.ToJSONStr(accs))

}

func TestRedis(*testing.T) {
	rawredis.DSN = "127.0.0.1:6379"
	fmt.Printf("%#v", rawredis.GetRedisClient().Ping())

	sc := grpcclient.GetRandomSolidity()
	utils.VerifyCall(sc.GetAccount("7YxAaK71utTpYJ8u4Zna7muWxd1pQwimpGxy8"))
	utils.VerifyCall(sc.GetTransactionByID("dfb4a633165cb85963ec1edfb4c9283644a3e136b77c063f4ba2e39307863a75"))
}
