#!/bin/bash

# Step 1: Disable Cron
echo "Disabling cron service..."
systemctl stop cron

# Step 2: Delete Malware Files
echo "Removing malware files..."
rm -f /etc/data/kinsing
rm -f /etc/kinsing
rm -f /tmp/kdevtmpfsi
rm -rf /usr/lib/secure
rm -f /usr/lib/secure/udiskssd
rm -f /usr/bin/network-setup.sh
rm -f /usr/.sshd-network-service.sh
rm -rf /usr/.network-setup
rm -f /usr/.network-setup/config.json
rm -f /usr/.network-setup/xmrig-*tar.gz
rm -f /usr/.network-watchdog.sh
rm -f /tmp/kdevtmpfsi
rm -f /etc/data/libsystem.so
rm -f /etc/data/kinsing
rm -f /dev/shm/kdevtmpfsi

# Remove immutable flags if necessary
echo "Removing immutable flags from directories and files..."
chattr -i /usr/lib/secure/udiskssd
chattr -i /usr/lib/secure

# Step 3: Remove Suspicious Services
echo "Stopping and removing suspicious services..."
systemctl stop bot.service
systemctl disable bot.service
rm /lib/systemd/system/bot.service
systemctl daemon-reload

systemctl stop systemd_s.service
systemctl disable systemd_s.service
rm /etc/systemd/system/systemd_s.service

systemctl stop sshd-network-service.service
systemctl disable sshd-network-service.service
rm /etc/systemd/system/sshd-network-service.service

systemctl stop network-monitor.service
systemctl disable network-monitor.service
rm /etc/systemd/system/network-monitor.service

# Step 4: Kill Suspicious Processes
echo "Killing suspicious processes..."
ps -aux | grep -E 'kinsing|udiskssd|kdevtmpfsi|bash2|.network-setup|syshd|atdb' | awk '{print $2}' | xargs kill -9

# Step 5: Unload pre-loaded libraries (Delete /etc/ld.so.preload)
echo "Unloading preloaded libraries and killing related processes..."
rm -f /etc/ld.so.preload
lsof | grep libsystem.so | awk '{print $2}' | xargs kill -9

# Step 6: Delete Suspicious Cron Jobs
echo "Removing suspicious cron jobs..."
# Remove immutable flags on crontab if necessary
chattr -ia /var/spool/cron/crontabs/root
chattr -ia /var/spool/cron/root

# Check for suspicious crontab entries for root user
crontab -l | grep -v '/usr/lib/secure/atdb' | crontab -

# Additional Steps
echo "Installing chkrootkit and rkhunter for further scanning..."
apt-get update && apt-get install -y chkrootkit rkhunter

echo "Running rkhunter scan..."
rkhunter --check

# Step 7: Locate files modified in the last 2 days
echo "Finding files modified in the last 2 days..."
find / -mtime 2

# Upgrade CyberPanel
echo "Upgrading CyberPanel..."
sh <(curl https://raw.githubusercontent.com/usmannasir/cyberpanel/stable/preUpgrade.sh || wget -O - https://raw.githubusercontent.com/usmannasir/cyberpanel/stable/preUpgrade.sh)

echo "Malware removal script completed."
