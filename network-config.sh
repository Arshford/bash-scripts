#!/bin/bash

# Get the server IP from the hostname -I command (assuming the server has a single IP address)
SERVER_IP=$(hostname -I | awk '{print $1}')
INTERFACE="eth0"

# Extract the last octet of the IP address
LAST_OCTET=$(echo $SERVER_IP | awk -F. '{print $4}')

# Determine the gateway based on the last octet of the IP address
if [ "$LAST_OCTET" -ge 129 ] && [ "$LAST_OCTET" -le 190 ]; then
    GATEWAY="156.232.88.129"
elif [ "$LAST_OCTET" -ge 194 ]; then
    GATEWAY="156.232.88.193"
else
    echo "No matching gateway rule for IP $SERVER_IP"
    exit 1
fi

# Update the network configuration for eth0
cat <<EOF > /etc/sysconfig/network-scripts/ifcfg-$INTERFACE
DEVICE=$INTERFACE
BOOTPROTO=none
ONBOOT=yes
IPADDR=$SERVER_IP
NETMASK=255.255.255.255
GATEWAY=$GATEWAY
DNS1=8.8.8.8
EOF

# Restart the NetworkManager service to apply changes
systemctl restart NetworkManager

echo "Network configuration updated for $INTERFACE with IP $SERVER_IP, Gateway $GATEWAY, and DNS 8.8.8.8"
