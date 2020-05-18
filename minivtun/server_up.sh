#!/bin/sh
#vars
ROOT_DIR="$(cd "$(dirname $0)"; pwd)"
TUN_CONFIG="$ROOT_DIR/server.conf"

# turn on IP forwarding
sysctl -w net.ipv4.ip_forward=1 > /dev/null 2>&1

#get gateway and profiles
#gw_intf_oc=`ip route show 0/0 | sort -k 7 | head -n 1 | sed -n 's/^default.* dev \([^ ]*\).*/\1/p'`
minivtun_udpport=`sed -n 's/^server_port.*=\(.*\)/\1/p' $TUN_CONFIG`
minivtun_ip4_work_mask=`sed -n 's/^local.*=\(.*\)/\1/p' $TUN_CONFIG`

# turn on NAT over default gateway and VPN
iptables -t nat -A POSTROUTING -s $minivtun_ip4_work_mask ! -d $minivtun_ip4_work_mask  -j MASQUERADE

iptables -I FORWARD -s $minivtun_ip4_work_mask -j ACCEPT

iptables -A FORWARD -d $minivtun_ip4_work_mask -j ACCEPT

iptables -A INPUT -p udp --dport $minivtun_udpport -j ACCEPT

iptables -A FORWARD  -s $minivtun_ip4_work_mask -m state --state RELATED,ESTABLISHED -j ACCEPT

iptables -t mangle -A FORWARD -p tcp -m tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
