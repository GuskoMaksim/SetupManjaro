#!/bin/bash

set -e

CONF_FILE="/etc/pacman.conf"

echo "🔧 Configuring pacman..."

# Enable Color
if ! grep -q '^Color' "$CONF_FILE"; then
    echo "✅ Enabling Color"
    sudo sed -i '/#Color/s/^#//' "$CONF_FILE"
    grep -q '^Color' "$CONF_FILE" || sudo sed -i '/^\[options\]/a Color' "$CONF_FILE"
fi

# Enable ILoveCandy (after Color)
if ! grep -q '^ILoveCandy' "$CONF_FILE"; then
    echo "✅ Adding ILoveCandy"
    sudo sed -i '/^Color/a ILoveCandy' "$CONF_FILE"
fi

# Set or add ParallelDownloads = 8
if grep -q '^#*ParallelDownloads' "$CONF_FILE"; then
    echo "✅ Setting ParallelDownloads = 8"
    sudo sed -i 's/^#*ParallelDownloads.*/ParallelDownloads = 8/' "$CONF_FILE"
else
    echo "✅ Adding ParallelDownloads = 8 to [options] section"
    sudo sed -i '/^\[options\]/a ParallelDownloads = 8' "$CONF_FILE"
fi

echo "🎉 pacman.conf successfully improved!"
