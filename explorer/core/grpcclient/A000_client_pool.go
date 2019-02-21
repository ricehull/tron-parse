package grpcclient

import (
	"fmt"
	"strings"
	"sync"
	"time"

	"google.golang.org/grpc"
	"google.golang.org/grpc/connectivity"
)

/*
TODO: 20181107
1. 使用stack管理单个地址的连接池，尽量复用长效连接
2. 同类型连接，优先获取存在缓存的，而不是随机一个ip
*/

var clientPool sync.Map //ip:port -> ClientConnBuffer

var _cleanOnce sync.Once

// Default ...
var (
	DefaultPoolSize    = 300
	DefaultTimeoutTime = 300 * time.Second
)

// IdleClientType ...
type IdleClientType struct {
	c *grpc.ClientConn
	t time.Time
}

// Err ...
var (
	ErrTargetNotMatch     = fmt.Errorf("Client Target not match")
	ErrClientChanFull     = fmt.Errorf("Client Chan full")
	ErrInvalidClientState = fmt.Errorf("client state invalid")
)

// getCient ...
func getCient(target string) (*grpc.ClientConn, error) {
	c, ok := clientPool.Load(target)

	var ccb *ClientConnBuffer
	if ok && nil != c {
		ccb, ok = c.(*ClientConnBuffer)
		if !ok || nil == ccb {
			ccb = NewClientConnBuffer(target, DefaultPoolSize)
			clientPool.Store(target, ccb)
		}
	} else {
		ccb = NewClientConnBuffer(target, DefaultPoolSize)
		clientPool.Store(target, ccb)
	}

	return ccb.GetConnection()
}

// pushClient ...
func pushClient(target string, c *grpc.ClientConn) error {
	cc, ok := clientPool.Load(target)

	var ccb *ClientConnBuffer
	if ok && nil != cc {
		ccb, ok = cc.(*ClientConnBuffer)
		if !ok || nil == ccb {
			ccb = NewClientConnBuffer(target, DefaultPoolSize)
		}
	} else {
		ccb = NewClientConnBuffer(target, DefaultPoolSize)
		clientPool.Store(target, ccb)
	}
	return ccb.PushConnection(c)
}

// GetConnectionPoolState ...
func GetConnectionPoolState() string {

	ret := make([]string, 0)
	clientPool.Range(func(key, val interface{}) bool {
		ccb, ok := val.(*ClientConnBuffer)
		if ok && nil != ccb {
			ret = append(ret, fmt.Sprintf("target:[%v], connection pool current size:%v",
				key, len(ccb.ClientChan)))
		}
		return true
	})
	return strings.Join(ret, "\n")
}

// NewClientConnBuffer ...
func NewClientConnBuffer(target string, poolSize int) *ClientConnBuffer {
	_cleanOnce.Do(func() {
		go cleanConnectionPoolTask()
	})
	// fmt.Printf("NewClientConnBuffer for target:[%v], poolSize:[%v]\n", target, poolSize)
	return &ClientConnBuffer{
		Target:     target,
		ClientChan: make(chan *IdleClientType, poolSize),
		PoolSize:   poolSize,
	}
}

// ClientConnBuffer ...
type ClientConnBuffer struct {
	Target     string
	ClientChan chan *IdleClientType
	PoolSize   int
}

// GetConnection get exists connection or create a new one
func (ccb *ClientConnBuffer) GetConnection() (ret *grpc.ClientConn, err error) {
	select {
	case retR := <-ccb.ClientChan:
		ret = retR.c
		// fmt.Printf("get buffer grpcclient connection for target:[%v]\n", ccb.Target)
	default:
		// fmt.Printf("new grpcclient connection for target:[%v]\n", ccb.Target)
		ret, err = grpc.Dial(ccb.Target, grpc.WithInsecure())
		if nil != err {
			return nil, err
		}
	}
	return ret, err
}

// PushConnection ...
func (ccb *ClientConnBuffer) PushConnection(c *grpc.ClientConn) (err error) {
	if nil == c {
		// fmt.Printf("Close Target err:[%v] grpcclient connection for target:[%v]\n", c.Target(), ccb.Target)
		return nil
	}
	if c.Target() != ccb.Target {
		c.Close()
		// fmt.Printf("Close Target err:[%v] grpcclient connection for target:[%v]\n", c.Target(), ccb.Target)
		return ErrTargetNotMatch
	}
	stat := c.GetState()
	if connectivity.Idle == stat || connectivity.Ready == stat {
		select {
		case ccb.ClientChan <- &IdleClientType{
			c: c,
			t: time.Now(),
		}:
			// fmt.Printf("store grpcclient connection for target:[%v]\n", ccb.Target)
			return nil
		default:
			c.Close()
			// fmt.Printf("Target:[%v] client chan is full(len:%v), close connection\n", ccb.Target, len(ccb.ClientChan))
			return ErrClientChanFull
		}
	}
	// fmt.Printf("Close state bad:[%v] grpcclient connection for target:[%v]\n", stat, ccb.Target)
	c.Close()
	return ErrInvalidClientState
}

func cleanConnectionPoolTask() {
	for {
		time.Sleep(DefaultTimeoutTime)
		CleanConnectionPool()
	}
}

// CleanConnectionPool ...
func CleanConnectionPool() {

	timeoutCnt := 0
	restCnt := 0
	clientPool.Range(func(key, val interface{}) bool {

		ccb, ok := val.(*ClientConnBuffer)
		if ok && nil != ccb {

			cnt := len(ccb.ClientChan)
			for i := 0; i < cnt; i++ {
				idc := <-ccb.ClientChan
				if time.Since(idc.t) > DefaultTimeoutTime {
					idc.c.Close()
					timeoutCnt++
				} else {
					restCnt++
					ccb.ClientChan <- idc
				}
			}
		}
		return true
	})

	fmt.Printf("[%v] clean timeout connection count:[%v], left:[%v]\n",
		time.Now().Format("2006-01-02 15:04:05.000"), timeoutCnt, restCnt)
	fmt.Println(GetConnectionPoolState())
}
