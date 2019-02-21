package tools

import (
	"bytes"
	"encoding/json"
	"fmt"
	"strings"

	"github.com/ethereum/go-ethereum/accounts/abi"
	"github.com/ethereum/go-ethereum/crypto"
)

var methodTypeMap = map[int]string{
	1: "constrcutor",
	2: "function",
	3: "event",
}

// var methodStateMutability = map[int]string{
// 	2: "function",
// 	3: "event",
// 	1: "constrcutor",
// }

// AbiEntry abi entry
type AbiEntry struct {
	Entrys []*Method
}

//AbiEquals ...
func AbiEquals(a, b *AbiEntry) bool {
	if nil == a && nil == b {
		return true
	}
	if nil == a || nil == b {
		return false
	}
	if len(a.Entrys) != len(b.Entrys) {
		return false
	}
	for _, method := range a.Entrys {
		bm := b.GetMethod(method.Name)
		if nil == bm {
			return false
		}
		if bm.String() != method.String() {
			return false
		}
	}
	return true
}

// GetABI gen abi object using abi json string
func GetABI(abiJSON string) (*AbiEntry, error) {
	ret := new(AbiEntry)
	err := json.Unmarshal([]byte(abiJSON), ret)
	if nil != err {
		return nil, err
	}
	return ret, err
}

// GetABIWithoutEntry gen abi object without entry using abi json string
func GetABIWithoutEntry(abiJSON string) (*AbiEntry, error) {
	ret := new(AbiEntry)
	method := make([]*Method, 0)
	err := json.Unmarshal([]byte(abiJSON), &method)
	if nil != err {
		return nil, err
	}
	ret.Entrys = method
	return ret, err
}

// GetMethod return specified named method, if not found, return nil
func (ae AbiEntry) GetMethod(name string) *Method {
	for _, method := range ae.Entrys {
		if name == method.Name {
			return method
		}
	}
	return nil
}

// Method abi method
type Method struct {
	Name            string        `json:",omitempty"`
	Inputs          abi.Arguments `json:",omitempty"`
	Outputs         abi.Arguments `json:",omitempty"`
	Type            int           `json:",omitempty"`
	Constant        bool          `json:",omitempty"`
	Payable         bool          `json:",omitempty"`
	StateMutability int           `json:",omitempty"`
}

var (
	errMethodIDNotMatch     = fmt.Errorf("Method ID Not Match")
	errMethodInputsNotMatch = fmt.Errorf("Method Inputs Not Match")
)

// Arg ...
type Arg struct {
	Name string
	Type string
}

// getArgs ...
func getArgs(oris abi.Arguments) []Arg {
	if 0 == len(oris) {
		return nil
	}
	ret := make([]Arg, 0, len(oris))
	for _, ori := range oris {
		ret = append(ret, Arg{ori.Name, ori.Type.String()})
	}
	return ret
}

func getMethodTypeName(typeID int) string {
	name, ok := methodTypeMap[typeID]
	if ok {
		return name
	}
	return fmt.Sprintf("methodType(%v)", typeID)
}

// MarshalJSON ...
func (method *Method) MarshalJSON() ([]byte, error) {
	return json.Marshal(&struct {
		Name            string
		Type            string
		Constant        bool
		Payable         bool
		StateMutability int
		Signature       string
		Inputs          []Arg
		Outputs         []Arg
	}{
		method.Name,
		getMethodTypeName(method.Type),
		method.Constant,
		method.Payable,
		method.StateMutability,
		method.String(),
		getArgs(method.Inputs),
		getArgs(method.Outputs),
	})
}

// UnPack unpack method arguments
func (method Method) UnPack(data []byte) ([]interface{}, error) {
	sign := data[:4]
	if 0 != bytes.Compare(sign, method.ID()) {
		return nil, errMethodIDNotMatch
	}
	return method.Inputs.UnpackValues(data[4:])
}

// Pack pack method input parameters to byte
func (method Method) Pack(val ...interface{}) ([]byte, error) {
	if len(method.Inputs) != len(val) {
		return nil, errMethodInputsNotMatch
	}
	data, err := method.Inputs.Pack(val...)
	if nil != err {
		return nil, err
	}
	return append(method.ID(), data...), err
}

// Sig get method signature, without parameter name
func (method Method) Sig() string {
	types := make([]string, len(method.Inputs))
	for i, input := range method.Inputs {
		types[i] = input.Type.String()
	}
	return fmt.Sprintf("%v(%v)", method.Name, strings.Join(types, ","))
}

// String get method full signatures, with parameter name and returns
func (method Method) String() string {
	inputs := make([]string, len(method.Inputs))
	for i, input := range method.Inputs {
		inputs[i] = fmt.Sprintf("%v %v", input.Name, input.Type)
	}
	outputs := make([]string, len(method.Outputs))
	for i, output := range method.Outputs {
		if len(output.Name) > 0 {
			outputs[i] = fmt.Sprintf("%v %v ", output.Name, output.Type)
		}
		outputs[i] += output.Type.String()
	}
	constant := ""
	if method.Constant {
		constant = " constant"
	}

	methodType := methodTypeMap[method.Type]
	payable := " payable"
	if !method.Payable {
		payable = ""
	}
	// stateMutability := methodStateMutability[method.StateMutability]

	returns := fmt.Sprintf("returns%v%v (%v)", payable, method.StateMutability, strings.Join(outputs, ", "))
	if 2 != method.Type { // only func type has returns
		returns = ""
	}
	return fmt.Sprintf("%v %v(%v) %s%v", methodType, method.Name, strings.Join(inputs, ", "), constant, returns)
}

// ID return method name Sign(first 4 byte of method Sig()'s Keccak256 hash)
func (method Method) ID() []byte {
	return crypto.Keccak256([]byte(method.Sig()))[:4]
}

// Topic return the full byte of method Sig()'s Keccak256 hash
func (method Method) Topic() []byte {
	return crypto.Keccak256([]byte(method.Sig()))
}

// ExtractEventTopicParam ...
//	topic 固定为32byte，不足位在前方补0
func (method Method) ExtractEventTopicParam(topic [][]byte) ([]interface{}, error) {

	args := abi.Arguments{}
	for idx, arg := range method.Inputs {
		if arg.Indexed {
			args = append(args, method.Inputs[idx])
		}
	}

	if len(args) != len(topic) {
		return nil, fmt.Errorf("Parameter count not match")
	}

	outputs := make([]interface{}, len(args))
	return outputs, nil
}
