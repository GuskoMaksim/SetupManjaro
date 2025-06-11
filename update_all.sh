#!/bin/bash

set -euo pipefail

echo "🔧 [1/4] Updating system packages with pacman..."
if ! command -v pacman &>/dev/null; then
    echo "❌ pacman not found. Are you sure you're on Arch/Manjaro?"
    exit 1
fi
sudo pacman -Syu --noconfirm

echo "🧹 Cleaning pacman cache (keeping last 3 versions)..."
sudo paccache -r

echo "📦 [2/4] Updating Flatpak packages..."
if command -v flatpak &>/dev/null; then
    flatpak update -y
else
    echo "⚠️ Flatpak not found, skipping..."
fi

echo "📦 [3/4] Updating AUR packages with yay..."
if command -v yay &>/dev/null; then
    yay -Syu --noconfirm
else
    echo "⚠️ yay not found, skipping AUR updates."
fi

echo "🧹 [4/4] Cleaning orphan packages..."
sudo pacman -Rns $(pacman -Qtdq 2>/dev/null || true) || echo "✅ No orphans to remove."

echo "🎉 All updates and cleanups completed successfully."
