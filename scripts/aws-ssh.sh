#!/bin/bash

# You should only need to modify the following definition
SSH_KEY_PATH="$HOME/.ssh/irvine-capstone-rer-key-pair.pem"

# Check for the correct number of parameters
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <instance-ip>"
    exit 1
fi

# Configuration
INSTANCE_IP="$1"
REMOTE_USER="${2:-ubuntu}"  # Default to "ubuntu"

# SSH into the remote instance
echo "Connecting to the remote instance..."
ssh -i "$SSH_KEY_PATH" "$REMOTE_USER@$INSTANCE_IP"
