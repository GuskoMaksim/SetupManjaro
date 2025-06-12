#!/bin/bash
set -euo pipefail

LOGFILE="$HOME/install_program-$(date +%Y%m%d-%H%M%S).log"
exec > >(tee -a "$LOGFILE") 2>&1

echo "=== Starting setup script at $(date) ==="

append_alias() {
    local alias_line="$1"
    local file="$HOME/.zshrc"
    [[ -f "$file" ]] || touch "$file"
    grep -qxF "$alias_line" "$file" || echo "$alias_line" >> "$file"
}

ask_yes_no() {
    local prompt="$1"
    local var
    while true; do
        read -p "$prompt (y/n) " var
        if [[ "$var" =~ ^[yYnN]$ ]]; then
            echo "$var"
            echo "[USER INPUT] $prompt $var" >> "$LOGFILE"
            return
        fi
    done
}

# --- Ввод выбора пользователя ---
install_telegram=$(ask_yes_no "Install Telegram?")
install_surfshark=$(ask_yes_no "Install Surfshark VPN?")
install_add_pr=$(ask_yes_no "Install Additional Programs?")
install_visualstudio=$(ask_yes_no "Install Visual Studio Code?")
install_docker=$(ask_yes_no "Install Docker and Docker Compose?")
install_slack=$(ask_yes_no "Install Slack?")
install_cmake=$(ask_yes_no "Install CMake?")
install_steam=$(ask_yes_no "Install Steam?")
install_arduino_IDE=$(ask_yes_no "Install Arduino IDE?")
install_pycharm=$(ask_yes_no "Install PyCharm Community?")
install_unityhub=$(ask_yes_no "Install UnityHub?")
install_qt=$(ask_yes_no "Install Qt?")
install_wireshark=$(ask_yes_no "Install Wireshark and set up permissions?")
install_spotify=$(ask_yes_no "Install Spotify?")

# --- Telegram ---
if [[ "$install_telegram" =~ ^[yY]$ ]]; then
    echo ">>> Installing Telegram..."
    sudo pacman -S --needed --noconfirm telegram-desktop
    append_alias "alias telegram='nohup telegram-desktop & disown'"
    echo "==> ✅ Telegram installed"
fi

# --- Surfshark VPN ---
if [[ "$install_surfshark" =~ ^[yY]$ ]]; then
    echo ">>> Installing Surfshark VPN..."
    if command -v flatpak &>/dev/null; then
        flatpak install --system -y flathub com.surfshark.Surfshark
        append_alias "alias surfshark='nohup flatpak run com.surfshark.Surfshark & disown'"
        echo "==> ✅ Surfshark VPN installed"
    else
        echo "⚠️ Flatpak not found, skipping Surfshark VPN..."
    fi
fi

# --- Дополнительные программы ---
if [[ "$install_add_pr" =~ ^[yY]$ ]]; then
    echo ">>> Installing Additional Programs..."
    sudo pacman -S --needed --noconfirm doublecmd-qt6 \
            dolphin-plugins \
            btop \
            bat \
            ark \
            exa \
            vlc 
    echo "==> ✅ doublecmd-qt6 installed"

    if command -v flatpak &>/dev/null; then
        echo ">>> Installing Flatpak programs..."
        flatpak install --system -y flathub \
            com.opera.Opera \
            md.obsidian.Obsidian \
            com.protonvpn.www \
            org.zealdocs.Zeal \
            com.sublimetext.three \
            org.qbittorrent.qBittorrent

        flatpak update --system -y
        flatpak uninstall --unused -y

        append_alias "alias doublecmd='nohup doublecmd & disown'"
        append_alias "alias opera='nohup flatpak run com.opera.Opera & disown'"
        append_alias "alias obsidian='nohup flatpak run md.obsidian.Obsidian & disown'"
        append_alias "alias proton='nohup flatpak run com.protonvpn.www & disown'"
        append_alias "alias zeal='nohup flatpak run org.zealdocs.Zeal & disown'"
        append_alias "alias sublime='nohup flatpak run com.sublimetext.three & disown'"
        append_alias "alias bittorrent='nohup flatpak run org.qbittorrent.qBittorrent & disown'"
        echo "==> ✅ Flatpak apps installed and cleaned"
    else
        echo "⚠️ Flatpak not found, skipping Flatpak apps..."
    fi
fi

# --- Visual Studio Code ---
if [[ "$install_visualstudio" =~ ^[yY]$ ]]; then
    echo ">>> Installing Visual Studio Code..."
    if command -v yay &>/dev/null; then
        yay -S --needed --noconfirm visual-studio-code-bin
        append_alias "alias vs='code & disown'"
        echo "==> ✅ Visual Studio Code installed"
    else
        echo "❌ yay not found. Please install yay manually."
    fi
fi

# --- Docker ---
if [[ "$install_docker" =~ ^[yY]$ ]]; then
    echo ">>> Installing Docker and Docker Compose..."
    sudo pacman -S --needed --noconfirm docker docker-compose
    sudo systemctl enable --now docker
    sudo usermod -aG docker "$USER"
    echo "==> ✅ Docker installed"
