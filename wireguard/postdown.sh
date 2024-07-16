#!/usr/bin/env bash

source /etc/wireguard/ips.sh
source /etc/wireguard/common.sh

iptables -t nat -D POSTROUTING -s $SUBNET -o $OUT_INTERFACE -j MASQUERADE
iptables -D INPUT -p udp -m udp --dport $WG_PORT -j ACCEPT
iptables -D FORWARD -i $WG_INTERFACE -o $OUT_INTERFACE -j ACCEPT
iptables -D FORWARD -i $OUT_INTERFACE -o $WG_INTERFACE -j ACCEPT
# allow dns
iptables -d $WG_DEFAULT_DNS -j ACCEPT
iptables -s $WG_DEFAULT_DNS -j ACCEPT

if [ $ACL_MODE == "DENY_SOME_ALLOW_ALL" ]; then
  for IP in ${IPS[@]}; do
    iptables -i $OUT_INTERFACE -s $IP -j DROP
    iptables -o $OUT_INTERFACE -d $IP -j DROP
  done
  iptables -i $OUT_INTERFACE -j ACCEPT
  iptables -o $OUT_INTERFACE -j ACCEPT
elif [ $ACL_MODE == "ALLOW_SOME_DENY_ALL" ]; then
  for IP in ${IPS[@]}; do
    iptables -i $OUT_INTERFACE -s $IP -j ACCEPT
    iptables -o $OUT_INTERFACE -d $IP -j ACCEPT
  done
  iptables -i $OUT_INTERFACE -j DROP
  iptables -o $OUT_INTERFACE -j DROP
else
  echo "NOT ALLOWED ACM_MODE ${ACL_MODE}"
  exit 1
fi
