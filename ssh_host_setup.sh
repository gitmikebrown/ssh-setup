#!/bin/bash
# Author: Michael Brown
# Description: Configures SSH access on the host machine using a transferred public key.

set -e  # Exit on error
set -u  # Treat unset variables as errors

echo "🔍 Checking for required tools..."

for cmd in ssh cat chmod mkdir; do
    if ! command -v $cmd &> /dev/null; then
        echo "❌ Required command '$cmd' not found. Please install it before proceeding."
        exit 1
    fi
done

echo "✅ All required tools are available."

KEY_DIR="$HOME/.ssh"
AUTHORIZED_KEYS="$KEY_DIR/authorized_keys"
TEMP_KEY="$HOME/temp_key.pub"

echo "🔐 Setting up authorized_keys..."

# Ensure .ssh directory exists with correct permissions
mkdir -p "$KEY_DIR"
chmod 700 "$KEY_DIR"

# Validate temp_key.pub exists
if [ ! -f "$TEMP_KEY" ]; then
    echo "❌ Public key file '$TEMP_KEY' not found. Make sure it was transferred correctly."
    exit 1
fi

# Create authorized_keys if it doesn't exist
touch "$AUTHORIZED_KEYS"
chmod 600 "$AUTHORIZED_KEYS"

# Append key safely
if grep -q -F "$(cat "$TEMP_KEY")" "$AUTHORIZED_KEYS"; then
    echo "⚠️ Key already exists in authorized_keys. Skipping append."
else
    cat "$TEMP_KEY" >> "$AUTHORIZED_KEYS"
    echo "✅ Public key added to authorized_keys."
fi

# Clean up
rm "$TEMP_KEY"
echo "🧹 Removed temporary key file."

echo "✅ SSH key installed. You can now connect from the client machine."