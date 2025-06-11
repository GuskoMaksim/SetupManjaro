#!/bin/bash

set -e

echo "🔧 Checking if pamac is installed..."
if ! command -v pamac &>/dev/null; then
    echo "❌ pamac not found. Make sure you are on Manjaro or install pamac manually."
    exit 1
fi

PAMAC_CONF="/etc/pamac.conf"

echo "🔧 Enabling AUR support in pamac..."

sudo sed -i 's/^#EnableAUR/EnableAUR/' "$PAMAC_CONF"
sudo sed -i 's/^#KeepBuiltPkgs/KeepBuiltPkgs/' "$PAMAC_CONF"
sudo sed -i 's/^#CheckAURUpdates/CheckAURUpdates/' "$PAMAC_CONF"
sudo sed -i 's/^#CheckAURVCSUpdates/CheckAURVCSUpdates/' "$PAMAC_CONF"

# Add missing lines if necessary
grep -q '^EnableAUR' "$PAMAC_CONF" || echo "EnableAUR = true" | sudo tee -a "$PAMAC_CONF"
grep -q '^KeepBuiltPkgs' "$PAMAC_CONF" || echo "KeepBuiltPkgs = true" | sudo tee -a "$PAMAC_CONF"
grep -q '^CheckAURUpdates' "$PAMAC_CONF" || echo "CheckAURUpdates = true" | sudo tee -a "$PAMAC_CONF"
grep -q '^CheckAURVCSUpdates' "$PAMAC_CONF" || echo "CheckAURVCSUpdates = true" | sudo tee -a "$PAMAC_CONF"

echo "✅ AUR in pamac is enabled"

echo "🔧 Installing yay (if not installed)..."
if ! command -v yay &>/dev/null; then
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    pushd /tmp/yay
    makepkg -si --noconfirm
    popd
    rm -rf /tmp/yay
    echo "✅ yay installed"
else
    echo "✅ yay is already installed"
fi

echo "🎉 Done: pamac + AUR enabled, MaxParallelDownloads = 8, yay installed"
