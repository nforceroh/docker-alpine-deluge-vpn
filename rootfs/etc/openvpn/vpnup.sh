#!/bin/bash

echo "Running vpnup script"
source /config/.startingenv
env

iptables -A OUTPUT -d localhost -j ACCEPT

if [ ! -z "${LAN_NETWORK}" ]; then
  IFS=','; tokens=( ${LAN_NETWORK} )
  for subnet in "${tokens[@]}"; do
    echo "Adding static route for ${subnet} gw ${route_net_gateway}"
    route add -net ${subnet} gw ${route_net_gateway} dev eth0
    iptables -A OUTPUT -m owner --uid-owner abc -d ${subnet} -j ACCEPT
  done
fi

iptables -A OUTPUT -m owner --uid-owner abc ! -o tun+ -j REJECT


