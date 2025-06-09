#!/bin/bash

set -e

# Function to validate username
function is_valid_username() {
    [[ "$1" =~ ^[a-z_][a-z0-9_-]{0,31}$ ]]
}

# Prompt for username
while true; do
    read -rp "Enter new username: " NEW_USER
    if is_valid_username "$NEW_USER"; then
        break
    else
        echo "❌ Invalid username. It must start with a letter or '_', contain only letters, digits, '-', '_', and be 1-32 characters long."
    fi
done

# Get current user
CURRENT_USER=$(logname)

echo "🧾 Current user: $CURRENT_USER"
echo "👤 Creating user: $NEW_USER"

# Check if user already exists
if id "$NEW_USER" &>/dev/null; then
    echo "⚠️ User $NEW_USER already exists."
    exit 1
fi

# Get current user's groups (space-separated)
USER_GROUPS=$(id -nG "$CURRENT_USER")

# Add docker group if not present
if ! echo "$USER_GROUPS" | grep -qw "docker"; then
    USER_GROUPS="$USER_GROUPS docker"
fi

# Convert spaces to commas for -G option
GROUPS_CSV=$(echo "$USER_GROUPS" | tr ' ' ',')

echo "Adding user $NEW_USER with groups: $GROUPS_CSV"

sudo useradd -m -G "$GROUPS_CSV" "$NEW_USER"

echo "🔐 Set password for $NEW_USER:"
sudo passwd "$NEW_USER"

echo "✅ User $NEW_USER created with groups: $GROUPS_CSV"
