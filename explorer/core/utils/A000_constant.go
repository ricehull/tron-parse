package utils

import (
	"math/rand"
	"time"
)

func init() {
	rand.Seed(time.Now().Unix())
}

// TestNet 是否连接 testNet，默认false
var TestNet bool

// NetName 使用哪个网络，shasta or else
var NetName string

// NetShasta ...
const NetShasta = "shasta"

// GetRandSolidityNodeAddr 随机获取一个solidity node ip
func GetRandSolidityNodeAddr() string {
	if NetShasta == NetName {
		if TestNet {
			return TestSolidityNodeListShasta[rand.Int31n(int32(len(TestSolidityNodeListShasta)))]
		}
		return SolidityNodeListShasta[rand.Int31n(int32(len(SolidityNodeListShasta)))]
	}
	if TestNet {
		return TestSolidityNodeList[rand.Int31n(int32(len(TestSolidityNodeList)))]
	}
	return SolidityNodeList[rand.Int31n(int32(len(SolidityNodeList)))]
}

// GetRandFullNodeAddr 随机获取一个full node ip
func GetRandFullNodeAddr() string {
	if NetShasta == NetName {
		if TestNet {
			return TestFullNodeListShasta[rand.Int31n(int32(len(TestFullNodeListShasta)))]
		}
		return FullNodeListShasta[rand.Int31n(int32(len(FullNodeListShasta)))]
	}
	if TestNet {
		return TestFullNodeList[rand.Int31n(int32(len(TestFullNodeList)))]
	}
	return FullNodeList[rand.Int31n(int32(len(FullNodeList)))]
}

// 地址前缀 测试/主网
const (
	// AddressPrefixTest = "a0" //a0 + address
	AddressPrefixTest = "41" //a0 + address, test net use the same rule now!!!
	AddressPrefixMain = "41" //41 + address

	DefaultGrpPort = 50051
	DefaultP2pPort = 18888
)

// Node List info from:
// https://github.com/tronprotocol/Documentation/blob/master/TRX_CN/Official_Public_Node.md

// SolidityNodeListShasta ...
var SolidityNodeListShasta = []string{
	"grpc.trongrid.io:50052",
}

// FullNodeListShasta ...
var FullNodeListShasta = []string{
	"grpc.trongrid.io:50051",
}

// TestSolidityNodeListShasta ...
var TestSolidityNodeListShasta = []string{
	"grpc.shasta.trongrid.io:50052",
}

// TestFullNodeListShasta ...
var TestFullNodeListShasta = []string{
	"grpc.shasta.trongrid.io:50051",
}

// SolidityNodeList Solidity节点列表
var SolidityNodeList = []string{
	// "39.105.66.80",   // good
	// "47.254.39.153",  // good
	// "47.89.244.227",  // good
	// "39.105.118.15",  // good
	// "47.75.108.229",  // good
	// "34.234.164.105", // good
	// "18.221.34.0",    // time out happen, good
	// "35.178.11.0",    // good
	// "35.180.18.107",  // good
	// "52.63.152.13",   // time out happen +++++
	// "18.231.123.107", // time out happen +++++

	// the same as above, order by node ip, disable test failed node
	// "52.63.152.13:50051",
	// "47.89.244.227:50051",
	// "47.75.108.229:50051",
	// "47.254.39.153:50051",
	// "39.105.66.80:50051",
	// "39.105.118.15:50051",
	// "18.231.123.107:50051",
	"35.180.18.107:50051",
	"35.178.11.0:50051",
	"34.234.164.105:50051",
	"18.221.34.0:50051",
}

// FullNodeList Full节点列表
var FullNodeList = []string{
	"54.236.37.243:50051",  // a // not fully implement
	"52.53.189.99:50051",   // a //  not fully implement
	"18.196.99.16:50051",   // a
	"34.253.187.192:50051", // a
	"52.56.56.149:50051",   // a
	"35.180.51.163:50051",  // a
	"54.252.224.209:50051", // a
	"18.228.15.36:50051",   // a
	"52.15.93.92:50051",    // a
	"34.220.77.106:50051",  // a
	"13.127.47.162:50051",  // a
	"13.124.62.58:50051",   // a
	// "13.229.128.108",
	"35.182.37.246:50051", // a
	// "34.200.228.125",
	// "18.220.232.201",
	// "13.57.30.186",

	// "35.165.103.105",
	// "18.184.238.21",
	// "34.250.140.143:50051", // b
	// "35.176.192.130:50051", // b
	// "52.47.197.188:50051", // b
	// "52.62.210.100:50051", //b
	// "13.231.4.243:50051",  // b
	// "18.231.76.29",
	// "35.154.90.144:50051",  // b
	// "13.125.210.234:50051", // b
	// "13.250.40.82",
	// "35.183.101.48",
	// "47.104.11.194", // grpc connection failed
}

// Faield, error:rpc error: code = Unavailable desc = all SubConns are in TransientFailure, latest connection error: connection error: desc = "transport: Error while dialing dial tcp 47.104.11.194:50051: connect: connection refused"

// TestSolidityNodeList ...
var TestSolidityNodeList = []string{
	"47.75.13.181",
	"47.89.188.246",
}

// TestFullNodeList ...
var TestFullNodeList = []string{
	"47.90.240.201",
	"47.89.188.246",
	"47.90.208.195",
	"47.89.188.162",
	"47.89.185.110",
	"47.89.183.137",
	"47.90.240.239",
	"47.88.55.186",
	"47.254.75.152",
	"47.254.36.2",
	"47.254.73.154",
	"47.254.20.22",
	"47.254.33.129",
	"47.254.45.208",
	"47.74.159.205",
	"47.74.149.105",
	"47.74.144.205",
	"47.74.159.52",
	"47.88.237.77",
	"47.74.149.180",
	"47.88.229.149",
	"47.74.182.133",
	"47.88.229.123",
	"47.74.152.210",
	"47.75.205.223",
	"47.75.113.95",
	"47.75.57.234",
}
