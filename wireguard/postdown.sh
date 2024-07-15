#!/usr/bin/env bash

iptables -t nat -D POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
iptables -D INPUT -p udp -m udp --dport 51820 -j ACCEPT
iptables -D FORWARD -i wg0 -j ACCEPT
iptables -D FORWARD -o wg0 -j ACCEPT
