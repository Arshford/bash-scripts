#!/bin/bash

# Path to Centos Web Panel installation log file
log_file="/home/centos/cwpinstallation.log"

# Function to check if reboot command is found in the log file
check_reboot_command() {
    if grep -q "Reboot command: shutdown -r now" "$log_file"; then
        return 0
    else
        return 1
    fi
}

# Check if reboot command is found in the log file
if check_reboot_command; then
    echo "Reboot command found. Proceeding to change root password..."
    # Generate a random password
    root_password=$(tr -dc '[:alnum:]' < /dev/urandom | head -c 12)
    echo "Root Password: $root_password"
    # Change the root password using sudo
    echo "root:$root_password" | sudo chpasswd
    # Save the root password to a file
    echo "Root Password: $root_password" > /home/centos/rootpass.txt
    # Send email with root password using sendmail
    server_ip=$(hostname -I | awk '{print $1}')
    hostname=$(hostname)
    subject="CWP Login Credentials - Server IP: $server_ip - Hostname: $hostname"
    sendmail arshford@cloudoon.com <<EOF
Subject: $subject

Hello,

Your CWP login credentials are as follows:
Username: root
Password: $root_password

Server IP: $server_ip
Hostname: $hostname

Best regards,
Truehost Cloud
EOF
else
    echo "Reboot command not found. Exiting script."
fi
