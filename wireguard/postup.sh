#!/usr/bin/env bash

source /etc/wireguard/common.sh

iptables -t nat -A POSTROUTING -s $SUBNET -o $OUT_INTERFACE -j MASQUERADE
iptables -A INPUT -p udp -m udp --dport $WG_PORT -j ACCEPT
iptables -A FORWARD -i $WG_INTERFACE -o $OUT_INTERFACE -j ACCEPT
iptables -A FORWARD -i $OUT_INTERFACE -o $WG_INTERFACE -j ACCEPT
