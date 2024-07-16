#!/usr/bin/env bash

source /etc/wireguard/ips.sh
source /etc/wireguard/common.sh

iptables -t nat -A POSTROUTING -s $SUBNET -o $OUT_INTERFACE -j MASQUERADE
iptables -A INPUT -p udp -m udp --dport $WG_PORT -j ACCEPT
iptables -A FORWARD -i $WG_INTERFACE -o $OUT_INTERFACE -j ACCEPT
iptables -A FORWARD -i $OUT_INTERFACE -o $WG_INTERFACE -j ACCEPT
# allow dns
iptables -A INPUT -d $WG_DEFAULT_DNS -j ACCEPT
iptables -A INPUT -s $WG_DEFAULT_DNS -j ACCEPT

if [ $MODE == "DENY_ALLOW" ]; then
  for IP in ${IPS[@]}; do
    iptables -A INPUT -i $OUT_INTERFACE -s $IP -j DROP
    iptables -A OUTPUT -o $OUT_INTERFACE -d $IP -j DROP
  done
  iptables -A INPUT -i $OUT_INTERFACE -j ACCEPT
  iptables -A OUTPUT -o $OUT_INTERFACE -j ACCEPT
elif [ $MODE == "ALLOW_DENY" ]; then
  for IP in ${IPS[@]}; do
    iptables -A INPUT -i $OUT_INTERFACE -s $IP -j ACCEPT
    iptables -A OUTPUT -o $OUT_INTERFACE -d $IP -j ACCEPT
  done
  iptables -A INPUT -i $OUT_INTERFACE -j DROP
  iptables -A OUTPUT -o $OUT_INTERFACE -j DROP
else
  echo "NOT ALLOWED MODE ${MODE}"
  exit 1
fi
