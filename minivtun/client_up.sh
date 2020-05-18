#!/bin/sh

# example client up script for darwin
# will be executed when client is up

# all key value pairs in ShadowVPN config file will be passed to this script
# as environment variables, except password
ROOT_DIR="$(cd "$(dirname $0)"; pwd)"
CONFIG="$ROOT_DIR/client.conf"
IP_UP="${ROOT_DIR}/ip-up"
source $CONFIG

# get current gateway
orig_gw=$(netstat -nr | grep --color=never '^default' | grep -v 'utun' | sed 's/default *\([0-9\.]*\) .*/\1/' | head -1)
route add -net $server $orig_gw

# configure IP address and MTU of VPN interface
ifconfig $intf $local_tun_ip $remote_tun_ip mtu $mtu netmask 255.255.255.0 up

# change routing table
echo changing default route
route add -net 128.0.0.0 $remote_tun_ip -netmask 128.0.0.0
route add -net 0.0.0.0 $remote_tun_ip -netmask 128.0.0.0
route add -net $remote_tun_ip $orig_gw -netmask 255.255.255.255
echo default route changed to $remote_tun_ip

#china route
[ -x ${IP_UP} ] && sudo sh ${IP_UP} > /dev/null 2>&1

# change dns server
networksetup -setdnsservers Wi-Fi $dns_server

echo $0 done
