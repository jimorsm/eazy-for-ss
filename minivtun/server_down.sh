#!/bin/sh
#vars
ROOT_DIR="$(cd "$(dirname $0)"; pwd)"
TUN_CONFIG="$ROOT_DIR/server.conf"

#gw_intf_oc=`ip route show 0/0 | sort -k 7 | head -n 1 | sed -n 's/^default.* dev \([^ ]*\).*/\1/p'`
minivtun_udpport=`sed -n 's/^server_port.*=\(.*\)/\1/p' $TUN_CONFIG`
minivtun_ip4_work_mask=`sed -n 's/^local.*=\(.*\)/\1/p' $TUN_CONFIG`

# turn on NAT over default gateway and VPN
iptables -t nat -D POSTROUTING -s $minivtun_ip4_work_mask ! -d $minivtun_ip4_work_mask  -j MASQUERADE

iptables -D FORWARD -s $minivtun_ip4_work_mask -j ACCEPT

iptables -D FORWARD -d $minivtun_ip4_work_mask -j ACCEPT

iptables -D INPUT -p udp --dport $minivtun_udpport -j ACCEPT

iptables -D FORWARD  -s $minivtun_ip4_work_mask -m state --state RELATED,ESTABLISHED -j ACCEPT

iptables -t mangle -D FORWARD -p tcp -m tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
