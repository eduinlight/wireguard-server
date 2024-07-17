# Wireguard server with Access Control List (ACL)

This repository provide an easy way to create a wireguard server with ACL.
Is built in top of [wg-easy](https://github.com/wg-easy/wg-easy) to provide an easy way to deny/accept only access of vpn users to some ips.
The ACL can work in two possible modes:

- `ALLOW_SOME_DENY_ALL`: Allow vpn users the access to _only_ some ips. `Default mode`
- `DENY_SOME_ALLOW_ALL`: Deny vpn users the access to _only_ some ips.

## Prerequisites

- `iptables` and `iptables-persistent` linux packages installed. Tested on `debian`.
- [docker](https://www.docker.com/)
- [bash](https://www.gnu.org/software/bash/)
- [make](https://www.gnu.org/software/make/)
- Root privileges

## Create the server

1. Copy the distributed environment file `.env.dist` to `.env`.
2. All needed values to start a wg server are already setted for you.
   Refer to [wg-easy](https://github.com/wg-easy/wg-easy) if you want to customize it more.
   For a minimum of configuration this are the required variables:

```BASH
# wg host example: vpn.example.com
WG_HOST=
# web ui password
PASSWORD=
```

3. Change if needed the default `ACL_MODE` variable depending on your use case.
4. To `allow/deny` some ips edit `ips.sh` file and add them to the `IPS` variable.
   - For `ACL_MODE=ALLOW_SOME_DENY_ALL` this ips are allowed and the rest are denied.
   - For `ACL_MODE=DENY_SOME_ALLOW_ALL` this ips are denied and the rest are allowed.
5. Start the server: `make up`

## Stop the server

Execute `make down` command to clean the `DOCKER-USER` iptables chain and remove the container and created network.

## Accept all connections

Set the value of `ACL_MODE` to `DENY_SOME_ALLOW_ALL` and keep empty the `IPS` variable in `ips.sh` file.

## Connect clients

1. Visit `localhost:9001` or the port specified in `PORT` variable.
2. Set the password to the one specified in the `PASSWORD` variable.
3. UI is very simple and straight forward just follow your instinct.
