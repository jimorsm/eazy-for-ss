#!/bin/sh
# This script will be set up minivtun
#source /koolshare/scripts/base.sh

ROOT_DIR="$(cd "$(dirname $0)"; pwd)"
TUN_CONFIG="$ROOT_DIR/server.conf"

source $TUN_CONFIG

#merlin
#modprobe tun
#群晖
#lsmod | grep tun
#insmod /lib/modules/tun.ko

echo "1 for run, 2 for stop"
read choose

if [ "x$choose" = "x1" ];then
	if [ -f $pid_file ];then
		echo minivtun is already running
		exit 1
	fi
	
	$ROOT_DIR/minivtun -l $server:$server_port -a $local_addr -m $mtu -n $intf -p $pid_file -e $password -d -t rc4 && \
	sh $ROOT_DIR/server_up.sh
else
	if [ ! -f $pid_file ];then
		echo minivtun is not running yet
		exit 1
	fi
	
	sh $ROOT_DIR/server_down.sh && \
	kill -9 `cat $pid_file` && \
	rm $pid_file
fi
:
