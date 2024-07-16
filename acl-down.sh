#!/usr/bin/env bash

source ./common.sh

if [ $ACL_MODE == "DENY_SOME_ALLOW_ALL" ]; then
  iptables -D $IPTABLES_DOCKER_CHAIN -i $DOCKER_CONTAINER_INTERFACE -j ACCEPT
  for IP in ${IPS[@]}; do
    iptables -D $IPTABLES_DOCKER_CHAIN -i $DOCKER_CONTAINER_INTERFACE -d $IP -j DROP
  done
elif [ $ACL_MODE == "ALLOW_SOME_DENY_ALL" ]; then
  iptables -D $IPTABLES_DOCKER_CHAIN -i $DOCKER_CONTAINER_INTERFACE -j DROP
  for IP in ${IPS[@]}; do
    iptables -D $IPTABLES_DOCKER_CHAIN -i $DOCKER_CONTAINER_INTERFACE -d $IP -j ACCEPT
  done
else
  echo "NOT ALLOWED ACL_MODE ${ACL_MODE}"
  exit 1
fi

# allow connection to vpn
iptables -D $IPTABLES_DOCKER_CHAIN -i $DOCKER_CONTAINER_INTERFACE -d $WG_CONTAINER_IP -j ACCEPT

# allow dns
iptables -D $IPTABLES_DOCKER_CHAIN -i $DOCKER_CONTAINER_INTERFACE -s $WG_DEFAULT_DNS -j ACCEPT
