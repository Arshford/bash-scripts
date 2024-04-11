#!/bin/bash
#
# Script written by Arshford
# Copyright (c) 2023 Arsh. All rights reserved.
#
# Path to CyberPanel installation log file
log_file="/var/log/installLogs.txt"

# Function to check if CyberPanel installation is successful
check_installation_status() {
    if grep -q "CyberPanel installation successfully completed!" "$log_file"; then
        return 0
    else
        return 1
    fi
}

# Check if CyberPanel installation is successful
while ! check_installation_status; do
    echo "Waiting for CyberPanel installation to complete..."
    sleep 10  # Check every 10 seconds
done

# Wait for an additional 5 minutes
echo "CyberPanel installation successful. Waiting for 5 minutes before proceeding..."
sleep 100  # Wait for 5 minutes

# Run the rest of the script
# Replace the following lines with your script
echo "Running the rest of the script..."
# Generate a random password
password=$(tr -dc '[:alnum:]' < /dev/urandom | head -c 12)
echo "Password: $password"
# Update the CyberPanel admin password
adminPass "$password"
# Save username and password to a file
echo "Username: admin" > /home/ubuntu/credentials.txt
echo "Password: $password" >> /home/ubuntu/credentials.txt
# Get the IP address and hostname of the server
server_ip=$(hostname -I | awk '{print $1}')
hostname=$(hostname)
# Email subject including server IP and hostname
subject="CyberPanel Credentials - Server IP: $server_ip - Hostname: $hostname"
# Send email with credentials using sendmail
sendmail arshford@cloudoon.com <<EOF
Subject: $subject

Hello,

Your CyberPanel credentials are as follows:
Username: admin
Password: $password

Server IP: $server_ip
Hostname: $hostname

Best regards,
Truehost Cloud
EOF
