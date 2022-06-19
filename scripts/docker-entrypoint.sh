#!/bin/sh
set -e

# Copy all ssh keys to the home directory
cp -R /tmp/.ssh /root/.ssh

# Ensure we have proper line breaks and line endings
find /root/.ssh/ -type f -name "*" -exec dos2unix -q {} +

# Set the required permissions for ssh key files
chmod 700 /root/.ssh
find /root/.ssh/ -type f -name "id_*" -exec chmod 600 {} +
find /root/.ssh/ -type f -name "id_*.pub" -exec chmod 644 {} +

# Start the ssh agent
eval "$(ssh-agent)"

exec "$@"
