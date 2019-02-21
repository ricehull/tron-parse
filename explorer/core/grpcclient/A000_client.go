package grpcclient

import (
	"google.golang.org/grpc/connectivity"

	"google.golang.org/grpc"
)

type _conn struct {
	c          *grpc.ClientConn
	serverAddr string
}

// Connect 尝试建立连接
func (c *_conn) Connect() (err error) {

	c.c, err = getCient(c.serverAddr)
	if nil != err {
		return err
	}
	// fmt.Printf("Connection status:%v\n", c.c.GetState())

	return
}

// Close release the connection
func (c *_conn) Close() {
	if nil != c {
		pushClient(c.serverAddr, c.c)
	}
}

// ConnectOld 尝试建立连接
func (c *_conn) ConnectOld() (err error) {

	c.c, err = grpc.Dial(c.serverAddr, grpc.WithInsecure())
	if nil != err {
		return err
	}
	// fmt.Printf("Connection status:%v\n", c.c.GetState())

	return
}

// GetState 返回连接状态
func (c *_conn) GetState() connectivity.State {
	return c.c.GetState()
}

// Target 返回连接端
func (c *_conn) Target() string {
	return c.c.Target()
}

// CloseOld release the connection
func (c *_conn) CloseOld() {
	if nil != c {
		c.c.Close()
	}
}
