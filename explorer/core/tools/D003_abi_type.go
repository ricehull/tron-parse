package tools

import (
	"fmt"
	"math/big"

	"github.com/ethereum/go-ethereum/accounts/abi"
	"github.com/ethereum/go-ethereum/common"
	"github.com/tronprotocol/grpc-gateway/core"
	"tron-parse/explorer/core/utils"
)

// GenAbiAddress generate abi address object by tron address tring
func GenAbiAddress(addr string) interface{} {
	abiAddr := &common.Address{}
	abiAddr.SetBytes(utils.Base58DecodeAddr(addr))
	return abiAddr
}

// GenAbiInt generate abi uintXXX object by int64
func GenAbiInt(val int64) interface{} {
	return big.NewInt(val)
}

// GenAbiHash generate abi hash object by bytes
func GenAbiHash(hashByte []byte) interface{} {
	abiHash := &common.Hash{}
	abiHash.SetBytes(hashByte)
	return abiHash
}

// GetTronAddrFromAbiAddress ...
//	AbiAddress 类型使用高20字节作为address值，前面的部分为address编码的版本信息，补上'A'
func GetTronAddrFromAbiAddress(addr interface{}) string {
	real, ok := addr.(common.Address)
	if !ok {
		return ""
	}
	tmp := []byte{65}
	tmp = append(tmp, real.Bytes()...)
	return utils.Base58EncodeAddr(tmp)
}

// GetTronAddressFromAbiString get tron address from abi address
//	abi address should be string start with "0x"; eg: 0x07243e6b6db1603ee06bac885c350660b112642c
func GetTronAddressFromAbiString(addr string) string {
	abiAddr := &common.Address{}
	abiAddr.UnmarshalText([]byte(addr))
	tmp := []byte{65}
	tmp = append(tmp, abiAddr.Bytes()...)
	return utils.Base58EncodeAddr(tmp)
}

// GetIntValueFromAbi try get integer value from abi object
func GetIntValueFromAbi(in interface{}) (uint64, bool) {
	tmp, ok := in.(*big.Int)
	if ok && nil != tmp {
		return tmp.Uint64(), ok
	}
	return 0, ok
}

// GetTronAddressFromRawABIAddr ...
//	e.g.: transactionInfo.Logs.Address
func GetTronAddressFromRawABIAddr(rawAddr []byte) string {
	tmp := []byte{65}
	tmp = append(tmp, rawAddr...)
	return utils.Base58EncodeAddr(tmp)
}

// GetTopicAddr ...
//
func GetTopicAddr(topicAddrRaw []byte) (string, error) {
	if len(topicAddrRaw) != 32 {
		return "", fmt.Errorf("invalid topic raw, need 32 lenght bytes")
	}

	rawAddr := topicAddrRaw[12:] // discard firt 12 byte, address is 20 byte data
	addr := GetTronAddressFromRawABIAddr(rawAddr)
	return addr, nil
}

// ExtractEventLog ...
func ExtractEventLog(event *Method, eventLog *core.TransactionInfo_Log) ([]interface{}, error) {
	if nil == event || 3 != event.Type {
		return nil, fmt.Errorf("require event method")
	}

	if event.Name == "Transfer" && 3 == len(eventLog.Topics) {
		event.Inputs[0].Indexed = true
		event.Inputs[1].Indexed = true
	}
	outputs, err := event.Inputs.UnpackValues(eventLog.Data)
	if nil != err {
		fmt.Printf("err:%v\n", err)
		return nil, err
	}
	_ = outputs

	ret := make([]interface{}, 0, len(event.Inputs))
	commonIdx := 0
	topicIdx := 1
	var output interface{}
	for idx, arg := range event.Inputs {
		_ = idx
		_ = arg
		if arg.Indexed {
			switch arg.Type.T {
			case abi.AddressTy:
				tmp := new(common.Address)
				tmp.SetBytes(eventLog.Topics[topicIdx][12:])
				output = tmp
			case abi.UintTy:
				tmp := new(big.Int)
				tmp.SetBytes(eventLog.Topics[topicIdx])
			default:
				fmt.Printf("Unsupport topic type:[%v|%v], arg name:[%v], topic Raw:(%v)\n", arg.Type.T, arg.Type.String(), arg.Name, eventLog.Topics[topicIdx])
			}
			ret = append(ret, output)
			topicIdx++
		} else {
			ret = append(ret, outputs[commonIdx])
			commonIdx++
		}
	}
	return ret, nil
}

func getTopicParameter(arg abi.Argument, data []byte) interface{} {
	switch arg.Type.T {
	case abi.AddressTy:
		tmp := new(common.Address)
		tmp.SetBytes(data[12:])
		return tmp
	case abi.UintTy:
		tmp := new(big.Int)
		tmp.SetBytes(data)
		return tmp
	default:
		fmt.Printf("Unsupport topic type:[%v|%v], arg name:[%v], topic Raw:(%v)\n", arg.Type.T, arg.Type.String(), arg.Name, data)
	}
	return ""
}

func getTopicStringParameter(arg abi.Argument, data []byte) string {
	switch arg.Type.T {
	case abi.AddressTy:
		return GetTronAddressFromRawABIAddr(data[12:])
	case abi.UintTy:
		tmp := new(big.Int)
		tmp.SetBytes(data)
		return tmp.String()
	default:
		fmt.Printf("Unsupport topic type:[%v|%v], arg name:[%v], topic Raw:(%v)\n", arg.Type.T, arg.Type.String(), arg.Name, data)
	}
	return ""
}
