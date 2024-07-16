#!/usr/bin/env bash

source /etc/wireguard/common.sh

iptables -t nat -D POSTROUTING -s $SUBNET -o $OUT_INTERFACE -j MASQUERADE
iptables -D INPUT -p udp -m udp --dport $WG_PORT -j ACCEPT
iptables -D FORWARD -i $WG_INTERFACE -o $OUT_INTERFACE -j ACCEPT
iptables -D FORWARD -i $OUT_INTERFACE -o $WG_INTERFACE -j ACCEPT