fi

# --- Slack ---
if [[ "$install_slack" =~ ^[yY]$ ]]; then
    echo ">>> Installing Slack..."
    if command -v yay &>/dev/null; then
        yay -S --needed --noconfirm slack-desktop
        append_alias "alias slack='slack-desktop & disown'"
        echo "==> ✅ Slack installed"
    else
        echo "❌ yay not found. Please install yay manually."
    fi
fi

# --- CMake ---
if [[ "$install_cmake" =~ ^[yY]$ ]]; then
    echo ">>> Installing CMake..."
    sudo pacman -S --needed --noconfirm cmake extra-cmake-modules
    echo "==> ✅ CMake installed"
fi

# --- Steam ---
if [[ "$install_steam" =~ ^[yY]$ ]]; then
    echo ">>> Installing Steam..."
    sudo pacman -S --needed --noconfirm steam
    append_alias "alias steam='nohup steam & disown'"
    echo "==> ✅ Steam installed"
fi

# --- Arduino IDE ---
if [[ "$install_arduino_IDE" =~ ^[yY]$ ]]; then
    echo ">>> Installing Arduino IDE..."
    if command -v flatpak &>/dev/null; then
        flatpak install --system -y flathub cc.arduino.IDE2
        append_alias "alias arduino='nohup flatpak run cc.arduino.IDE2 & disown'"
        echo "==> ✅ Arduino IDE installed"
    else
        echo "⚠️ Flatpak not found, skipping Arduino IDE..."
    fi
fi

# --- PyCharm ---
if [[ "$install_pycharm" =~ ^[yY]$ ]]; then
    echo ">>> Installing PyCharm Community..."
    if command -v flatpak &>/dev/null; then
        flatpak install --system -y flathub com.jetbrains.PyCharm-Community
        append_alias "alias pycharm='nohup flatpak run com.jetbrains.PyCharm-Community & disown'"
        echo "==> ✅ PyCharm installed"
    else
        echo "⚠️ Flatpak not found, skipping PyCharm..."
    fi
fi

# --- Unity Hub ---
if [[ "$install_unityhub" =~ ^[yY]$ ]]; then
    echo ">>> Installing Unity Hub..."
    if command -v flatpak &>/dev/null; then
        flatpak install --system -y flathub com.unity.UnityHub
        append_alias "alias unity='nohup flatpak run com.unity.UnityHub & disown'"
        echo "==> ✅ Unity Hub installed"
    else
        echo "⚠️ Flatpak not found, skipping Unity Hub..."
    fi
fi

# --- Qt ---
if [[ "$install_qt" =~ ^[yY]$ ]]; then
    echo ">>> Installing Qt (5 & 6)..."
    sudo pacman -S --needed --noconfirm \
        qt5-base qt5-declarative qt5-tools qt5-svg \
        qt6-base qt6-declarative qt6-tools qt6-svg
    echo "==> ✅ Qt installed"
fi

# --- Wireshark install prompt and logic ---
if [[ "$install_wireshark" =~ ^[yY]$ ]]; then
    echo "$🌐 Installing Wireshark..."
    sudo pacman -S --needed --noconfirm wireshark-qt
    sudo gpasswd -a "$USER" wireshark
    if ! sudo wireshark-cli --privileged-install; then
        echo "⚠️ Fallback to manual permission setup"
        sudo chgrp wireshark /usr/bin/dumpcap
        sudo chmod 750 /usr/bin/dumpcap
        sudo setcap cap_net_raw,cap_net_admin=eip /usr/bin/dumpcap
    fi
    echo "✅ Wireshark installed. Please relog to apply group permissions."
fi

# --- Spotify ---
if [[ "$install_spotify" =~ ^[yY]$ ]]; then
    echo ">>> Installing Spotify..."
    if command -v yay &>/dev/null; then
        yay -S --needed --noconfirm spotify-launcher
        append_alias "alias spotify='spotify-launcher & disown'"
        echo "==> ✅ Spotify installed"
    else
        echo "❌ yay not found. Please install yay manually."
    fi
fi

# --- Result ---
echo
echo "✅ All selected applications installed."
echo "📋 Summary of installations:"
echo "- Telegram: $install_telegram"
echo "- Surfshark VPN: $install_surfshark"
echo "- Additional Programs: $install_add_pr"
echo "- Visual Studio Code: $install_visualstudio"
echo "- Docker & Compose: $install_docker"
echo "- Slack: $install_slack"
echo "- CMake: $install_cmake"
echo "- Steam: $install_steam"
echo "- Arduino IDE: $install_arduino_IDE"
echo "- PyCharm Community: $install_pycharm"
echo "- UnityHub: $install_unityhub"
echo "- Qt: $install_qt"
echo "- Spotify: $install_spotify"
echo "=== Script finished at $(date) ==="
