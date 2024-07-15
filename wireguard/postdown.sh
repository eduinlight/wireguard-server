#!/usr/bin/env bash

# source /etc/wireguard/ips.sh
# source /etc/wireguard/common.sh

SUBNET=10.8.0.0/24
WG_INTERFACE=wg0
WG_PORT=51820
OUT_INTERFACE=eth0

iptables -t nat -D POSTROUTING -s $SUBNET -o $OUT_INTERFACE -j MASQUERADE
iptables -D INPUT -p udp -m udp --dport $WG_PORT -j ACCEPT

# if [ $MODE == "ALLOW_DENY" ]; then
iptables -D FORWARD -i $WG_INTERFACE -j ACCEPT
iptables -D FORWARD -o $WG_INTERFACE -j ACCEPT
# elif [ $MODE == "DENY_ALLOW" ]; then
#   iptables -D FORWARD -i $WG_INTERFACE -j DROP
#   iptables -D FORWARD -o $WG_INTERFACE -j DROP
# else
#   echo "NOT ALLOWED MODE ${MODE}"
#   exit 1
# fi
#
# for IP in ${IPS[@]}; do
#   if [ $MODE == "ALLOW_DENY" ]; then
#     iptables -D FORWARD -i $WG_INTERFACE -s $IP -j DROP
#     iptables -D FORWARD -o $WG_INTERFACE -d $IP -j DROP
#   else
#     iptables -D FORWARD -i $WG_INTERFACE -s $IP -j ACCEPT
#     iptables -D FORWARD -o $WG_INTERFACE -d $IP -j ACCEPT
#     echo $IP
#   fi
# done
