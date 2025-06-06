#!/bin/bash

# --- Спрашиваем пользователя, что устанавливать ---

read -p "Reboot system? (y/n) " reboot_sys

# --- Настройка Git ---
echo "--- Настройка Git ---"
if [ "$(git config --global --get user.name)" != "Gusko Maksim" ]; then
    echo "Настраиваем имя пользователя Git..."
    git config --global user.name "Gusko Maksim"
else
    echo "Имя пользователя Git уже настроено."
fi

if [ "$(git config --global --get user.email)" != "gusko.maksim.n@gmail.com" ]; then
    echo "Настраиваем email Git..."
    git config --global user.email "gusko.maksim.n@gmail.com"
else
    echo "Email пользователя Git уже настроен."
fi

# --- SSH-ключи ---
echo "--- Проверка SSH-ключей ---"
if [ ! -f ~/.ssh/id_rsa ]; then
    echo "Создаем SSH-ключ..."
    ssh-keygen -o -t rsa -b 4096 -C "gusko.maksim.n@gmail.com" -N "" -f ~/.ssh/id_rsa
else
    echo "SSH-ключ уже существует."
fi

# --- GPG-ключ ---
echo "--- Проверка GPG-ключа ---"
if ! gpg --list-keys "gusko.maksim.n@gmail.com" &> /dev/null; then
    echo "Создаем GPG-ключ..."
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
    echo "GPG-ключ создан."
else
    echo "GPG-ключ уже существует."
fi

# --- Обновление системы ---
echo "--- Обновление системы ---"
sudo pacman-mirrors -g
sudo pacman-key --refresh-keys
sudo pacman -Sy --noconfirm archlinux-keyring
sudo pacman -Syyuu --noconfirm

# --- Установка базовых пакетов ---
echo "--- Установка базовых пакетов ---"
sudo pacman -S --noconfirm \
    plasma \
    kio-extras \
    kde-applications-meta \
    manjaro-kde-settings \
    sddm-breath-theme \
    manjaro-settings-manager \
    base-devel \
    libarchive \
    pacman-contrib \
    vim \
    fzf \
    tmux \
    tree \
    yay \
    flatpak \
    yakuake \
    neovim \
    chromium

# --- Включение дисплей-менеджера ---
sudo systemctl enable sddm.service --force

# --- Flathub ---
echo "--- Настройка Flathub ---"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub com.google.Chrome

chmod +x install_program.sh
./install_program.sh

sudo pacman -Rns --noconfirm kde-applications-meta kde-education-meta kde-games-meta
sudo pacman -Rns $(pacman -Qdtq)
sudo paccache -rk1

echo "Установка завершена"

# --- Перезагрузка ---
if [[ "$reboot_sys" =~ ^[yY]$ ]]; then
    echo "Перезагрузка через 10 секунд... Нажмите Ctrl+C для отмены."
    sleep 10
    sudo systemctl reboot
fi
