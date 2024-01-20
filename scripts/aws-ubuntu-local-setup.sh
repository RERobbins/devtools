#!/bin/bash

# You should only need to modify the next two definitions
SSH_KEY_PATH="$HOME/.ssh/RERobbins-key-pair.pem"
LOCAL_SSH_KEY_PATH="$HOME/.ssh/capstone_ed25519"

# Check for the correct number of parameters
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <instance-ip> [remote-user]"
    exit 1
fi

# Other Configuration
INSTANCE_IP="$1"
REMOTE_USER="${2:-ubuntu}"  # Default to "ubuntu"
LOCAL_SETUP_SCRIPT_PATH="$HOME/projects/other/devtools/scripts/aws-ubuntu-remote-setup.sh"

# Copy SSH keys to the remote instance
echo "Copying SSH keys to the remote instance..."
scp -i "$SSH_KEY_PATH" "$LOCAL_SSH_KEY_PATH" "$REMOTE_USER@$INSTANCE_IP:~/.ssh/"
scp -i "$SSH_KEY_PATH" "$LOCAL_SSH_KEY_PATH.pub" "$REMOTE_USER@$INSTANCE_IP:~/.ssh/"

# Copy the setup script to the remote instance
echo "Copying the setup script to the remote instance..."
scp -i "$SSH_KEY_PATH" "$LOCAL_SETUP_SCRIPT_PATH" "$REMOTE_USER@$INSTANCE_IP:~/"

# SSH into the remote instance
echo "Connecting to the remote instance..."
ssh -i "$SSH_KEY_PATH" "$REMOTE_USER@$INSTANCE_IP"
