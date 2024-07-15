#!/usr/bin/env bash

source /etc/wireguard/ips.sh
source /etc/wireguard/common.sh

iptables -t nat -A POSTROUTING -s $SUBNET -o $OUT_INTERFACE -j MASQUERADE
iptables -A INPUT -p udp -m udp --dport $WG_PORT -j ACCEPT

# if [ $MODE == "ALLOW_DENY" ]; then
#   iptables -A FORWARD -i $WG_INTERFACE -j ACCEPT
#   iptables -A FORWARD -o $WG_INTERFACE -j ACCEPT
# elif [ $MODE == "DENY_ALLOW" ]; then
iptables -A FORWARD -i $WG_INTERFACE -j ACCEPT
iptables -A FORWARD -o $WG_INTERFACE -j ACCEPT
# else
#   echo "NOT ALLOWED MODE ${MODE}"
#   exit 1
# fi

# for IP in ${IPS[@]}; do
#   if [ $MODE == "ALLOW_DENY" ]; then
#     iptables -A FORWARD -i $WG_INTERFACE -d $IP -j DROP
#     iptables -A FORWARD -o $WG_INTERFACE -s $IP -j DROP
#   else
# iptables -A FORWARD -i $WG_INTERFACE -d $IP -j ACCEPT
# iptables -A FORWARD -o $WG_INTERFACE -s $IP -j ACCEPT
#     echo $IP
#   fi
# done
