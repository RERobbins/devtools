#!/bin/bash

# Set default values for HOST_UID and HOST_GID
DEFAULT_UID=1000
DEFAULT_GID=100

# Read HOST_UID and HOST_GID from environment with defaults
HOST_UID=${HOST_UID:-$DEFAULT_UID}
#HOST_GID=${HOST_GID:-$DEFAULT_GID}

# Get current jovyan UID and users GID
CURRENT_UID=$(id -u jovyan)
# CURRENT_GID=$(id -g jovyan)

# Update jovyan's UID, if different from HOST_UID
if [ "$HOST_UID" != "$CURRENT_UID" ]; then
    usermod -u $HOST_UID jovyan
    # Update ownership in jovyan's home directory
    chown $HOST_UID /home/jovyan
fi

# Update users GID, if different from HOST_GID
#if [ "$HOST_GID" != "$CURRENT_GID" ]; then
#    groupmod -g $HOST_GID users
    # Update group ownership in jovyan's home directory
#    chown :$HOST_GID /home/jovyan
#fi

# Ensure jovyan is a member of the 'users' group
#usermod -aG users jovyan
