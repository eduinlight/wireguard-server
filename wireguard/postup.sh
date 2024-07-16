#!/usr/bin/env bash

source /etc/wireguard/ips.sh
source /etc/wireguard/common.sh

iptables -t nat -A POSTROUTING -s $SUBNET -o $OUT_INTERFACE -j MASQUERADE
iptables -A INPUT -p udp -m udp --dport $WG_PORT -j ACCEPT
iptables -A FORWARD -i $WG_INTERFACE -o $OUT_INTERFACE -j ACCEPT
iptables -A FORWARD -i $OUT_INTERFACE -o $WG_INTERFACE -j ACCEPT
# allow dns
iptables -A FORWARD -d $WG_DEFAULT_DNS -j ACCEPT
iptables -A FORWARD -s $WG_DEFAULT_DNS -j ACCEPT

if [ $ACL_MODE == "DENY_SOME_ALLOW_ALL" ]; then
  for IP in ${IPS[@]}; do
    iptables -A FORWARD -i $OUT_INTERFACE -s $IP -j DROP
    iptables -A FORWARD -o $OUT_INTERFACE -d $IP -j DROP
  done
  iptables -A FORWARD -i $OUT_INTERFACE -j ACCEPT
  iptables -A FORWARD -o $OUT_INTERFACE -j ACCEPT
elif [ $ACL_MODE == "ALLOW_SOME_DENY_ALL" ]; then
  for IP in ${IPS[@]}; do
    iptables -A FORWARD -i $OUT_INTERFACE -s $IP -j ACCEPT
    iptables -A FORWARD -o $OUT_INTERFACE -d $IP -j ACCEPT
  done
  iptables -A FORWARD -i $OUT_INTERFACE -j DROP
  iptables -A FORWARD -o $OUT_INTERFACE -j DROP
else
  echo "NOT ALLOWED ACL_MODE ${ACL_MODE}"
  exit 1
fi
