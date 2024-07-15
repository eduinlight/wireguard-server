#!/usr/bin/env bash

source /etc/wireguard/ips.sh
source /etc/wireguard/common.sh

iptables -t nat -D POSTROUTING -s $SUBNET -o $OUT_INTERFACE -j MASQUERADE
iptables -D INPUT -p udp -m udp --dport $WG_PORT -j ACCEPT

if [ $MODE == "DENY_ALLOW" ]; then
  for IP in ${IPS[@]}; do
    iptables -D FORWARD -i $WG_INTERFACE -o $OUT_INTERFACE -s $IP -j DROP
    iptables -D FORWARD -i $OUT_INTERFACE -o $WG_INTERFACE -d $IP -j DROP
  done
  iptables -D FORWARD -i $WG_INTERFACE -o $OUT_INTERFACE -j ACCEPT
  iptables -D FORWARD -i $OUT_INTERFACE -o $WG_INTERFACE -j ACCEPT
elif [ $MODE == "ALLOW_DENY" ]; then
  for IP in ${IPS[@]}; do
    iptables -D FORWARD -i $WG_INTERFACE -o $OUT_INTERFACE -s $IP -j ACCEPT
    iptables -D FORWARD -i $OUT_INTERFACE -o $WG_INTERFACE -d $IP -j ACCEPT
  done
  iptables -D FORWARD -i $WG_INTERFACE -o $OUT_INTERFACE -j DROP
  iptables -D FORWARD -i $OUT_INTERFACE -o $WG_INTERFACE -j DROP
else
  echo "NOT ALLOWED MODE ${MODE}"
  exit 1
fi
