ask_yes_no() {
    local prompt="$1"
    local var
    while true; do
        read -p "$prompt (y/n) " var
        if [[ "$var" =~ ^[yYnN]$ ]]; then
            echo "$var"
            return
        fi
    done
}

install_telegram=$(ask_yes_no "Install Telegram?")
install_add_pr=$(ask_yes_no "Install Additional Programs?")
install_steam=$(ask_yes_no "Install Steam?")
install_arduino_IDE=$(ask_yes_no "Install Arduino IDE?")
install_visualstudio=$(ask_yes_no "Install Visual Studio?")
install_pycharm=$(ask_yes_no "Install PyCharm Community?")
install_unityhub=$(ask_yes_no "Install UnityHub?")
install_qt=$(ask_yes_no "Install Qt?")
install_cmake=$(ask_yes_no "Install CMake?")
install_docker=$(ask_yes_no "Install Docker and Docker Compose?")

# --- Installation by choice ---
if [[ "$install_cmake" =~ ^[yY]$ ]]; then
    echo "--- Installing CMake ---"
    sudo pacman -S --noconfirm cmake extra-cmake-modules
fi

if [[ "$install_qt" =~ ^[yY]$ ]]; then
    echo "--- Installing Qt ---"
    sudo pacman -S --noconfirm \
        qt5-base \
        qt5-declarative \
        qt5-tools \
        qt5-svg \
        qt6-base \
        qt6-declarative \
        qt6-tools \
        qt6-svg
fi

if [[ "$install_add_pr" =~ ^[yY]$ ]]; then
    echo "--- Installing additional programs ---"
    sudo pacman -S --noconfirm doublecmd

    flatpak install --system -y flathub \
        com.opera.Opera \
        md.obsidian.Obsidian \
        com.protonvpn.www \
        org.zealdocs.Zeal \
        com.sublimetext.three \
        org.qbittorrent.qBittorrent

    cat <<EOF >> ~/.zshrc
alias doublecmd='nohup doublecmd &'
alias opera='nohup flatpak run com.opera.Opera &'
alias obsidian='nohup flatpak run md.obsidian.Obsidian &'
alias proton='nohup flatpak run com.protonvpn.www &'
alias zeal='nohup flatpak run org.zealdocs.Zeal &'
alias sublime='nohup flatpak run com.sublimetext.three &'
alias bittorrent='nohup flatpak run org.qbittorrent.qBittorrent &'
EOF

fi

if [[ "$install_steam" =~ ^[yY]$ ]]; then
    echo "--- Installing Steam ---"
    sudo pacman -S --noconfirm steam
    echo "alias steam='nohup steam &'" >> ~/.zshrc
fi

if [[ "$install_pycharm" =~ ^[yY]$ ]]; then
    echo "--- Installing PyCharm Community ---"
    flatpak install --system -y flathub com.jetbrains.PyCharm-Community
    echo "alias pycharm='nohup flatpak run com.jetbrains.PyCharm-Community &'" >> ~/.zshrc
fi

if [[ "$install_unityhub" =~ ^[yY]$ ]]; then
    echo "--- Installing UnityHub ---"
    flatpak install --system -y flathub com.unity.UnityHub
    echo "alias unity='nohup flatpak run com.unity.UnityHub &'" >> ~/.zshrc
fi

if [[ "$install_arduino_IDE" =~ ^[yY]$ ]]; then
    echo "--- Installing Arduino IDE ---"
    flatpak install --system -y flathub cc.arduino.IDE2
    echo "alias arduino='nohup flatpak run cc.arduino.IDE2 &'" >> ~/.zshrc
fi

if [[ "$install_telegram" =~ ^[yY]$ ]]; then
    echo "--- Installing Telegram ---"
    sudo pacman -S --noconfirm telegram-desktop
    echo "alias telegram='nohup telegram-desktop &'" >> ~/.zshrc
fi

if [[ "$install_visualstudio" =~ ^[yY]$ ]]; then
    echo "--- Installing Visual Studio ---"
    yay -S visual-studio-code-bin --noconfirm
    echo "alias vs='code &'" >> ~/.zshrc
fi

if [[ "$install_docker" =~ ^[yY]$ ]]; then
    echo "--- Installing Docker and Docker Compose ---"
    sudo pacman -S --noconfirm docker
    sudo pacman -S --noconfirm docker-compose
    sudo systemctl enable --now docker
    sudo usermod -aG docker $USER
fi
