#!/bin/bash

echo "Running vpnup script"
source /config/.startingenv
env

iptables -A OUTPUT -d localhost -j ACCEPT

if [ ! -z "${LAN_NETWORK}" ]; then
  IFS=','; tokens=( ${LAN_NETWORK} )
  for subnet in "${tokens[@]}"; do
    echo "Adding static route for ${subnet} gw ${route_net_gateway}"
    ip route add ${subnet} via ${route_net_gateway} dev eth0
    iptables -A OUTPUT -m owner --uid-owner abc -d ${subnet} -j ACCEPT
  done
fi

iptables -A OUTPUT -m owner --uid-owner abc ! -o tun+ -j REJECT

echo "Starting deluged"
su - abc -s /bin/bash -c "deluged -c /config"

echo "Starting deluge-web"
su - abc -s /bin/bash -c "deluge-web -c /config"
