read -p "Install Telegram? (y/n) " install_telegram
read -p "Install Additional Programs? (y/n) " install_add_pr
read -p "Install Steam? (y/n) " install_steam
read -p "Install arduino IDE? (y/n) " install_arduino_IDE
read -p "Install Visual Studio? (y/n) " install_visualstudio
read -p "Install PyCharm Community? (y/n) " install_pycharm
read -p "Install UnityHub? (y/n) " install_unityhub
read -p "Install Qt? (y/n) " install_qt
read -p "Install CMake? (y/n) " install_cmake


# --- Установка по выбору ---
if [[ "$install_cmake" =~ ^[yY]$ ]]; then
    echo "--- Установка CMake ---"
    sudo pacman -S --noconfirm cmake \
    extra-cmake-modules
fi

if [[ "$install_qt" =~ ^[yY]$ ]]; then
    echo "--- Установка Qt ---"
    sudo pacman -S --noconfirm \
        cmake \
        extra-cmake-modules \
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
    echo "--- Установка дополнительных программ ---"
    sudo pacman -S --noconfirm doublecmd

    flatpak install -y flathub \
        com.opera.Opera \
        md.obsidian.Obsidian \
        com.protonvpn.www \
        org.zealdocs.Zeal \
        com.sublimetext.three \
        org.qbittorrent.qBittorrent

    cat <<EOF >> ~/.zshrc
alias doublecmd='nohup doublecmd &'
alias opera='nohup com.opera.Opera &'
alias obsidian='nohup md.obsidian.Obsidian &'
alias proton='nohup com.protonvpn.www &'
alias zeal='nohup org.zealdocs.Zeal &'
alias sublime='nohup com.sublimetext.three &'
alias bittorrent='nohup org.qbittorrent.qBittorrent &'
EOF

fi

if [[ "$install_steam" =~ ^[yY]$ ]]; then
    echo "--- Установка Steam ---"
    sudo pacman -S --noconfirm steam
    echo "alias steam='nohup steam &'" >> ~/.zshrc
fi

if [[ "$install_pycharm" =~ ^[yY]$ ]]; then
    echo "--- Установка PyCharm Community ---"
    flatpak install -y flathub com.jetbrains.PyCharm-Community
    echo "alias pycharm='nohup com.jetbrains.PyCharm-Community &'" >> ~/.zshrc
fi

if [[ "$install_unityhub" =~ ^[yY]$ ]]; then
    echo "--- Установка UnityHub ---"
    flatpak install -y flathub com.unity.UnityHub
    echo "alias unity='nohup com.unity.UnityHub &'" >> ~/.zshrc
fi

if [[ "$install_arduino_IDE" =~ ^[yY]$ ]]; then
    echo "--- Установка Arduino IDE ---"
    flatpak install -y flathub cc.arduino.IDE2
    echo "alias arduino='nohup cc.arduino.IDE2 &'" >> ~/.zshrc
fi


if [[ "$install_telegram" =~ ^[yY]$ ]]; then
    echo "--- Установка Telegram ---"
    sudo pacman -S --noconfirm telegram-desktop
    echo "alias telegram='nohup telegram-desktop &'" >> ~/.zshrc
fi

if [[ "$install_visualstudio" =~ ^[yY]$ ]]; then
    echo "--- Установка Visual Studio ---"
    flatpak install -y flathub com.visualstudio.code
    echo "alias vs='nohup com.visualstudio.code &'" >> ~/.zshrc
fi
