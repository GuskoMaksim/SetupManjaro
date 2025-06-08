#!/bin/bash

set -e

CONF_FILE="/etc/pacman.conf"

echo "🔧 Настраиваем pacman..."

# Включаем Color
if ! grep -q '^Color' "$CONF_FILE"; then
    echo "✅ Включаем Color"
    sudo sed -i '/#Color/s/^#//' "$CONF_FILE"
    grep -q '^Color' "$CONF_FILE" || echo "Color" | sudo tee -a "$CONF_FILE"
fi

# Включаем ILoveCandy (после Color)
if ! grep -q '^ILoveCandy' "$CONF_FILE"; then
    echo "✅ Добавляем ILoveCandy"
    sudo sed -i '/^Color/a ILoveCandy' "$CONF_FILE"
fi

# Устанавливаем ParallelDownloads = 8
if grep -q '^#*ParallelDownloads' "$CONF_FILE"; then
    echo "✅ Устанавливаем ParallelDownloads = 8"
    sudo sed -i 's/^#*ParallelDownloads.*/ParallelDownloads = 8/' "$CONF_FILE"
else
    echo "✅ Добавляем ParallelDownloads = 8"
    echo "ParallelDownloads = 8" | sudo tee -a "$CONF_FILE"
fi

echo "🎉 pacman.conf успешно улучшен!"
