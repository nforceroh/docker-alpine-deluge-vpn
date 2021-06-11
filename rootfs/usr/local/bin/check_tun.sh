#!/bin/bash
# Cron entry:
# */1 * * * * /usr/local/bin/check_tunX.sh &> /dev/null
# Check for VPN, if not kill Deluge and if up
# then make sure Deluge is running
if pgrep deluged > /dev/null; then
    if [ ! $(ip a | grep tun0 | wc -l) -gt 1 ]; then
        echo "VPN down, killing deluge"
        pkill deluged
    else
        echo "VPN up"
        pgrep -x deluged > /dev/null && echo "Deluge Running"
    fi
fi