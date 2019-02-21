package tools

import (
	"fmt"
	"math/big"
	"testing"

	"github.com/ethereum/go-ethereum/common"
	"tron-parse/explorer/core/utils"
)

func TestAbiEqual(*testing.T) {
	req := fmt.Sprintf(`[{"constant":true,"name":"ceoAddress","outputs":[{"type":"address"}],"type":2,"stateMutability":20},{"name":"payForCeoAddress","type":2,"payable":true,"stateMutability":4},{"name":"payForContract","type":2,"payable":true,"stateMutability":4},{"constant":true,"name":"getContractBalance","outputs":[{"type":"address"},{"type":"uint256"}],"type":2,"stateMutability":2},{"constant":true,"name":"getCeoBalance","outputs":[{"type":"address"},{"type":"uint256"}],"type":2,"stateMutability":2},{"name":"withDrawFromContract","type":2,"stateMutability":3},{"type":1,"stateMutability":3}]`)
	main := fmt.Sprintf(`{"entrys":[{"constant":true,"name":"ceoAddress","outputs":[{"type":"address"}],"type":2,"stateMutability":2},{"name":"payForCeoAddress","type":2,"payable":true,"stateMutability":4},{"name":"payForContract","type":2,"payable":true,"stateMutability":4},{"constant":true,"name":"getContractBalance","outputs":[{"type":"address"},{"type":"uint256"}],"type":2,"stateMutability":2},{"constant":true,"name":"getCeoBalance","outputs":[{"type":"address"},{"type":"uint256"}],"type":2,"stateMutability":2},{"name":"withDrawFromContract","type":2,"stateMutability":3},{"type":1,"stateMutability":3}]}`)
	reqAbi, err := GetABIWithoutEntry(req)
	fmt.Println(err)
	mainAbi, _ := GetABI(main)
	fmt.Println(AbiEquals(reqAbi, mainAbi))
}

func TestPackAddress(*testing.T) {
	abiAddr := &common.Address{}
	addr := "TAcy9feBUq3C1yn1fWG64dggkyWTq24mCE"
	abiAddr.SetBytes(utils.Base58DecodeAddr(addr))
	// abiAddr.UnmarshalText([]byte("0x07243e6b6db1603ee06bac885c350660b112642c"))
	fmt.Printf("abi address:%v\n%v\n%v\n%v\n%v\n",
		abiAddr, abiAddr.String(), abiAddr.Bytes(), []byte("0x07243e6b6db1603ee06bac885c350660b112642c"),
		GetTronAddressFromAbiString("0x07243e6b6db1603ee06bac885c350660b112642c"))
}

func TestCc(*testing.T) {
	abiAddr := &common.Address{}
	abiAddr.UnmarshalText([]byte("0x07243e6b6db1603ee06bac885c350660b112642c"))
	fmt.Println(GetTronAddrFromAbiAddress(abiAddr))

	abiAddr.UnmarshalText([]byte("0x0000000000000000000000000000000000000000"))
	fmt.Println(GetTronAddrFromAbiAddress(abiAddr))
}

func TestTopicLogAddr(*testing.T) {
	data := `1761f7cd09693ab3d551d2b709e40766221f3c51`
	raw := utils.HexDecode(data)
	fmt.Printf("raw len:%v--%v\n\n", len(raw), raw)
	tmp := []byte{65}
	tmp = append(tmp, raw...)
	fmt.Println(utils.Base58EncodeAddr(tmp))

	data1 := `AAAAAAAAAAAAAAAAOJf7dWR0YUEKUjhscq3bf+z6Dz4=`
	raw1 := utils.Base64Decode(data1)
	fmt.Printf("raw1 len:%v--%v\n\n", len(raw1), raw1)
	tmp1 := []byte{65}
	tmp1 = append(tmp1, raw1[12:]...)
	fmt.Println(utils.Base58EncodeAddr(tmp1))

}

func TestPackHash(*testing.T) {
	abiHash := &common.Hash{}
	trxHash := ""
	abiHash.SetBytes(utils.HexDecode(trxHash))
	fmt.Printf("abi hash:%v\n", abiHash)
}

func TestPackInt(*testing.T) {
	abiVal := big.NewInt(123)
	fmt.Printf("abi int:%v\n", abiVal)
}
