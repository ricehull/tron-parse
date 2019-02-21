package account

import (
	"testing"
	"time"

	"tron-parse/explorer/main/module/rawmysql"
)

func TestAW(*testing.T) {

	rawmysql.DSN = "tron:tron@tcp(mine:3306)/troney"
	aw := NewAccountWorker(3, 3, 1, 10, 100)
	aw.StartAccountWorker()
	aw.StartDBWorker()
	aw.AppendTask2([][]byte{[]byte("TMuA6YqfCeX8EhbfYEg5y7S4DqzSJireY9")})

	time.Sleep(20 * time.Second)
	aw.WaitStop()
}
