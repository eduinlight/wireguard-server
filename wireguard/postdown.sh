#!/usr/bin/env bash

source /etc/wireguard/ips.sh
source /etc/wireguard/common.sh

iptables -t nat -D POSTROUTING -s $SUBNET -o $OUT_INTERFACE -j MASQUERADE
iptables -D INPUT -p udp -m udp --dport $WG_PORT -j ACCEPT
iptables -D FORWARD -i $WG_INTERFACE -o $OUT_INTERFACE -j ACCEPT
iptables -D FORWARD -i $OUT_INTERFACE -o $WG_INTERFACE -j ACCEPT

if [ $MODE == "DENY_ALLOW" ]; then
  for IP in ${IPS[@]}; do
    iptables -D INPUT -i $OUT_INTERFACE -s $IP -j DROP
    iptables -D OUTPUT -o $OUT_INTERFACE -d $IP -j DROP
  done
  iptables -D INPUT -i $OUT_INTERFACE -j ACCEPT
  iptables -D OUTPUT -o $OUT_INTERFACE -j ACCEPT
elif [ $MODE == "ALLOW_DENY" ]; then
  for IP in ${IPS[@]}; do
    iptables -D INPUT -i $OUT_INTERFACE -s $IP -j ACCEPT
    iptables -D OUTPUT -o $OUT_INTERFACE -d $IP -j ACCEPT
  done
  iptables -D INPUT -i $OUT_INTERFACE -j DROP
  iptables -D OUTPUT -o $OUT_INTERFACE -j DROP
else
  echo "NOT ALLOWED MODE ${MODE}"
  exit 1
fi
