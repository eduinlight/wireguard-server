#!/usr/bin/env bash

source ./.env
source ./ips.sh

DOCKER_CONTAINER_INTERFACE=br-$(docker network ls -f "name=${WG_CONTAINER_NETWORK_NAME}" -q)
IPTABLES_DOCKER_CHAIN=DOCKER-USER
