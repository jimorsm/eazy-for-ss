#!/bin/bash
#vars
ROOT_DIR="$(cd "$(dirname $0)"; pwd)"
CONFIG="$ROOT_DIR/client.conf"
source $CONFIG
[ -r $ROOT_DIR/speederv2.conf ] && source $ROOT_DIR/speederv2.conf
speederv2_pid=`ps cax|grep speederv2|awk '{print $1 }'`
[ ! -z $speederv2_pid ] && {
kill -9 $speederv2_pid
exit 0
}

nohup $ROOT_DIR/speederv2 -c -l$_server:$port -r$server:$_port -k "$password"  > /dev/null 2>&1 &

exit 0
