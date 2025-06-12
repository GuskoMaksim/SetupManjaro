#!/bin/bash

set -e

LOGFILE="$HOME/setup_aur_pacman-$(date +%Y%m%d-%H%M%S).log"
exec > >(tee -a "$LOGFILE") 2>&1

# --- PACMAN CONFIGURATION ---
PACMAN_CONF="/etc/pacman.conf"

echo "🔧 Configuring pacman..."

# Enable Color
if ! grep -q '^Color' "$PACMAN_CONF"; then
    echo "✅ Enabling Color"
    sudo sed -i '/#Color/s/^#//' "$PACMAN_CONF"
    grep -q '^Color' "$PACMAN_CONF" || sudo sed -i '/^\[options\]/a Color' "$PACMAN_CONF"
fi

# Enable ILoveCandy (after Color)
if ! grep -q '^ILoveCandy' "$PACMAN_CONF"; then
    echo "✅ Adding ILoveCandy"
    sudo sed -i '/^Color/a ILoveCandy' "$PACMAN_CONF"
fi

# Set or add ParallelDownloads = 8
if grep -q '^#*ParallelDownloads' "$PACMAN_CONF"; then
    echo "✅ Setting ParallelDownloads = 8"
    sudo sed -i 's/^#*ParallelDownloads.*/ParallelDownloads = 8/' "$PACMAN_CONF"
else
    echo "✅ Adding ParallelDownloads = 8 to [options] section"
    sudo sed -i '/^\[options\]/a ParallelDownloads = 8' "$PACMAN_CONF"
fi

echo "🎉 pacman.conf successfully improved!"

# --- PAMAC & AUR CONFIGURATION ---
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

echo "🎉 Done: pacman + pamac + AUR enabled, yay installed"
