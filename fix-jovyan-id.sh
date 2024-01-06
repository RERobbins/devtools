#!/bin/bash
set -e

# Get the HOST_UID and HOST_GID environment variables (if set)
HOST_UID=${HOST_UID:-1000}
HOST_GID=${HOST_GID:-100}

# Map the host user's UID to match the jovyan user inside the container
if [ "$HOST_UID" != "1000" ]; then
    usermod -u $HOST_UID jovyan
fi

# If HOST_GID is not 100, then proceed to check or create group
if [ "$HOST_GID" != "100" ]; then
    # Check if group with HOST_GID already exists
    if ! getent group $HOST_GID > /dev/null; then
        # Group doesn't exist, so create it as 'jovyan_group'
        groupadd -g $HOST_GID jovyan_group
        # Add jovyan user to the newly created group and make it the primary group
        usermod -g $HOST_GID -G $HOST_GID jovyan
    else
        # Group exists, retrieve its name
        EXISTING_GROUP_NAME=$(getent group $HOST_GID | cut -d: -f1)
        # Add jovyan user to the existing group and make it the primary group
        usermod -g $HOST_GID -G $EXISTING_GROUP_NAME jovyan
    fi
fi

# Change ownership of /home/jovyan to the newly mapped UID and primary GID
chown jovyan:$HOST_GID /home/jovyan
