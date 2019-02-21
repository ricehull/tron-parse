oriPath=`pwd`
cd $GOPATH/src/github.com/tronprotocol/protocol
git checkout master
git pull


cd $GOPATH/src
DST_DIR=`pwd`

protoc -Igithub.com/tronprotocol/protocol -Igithub.com/googleapis/googleapis github.com/tronprotocol/protocol/core/*.proto --go_out=plugins=grpc:$DST_DIR
cd $GOPATH/src/github.com/tronprotocol/grpc-gateway/core
go build

cd $DST_DIR
protoc -Igithub.com/tronprotocol/protocol -Igithub.com/googleapis/googleapis github.com/tronprotocol/protocol/api/*.proto --go_out=plugins=grpc:$DST_DIR
cd $GOPATH/src/github.com/tronprotocol/grpc-gateway/api
go build

cd $oriPath