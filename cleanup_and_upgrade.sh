#!/bin/bash

# Define log file
LOG_FILE="/var/log/cleanup_and_upgrade.log"

# Log function to append to the log file
log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" | tee -a $LOG_FILE
}

# Remove cronjob containing unk.sh
log "Removing root cronjob with unk.sh"
crontab -l -u root | grep -v 'unk.sh' | crontab -u root -
log "Cronjob containing unk.sh removed if existed."

# Stop and disable bot.service
log "Stopping bot.service"
systemctl stop bot.service 2>>$LOG_FILE
log "Disabling bot.service"
systemctl disable bot.service 2>>$LOG_FILE

# Remove bot.service if it exists
log "Removing bot.service"
rm -f /etc/systemd/system/bot.service
systemctl daemon-reload 2>>$LOG_FILE
log "bot.service removed and system daemon reloaded."

# Delete /etc/data/ directory
if [ -d "/etc/data/" ]; then
    log "Removing /etc/data/ directory"
    rm -rf /etc/data/
    log "/etc/data/ directory removed."
else
    log "/etc/data/ directory not found."
fi

# Upgrade CyberPanel to the latest version
log "Starting CyberPanel upgrade"
sh <(curl https://raw.githubusercontent.com/usmannasir/cyberpanel/stable/preUpgrade.sh || wget -O - https://raw.githubusercontent.com/usmannasir/cyberpanel/stable/preUpgrade.sh) >> $LOG_FILE 2>&1
log "CyberPanel upgrade completed."

log "Script execution finished."
