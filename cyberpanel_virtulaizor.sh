#!/bin/bash

# Define URLs for the scripts
SCRIPT1_URL="https://raw.githubusercontent.com/arshford/bash-scripts/main/cyberpanel.sh"
SCRIPT2_URL="https://raw.githubusercontent.com/arshford/bash-scripts/main/change_adminpass.sh"

# Directory to store scripts
SCRIPT_DIR="/usr/local/share/"

# Download script 1
wget -O "${SCRIPT_DIR}cyberpanel.sh" "$SCRIPT1_URL"

# Run script 1
chmod +x "${SCRIPT_DIR}cyberpanel.sh"
"${SCRIPT_DIR}cyberpanel.sh"

# Download script 2
wget -O "${SCRIPT_DIR}change_adminpass.sh" "$SCRIPT2_URL"

# Run script 2
chmod +x "${SCRIPT_DIR}change_adminpass.sh"
"${SCRIPT_DIR}change_adminpass.sh"
