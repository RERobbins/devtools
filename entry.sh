#!/bin/bash
set -e

# Get the HOST_UID and HOST_GID environment variables (if set)
HOST_UID=${HOST_UID:-1000}
HOST_GID=${HOST_GID:-100}

# Map the host user's UID and GID to match the jovyan user inside the container
if [ "$HOST_UID" != "1000" ]; then
    usermod -u $HOST_UID jovyan
fi

if [ "$HOST_GID" != "100" ]; then
    groupmod -g $HOST_GID jovyan
fi

# Change ownership of /home/jovyan to the newly mapped UID and GID
chown -R jovyan:jovyan /home/jovyan

# Run start-notebook.py with the specified options
su jovyan -c "start-notebook.py --NotebookApp.token='' --no-browser --ip=0.0.0.0"

exec "$@"
