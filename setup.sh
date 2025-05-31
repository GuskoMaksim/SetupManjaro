#!/bin/bash

# --- Настройка Git user.name ---
if [ "$(git config --global --get user.name)" != "Gusko Maksim" ]; then
    echo "Настраиваем имя пользователя Git..."
    git config --global user.name "Gusko Maksim"
else
    echo "Имя пользователя Git уже настроено."
fi

# --- Настройка Git user.email ---
if [ "$(git config --global --get user.email)" != "gusko.maksim.n@gmail.com" ]; then
    echo "Настраиваем email Git..."
    git config --global user.email "gusko.maksim.n@gmail.com"
else
    echo "Email пользователя Git уже настроен."
fi

# --- Проверка и создание SSH-ключей ---
if [ ! -f ~/.ssh/id_rsa ]; then
    echo "SSH-ключи не найдены, создаем новые..."
    ssh-keygen -o -t rsa -b 4096 -C "gusko.maksim.n@gmail.com" -N "" -f ~/.ssh/id_rsa
else
    echo "SSH-ключи уже существуют."
fi

# --- Проверка и создание GPG-ключей ---
if ! gpg --list-keys "gusko.maksim.n@gmail.com" &> /dev/null; then
    echo "GPG-ключ не найден, создаем новый..."

    cat <<EOF > gpg-key.conf
%no-protection
Key-Type: 1
Key-Length: 4096
Subkey-Type: 1
Subkey-Length: 4096
Name-Real: Maksim Gusko
Name-Email: gusko.maksim.n@gmail.com
Expire-Date: 0
EOF

    gpg --batch --generate-key gpg-key.conf
    rm -f gpg-key.conf

    echo "GPG-ключ успешно создан."
else
    echo "GPG-ключ уже существует."
fi

# --- Обновление зеркал и ключей ---
sudo pacman-mirrors -g
sudo pacman-key --refresh-keys
sudo pacman -Sy --noconfirm archlinux-keyring
sudo pacman -Syyuu --noconfirm

# --- Установка пакетов через pacman ---
sudo pacman -S --noconfirm \
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
    manjaro-settings-manager \
    base-devel \
    chromium \
    keepassxc \
    doublecmd \
    telegram-desktop \
    steam

# --- Включение службы sddm ---
sudo systemctl enable sddm.service --force

# --- Добавление Flathub репозитория ---
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# --- Установка flatpak-пакетов ---
flatpak install -y flathub \
    com.google.Chrome \
    com.opera.Opera \
    com.visualstudio.code \
    com.jetbrains.PyCharm-Community \
    md.obsidian.Obsidian \
    com.protonvpn.www \
    org.zealdocs.Zeal \
    cc.arduino.IDE2 \
    com.sublimetext.three \
    com.unity.UnityHub \
    org.qbittorrent.qBittorrent

# --- Установка прав на локальные скрипты ---
chmod +x setup_zsh.sh
chmod +x setup_vim.sh
chmod +x add_yakuake_autostart.sh

# --- Перезагрузка системы ---
echo "Перезагрузка системы через 10 секунд... Нажмите Ctrl+C для отмены."
sleep 10
sudo systemctl reboot
