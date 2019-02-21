package tools

import (
	"fmt"
	"time"

	"github.com/tronprotocol/grpc-gateway/api"
	"github.com/tronprotocol/grpc-gateway/core"
	"tron-parse/explorer/core/grpcclient"
	"tron-parse/explorer/core/utils"
)

// BroadcastCtxWithFeeLimit 广播contract
//	ctxType 交易类型
//	ctx 交易对象
//	data transaction附带数据
//	privateKey 交易owner私钥，用于签名, hex encoding 私钥
//	expirationSecond 交易超时时间，单位秒，无效值（<=0）默认为180秒
//  feeLimit for transaction if need cost bendth or energy
func BroadcastCtxWithFeeLimit(ctxType core.Transaction_Contract_ContractType, ctx interface{}, data []byte, privateKey string, expirationSecond int64, feeLimit int64) (trxHash string, result *api.Return, err error) {
	return BroadcastCtxWithFeeLimitWithNode(ctxType, ctx, data, privateKey, expirationSecond, feeLimit, "")
}

// BroadcastCtx 广播contract
//	ctxType 交易类型
//	ctx 交易对象
//	data transaction附带数据
//	privateKey 交易owner私钥，用于签名, hex encoding 私钥
//	expirationSecond 交易超时时间，单位秒，无效值（<=0）默认为180秒
func BroadcastCtx(ctxType core.Transaction_Contract_ContractType, ctx interface{}, data []byte, privateKey string, expirationSecond int64) (trxHash string, result *api.Return, err error) {
	return BroadcastCtxWithFeeLimit(ctxType, ctx, data, privateKey, expirationSecond, 0)
}

// BroadcastCtxWithFeeLimitWithNode 广播contract
//	ctxType 交易类型
//	ctx 交易对象
//	data transaction附带数据
//	privateKey 交易owner私钥，用于签名, hex encoding 私钥
//	expirationSecond 交易超时时间，单位秒，无效值（<=0）默认为180秒
func BroadcastCtxWithFeeLimitWithNode(ctxType core.Transaction_Contract_ContractType, ctx interface{}, data []byte, privateKey string, expirationSecond int64, feeLimit int64, node string) (trxHash string, result *api.Return, err error) {
	var trx *core.Transaction
	trx, err = utils.BuildTransaction(ctxType, ctx, data)
	if nil != err || nil == trx || nil == trx.RawData {
		return
	}

	var client *grpcclient.Wallet

	if 0 < len(node) {
		client = grpcclient.NewWallet(node)
		err = client.Connect()
	} else {
		client = grpcclient.GetRandomWallet()
	}

	if nil == client {
		return
	}

	// fmt.Printf("grpc client:%v\n", client.Target())
	defer client.Close()
	var block *core.Block
	block, err = client.GetNowBlock()
	if nil != err || nil == block || nil == block.BlockHeader || nil == block.BlockHeader.RawData {
		return
	}

	trx.RawData.RefBlockBytes, trx.RawData.RefBlockHash = utils.GetBlockByteRefHashRef(block)
	trx.RawData.Timestamp = time.Now().UTC().UnixNano() / 1000000
	trx.RawData.FeeLimit = feeLimit

	if 0 >= expirationSecond {
		expirationSecond = 180 // 3minute
	}
	trx.RawData.Expiration = time.Now().UTC().Add(time.Duration(expirationSecond)*time.Second).UnixNano() / 1000000

	var sign []byte
	sign, err = utils.SignTransaction(trx, privateKey)
	if nil != err || nil == sign {
		return
	}
	trx.Signature = append(trx.Signature, sign)

	trxHash = utils.HexEncode(utils.CalcTransactionHash(trx))

	result, err = client.BroadcastTransaction(trx)
	if nil != err {
		return
	}
	fmt.Printf("result:-->%v\n", utils.ToJSONStr(result))

	return
}

// TriggerContract 调用constant/view合约方法
func TriggerContract(addr, ctxAddr string, callValue int64, callData []byte, node ...string) (result *api.TransactionExtention, err error) {
	var client *grpcclient.Wallet

	if 0 < len(node) {
		client = grpcclient.NewWallet(node[0])
		err = client.Connect()
	} else {
		client = grpcclient.GetRandomWallet()
	}

	if nil == client {
		return
	}

	defer client.Close()
	return client.TriggerContract(addr, ctxAddr, callValue, callData)
}
