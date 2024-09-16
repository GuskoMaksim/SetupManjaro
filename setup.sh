#!/bin/bash

# Проверка и настройка Git user.name
if [ "$(git config --global --get user.name)" != "Gusko Maksim" ]; then
    echo "Настраиваем имя пользователя Git..."
    git config --global user.name "Gusko Maksim"
else
    echo "Имя пользователя Git уже настроено."
fi &&

# Проверка и настройка Git user.email

if [ "$(git config --global --get user.email)" != "gusko.maksim.n@gmail.com" ]; then
    echo "Настраиваем email Git..."
    git config --global user.email "gusko.maksim.n@gmail.com"
else
    echo "Email пользователя Git уже настроен."
fi &&

# Проверка существования и создание SSH-ключей
if [ ! -f ~/.ssh/id_rsa ]; then
    echo "SSH-ключи не найдены, создаем новые..."
    ssh-keygen -o -t rsa -b 4096 -C "gusko.maksim.n@gmail.com" -N "" -f ~/.ssh/id_rsa
else
    echo "SSH-ключи уже существуют."
fi &&

# Проверка наличия и создание GPG-ключей
if ! gpg --list-keys | grep -q "gusko.maksim.n@gmail.com"; then
    echo "GPG-ключ не найден, создаем новый..."
    gpg --full-generate-key
else
    echo "GPG-ключ уже существует."
fi &&

# Обновление зеркал и установка пакетов
sudo pacman-mirrors -g &&
sudo pacman -Syyuu --noconfirm \
    yay \
    flatpak \
    yakuake \
    gvim \
    neovim \
    cmake \
    extra-cmake-modules \
    libarchive \
    qt5-base \
    qt5-declarative \
    qt5-tools \
    qt5-svg \
    qt6-base \
    qt6-declarative \
    qt6-tools \
    qt6-svg \
    plasma \
    kio-extras \
    kde-applications-meta \
    manjaro-kde-settings \
    sddm-breath-theme \
    manjaro-settings-manager &&

pamac install base-devel --no-confirm &&

# Включение службы sddm
sudo systemctl enable sddm.service --force &&

# Добавление Flathub репозитория
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo &&

# Скачивание программ
sudo pacman -S --noconfirm \
    chromium \
    keepassxc \
    doublecmd \
    telegram-desktop \
    steam &&
flatpak install -y flathub \
    com.opera.Opera \
    com.google.Chrome \
    com.visualstudio.code \
    com.jetbrains.PyCharm-Community \
    md.obsidian.Obsidian \
    com.protonvpn.www \
    org.zealdocs.Zeal \
    cc.arduino.IDE2 \
    com.sublimetext.three \
    com.unity.UnityHub \
    org.qbittorrent.qBittorrent\
    &&

chmod +x setup_zsh.sh &&
chmod +x setup_vim.sh &&
chmod +x add_yakuake_autostart.sh &&



# Перезагрузка системы
sudo systemctl reboot
