#!/bin/bash

echo "Running vpnup script"
source /config/.startingenv
env

#iptables -A OUTPUT -d localhost -j ACCEPT

if [ ! -z "${LAN_NETWORK}" ]; then
  IFS=','; tokens=( ${LAN_NETWORK} )
  for subnet in "${tokens[@]}"; do
    echo "Adding static route for ${subnet} gw ${route_net_gateway}"
    ip route add ${subnet} via ${route_net_gateway} dev eth0
#    iptables -A OUTPUT -m owner --uid-owner abc -d ${subnet} -j ACCEPT
  done
fi

LOCALSUBNET=$(grep LOCALSUBNET /config/defaultroute|cut -f2 -d:)
echo "Adding static route for ${LOCALSUBNET} gw ${route_net_gateway}"
ip route add ${LOCALSUBNET} via ${route_net_gateway} dev eth0
#iptables -A OUTPUT -m owner --uid-owner abc -d ${LOCALSUBNET} -j ACCEPT

#iptables -A OUTPUT -m owner --uid-owner abc ! -o tun+ -j REJECT

echo "Starting deluged"
su - abc -s /bin/bash -c "deluged -c /config -L ${DELUGE_LOGGING}"

echo "Setting to /config/core.conf:listen_interface to ${trusted_ip}"
su - abc -s /bin/bash -c "deluge-console -c /config ""config --set listen_interface ${trusted_ip}"" "
