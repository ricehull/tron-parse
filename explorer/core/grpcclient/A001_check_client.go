package grpcclient

import (
	"fmt"
	"strings"
	"time"

	"github.com/tronprotocol/grpc-gateway/api"
)

// Err ...
var (
	ErrInvalidNode = fmt.Errorf("Invalid Node")
)

// CheckNodeType ...
// timeout in millisecond, <= 0 -> 1000
// nodeType: 节点类型
//	0: invalid node
//	1: full node
//	2: solidity node
// client: 指向节点的grpc连接对象，Wallet or SolidityWallet
// err: 错误信息
func CheckNodeType(ip, port string, timeout int64) (nodeType int, client interface{}, err error) {

	if timeout <= 0 {
		timeout = 1000
	}
	ctx, cancel := getTimeoutContext(time.Duration(timeout) * time.Millisecond)
	defer cancel()
	callOpt := getDefaultCallOptions()
	emptyMsg := &api.EmptyMessage{}

	serverAddr := ""
	if strings.Contains(ip, ":") {
		serverAddr = ip
	} else {
		serverAddr = fmt.Sprintf("%v:%v", ip, port)
	}

	wallet := NewWallet(serverAddr)

	err = wallet._conn.Connect()
	if nil != err {
		return 0, nil, err
	}

	wallet.client = api.NewWalletClient(wallet._conn.c)

	if nil != wallet.client {
		_, err = wallet.client.GetNowBlock(ctx, emptyMsg, callOpt)
		if nil == err {
			return 1, wallet, nil
		}
	}
	wallet.Close()

	// try solidity

	ctx1, cancel1 := getTimeoutContext(time.Duration(3000) * time.Millisecond)
	defer cancel1()

	walletS := NewWalletSolidity(serverAddr)

	err = walletS._conn.Connect()
	if nil != err {
		return 0, nil, err
	}

	walletS.client = api.NewWalletSolidityClient(walletS._conn.c)
	if nil != walletS.client {
		_, err = walletS.client.GetNowBlock(ctx1, emptyMsg, callOpt)
		if nil == err {
			return 2, walletS, nil
		}
	}
	walletS.Close()

	return 0, nil, ErrInvalidNode
}
