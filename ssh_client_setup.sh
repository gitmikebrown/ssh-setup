#!/bin/bash
# Author: Michael Brown
# Description: Sets up SSH key-based authentication from the client side.

set -e  # Exit on error
set -u  # Treat unset variables as errors

echo "🔍 Checking for required tools..."

for cmd in ssh ssh-keygen scp; do
    if ! command -v $cmd &> /dev/null; then
        echo "❌ Required command '$cmd' not found. Please install OpenSSH tools."
        exit 1
    fi
done

echo "✅ All required tools are available."

# Define key paths
KEY_DIR="$HOME/.ssh"
PRIVATE_KEY="$KEY_DIR/id_rsa"
PUBLIC_KEY="$KEY_DIR/id_rsa.pub"

echo "🔑 Preparing SSH key..."

# Ensure .ssh directory exists with correct permissions
mkdir -p "$KEY_DIR"
chmod 700 "$KEY_DIR"

# Generate key only if it doesn't exist
if [ -f "$PRIVATE_KEY" ]; then
    echo "⚠️ SSH key already exists at $PRIVATE_KEY. Skipping generation."
else
    ssh-keygen -t rsa -b 4096 -f "$PRIVATE_KEY" -N ""
    echo "✅ SSH key generated."
fi

# Confirm public key exists
if [ ! -f "$PUBLIC_KEY" ]; then
    echo "❌ Public key not found at $PUBLIC_KEY. Something went wrong."
    exit 1
fi

echo "📤 Transferring public key to remote host..."

# Prompt for remote info
read -rp "Enter remote username: " remote_user
read -rp "Enter remote host IP or domain: " remote_host

# Test SSH connectivity before transfer
if ! ping -c 1 "$remote_host" &> /dev/null; then
    echo "❌ Cannot reach $remote_host. Check network or hostname."
    exit 1
fi

# Transfer public key
scp "$PUBLIC_KEY" "$remote_user@$remote_host:~/temp_key.pub" || {
    echo "❌ Failed to transfer public key. Check credentials or SSH access."
    exit 1
}

echo "✅ Public key transferred to $remote_host as temp_key.pub"
echo "➡️ Now run ssh_host_setup.sh on the remote host to complete setup."