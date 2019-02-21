#!/bin/bash

app="fullnode"
root="/home/java-tron/tron/explorer/syncData"
upCmd="start_fullnode_b.sh"
tsCmd=`date '+%Y-%m-%d %H:%M:%S'`

cd $root
exec >>./watchDog.log
exec 2>>./watchDog.log


#pid=$( printf '%d' `ps aux|grep $app |grep -v grep| awk '{print $2}'` )
pid=$(ps aux|grep $app |grep -v grep| awk '{print $2}')
if [ "$pid" = "" ]; then
	# start
	echo "[$tsCmd] $app is down, restart ...."
	cd $root
	bash $upCmd
else
	echo "[$tsCmd] $app is running with pid:$pid"
fi
