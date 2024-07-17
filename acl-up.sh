#!/usr/bin/env bash

source ./common.sh

if [ $ACL_MODE == "DENY_SOME_ALLOW_ALL" ]; then
  # accept all connections
  iptables -I $IPTABLES_DOCKER_CHAIN -i $DOCKER_CONTAINER_INTERFACE -j ACCEPT
  for IP in ${IPS[@]}; do
    # deny connections from this ip
    iptables -I $IPTABLES_DOCKER_CHAIN -i $DOCKER_CONTAINER_INTERFACE -m conntrack --ctorigdst $IP -j DROP
  done
elif [ $ACL_MODE == "ALLOW_SOME_DENY_ALL" ]; then
  # deny all connections
  iptables -I $IPTABLES_DOCKER_CHAIN -i $DOCKER_CONTAINER_INTERFACE -j DROP
  for IP in ${IPS[@]}; do
    # accept connections from this ip
    iptables -I $IPTABLES_DOCKER_CHAIN -i $DOCKER_CONTAINER_INTERFACE -m conntrack --ctorigdst $IP -j ACCEPT
  done
else
  echo "NOT ALLOWED ACL_MODE ${ACL_MODE}"
  exit 1
fi

# allow dns
iptables -I $IPTABLES_DOCKER_CHAIN -i $DOCKER_CONTAINER_INTERFACE -m conntrack --ctorigdst $WG_DEFAULT_DNS --ctorigdstport 53 -j ACCEPT

# accept all stablished conections previously accepted
iptables -I $IPTABLES_DOCKER_CHAIN -i $DOCKER_CONTAINER_INTERFACE -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# saving changes
iptables-save
