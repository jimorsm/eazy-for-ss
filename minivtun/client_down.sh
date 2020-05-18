#!/bin/sh

# example client down script for darwin
# will be executed when client is down

# all key value pairs in ShadowVPN config file will be passed to this script
# as environment variables, except password
ROOT_DIR="$(cd "$(dirname $0)"; pwd)"
CONFIG="$ROOT_DIR/client.conf"
IP_DOWN="$ROOT_DIR/ip-down"
source $CONFIG

# revert routing table
echo reverting default route
route delete -net 128.0.0.0 $remote_tun_ip -netmask 128.0.0.0
route delete -net 0.0.0.0 $remote_tun_ip -netmask 128.0.0.0
route delete -net $server

# china route
[ -x ${IP_DOWN} ] && sudo sh ${IP_DOWN} > /dev/null 2>&1

# revert dns server
networksetup -setdnsservers Wi-Fi empty

echo $0 done
