#!/bin/bash

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

reboot_sys=$(ask_yes_no "Reboot system?")
create_user=$(ask_yes_no "Create a new user?")

# --- Install yay and flatpak ---
echo "--- Installing yay and flatpak ---"
sudo pacman -S --noconfirm \
    yay \
    flatpak 

# --- pacman ---
echo "--- Configuring pacman ---"
chmod +x update_pacman.sh
./update_pacman.sh

# --- pamac and aur ---
echo "--- Configuring pamac and aur ---"
chmod +x enable_aur.sh
./enable_aur.sh

# --- System update ---
echo "--- System update ---"
sudo pacman-mirrors -g
sudo pacman-key --refresh-keys
sudo pacman -Sy --noconfirm archlinux-keyring
sudo pacman -Syyuu --noconfirm

# --- Install base packages ---
echo "--- Installing base packages ---"
sudo pacman -S --noconfirm \
    plasma \
    kio-extras \
    kde-applications-meta \
    manjaro-kde-settings \
    sddm-breath-theme \
    manjaro-settings-manager \
    pacman-contrib \
    base-devel \
    libarchive \
    vim \
    fzf \
    tmux \
    tree \
    yakuake \
    neovim \
    chromium

# --- Enable display manager ---
sudo systemctl enable sddm.service --force

# --- Flathub ---
echo "--- Configuring Flathub ---"
flatpak remote-add --if-not-exists --system flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install --system -y flathub com.google.Chrome

echo "--- Installing programs ---"
chmod +x install_program.sh
./install_program.sh

sudo pacman -Rns --noconfirm kde-applications-meta kde-education-meta kde-games-meta
sudo pacman -Rns $(pacman -Qdtq)
sudo paccache -rk1

# --- Create user ---
if [[ "$create_user" =~ ^[yY]$ ]]; then
    chmod +x add_user.sh
    ./add_user.sh
else
    echo "Skipping user creation."
fi

echo "The installation is complete."

# --- Reboot ---
if [[ "$reboot_sys" =~ ^[yY]$ ]]; then
    echo "Rebooting in 10 seconds... Press Ctrl+C to cancel."
    sleep 10
    sudo systemctl reboot
fi
