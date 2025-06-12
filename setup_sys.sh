#!/bin/bash
set -euo pipefail

# Цвета
green=$(tput setaf 2)
yellow=$(tput setaf 3)
red=$(tput setaf 1)
blue=$(tput setaf 6)
reset=$(tput sgr0)

LOGFILE="$HOME/setup_sys-$(date +%Y%m%d-%H%M%S).log"
exec > >(tee -a "$LOGFILE") 2>&1

# --- Функции ---
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

# --- Ввод ---
reboot_sys=$(ask_yes_no "Reboot system?")
create_user=$(ask_yes_no "Create a new user?")

# --- Установка yay и flatpak ---
echo "${blue}--- Installing yay and flatpak ---${reset}"
if ! command -v yay &>/dev/null; then
    sudo pacman -S --noconfirm yay
else
    echo "${green}✅ yay already installed${reset}"
fi

if ! command -v flatpak &>/dev/null; then
    sudo pacman -S --noconfirm flatpak
else
    echo "${green}✅ flatpak already installed${reset}"
fi

# --- Настройка pacman/pamac/aur ---
echo "${blue}--- Configuring Pacman, Pamac and AUR ---${reset}"
if [[ -f setup_aur_pacman.sh ]]; then
    chmod +x setup_aur_pacman.sh
    ./setup_aur_pacman.sh
else
    echo "${yellow}⚠️ setup_aur_pacman.sh not found. Skipping...${reset}"
fi

# --- Обновление системы ---
echo "${blue}--- System update ---${reset}"
sudo pacman-mirrors -g
sudo pacman-key --refresh-keys
sudo pacman -Sy --noconfirm archlinux-keyring
sudo pacman -Syyuu --noconfirm

# --- Установка базовых пакетов ---
echo "${blue}--- Installing base packages ---${reset}"
sudo pacman -S --noconfirm \
    plasma \
    kio-extras \
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

# --- Включение дисплей-менеджера ---
echo "${blue}--- Enabling SDDM ---${reset}"
sudo systemctl enable sddm.service --force

# --- Flathub and Flatpak setup ---
echo "${blue}--- Configuring Flathub ---${reset}"
flatpak remote-add --if-not-exists --system flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install --system -y flathub com.google.Chrome

# --- Installing additional programs ---
echo "${blue}--- Installing additional programs ---${reset}"
if [[ -f install_program.sh ]]; then
    chmod +x install_program.sh
    ./install_program.sh
else
    echo "${yellow}⚠️ install_program.sh not found. Skipping...${reset}"
fi

# --- Removing unnecessary KDE meta-packages ---
echo "${blue}--- Removing KDE meta-packages ---${reset}"
sudo pacman -Rns --noconfirm kde-applications-meta kde-education-meta kde-games-meta || true

# --- System cleanup ---
echo "${blue}--- Cleaning system ---${reset}"
orphans=$(pacman -Qdtq 2>/dev/null || true)
if [[ -n "$orphans" ]]; then
    sudo pacman -Rns --noconfirm $orphans
else
    echo "${green}✅ No orphan packages to remove.${reset}"
fi

sudo paccache -rk1

# --- User creation ---
if [[ "$create_user" =~ ^[yY]$ ]]; then
    if [[ -f add_user.sh ]]; then
        chmod +x add_user.sh
        ./add_user.sh
    else
        echo "${yellow}⚠️ add_user.sh not found. Skipping user creation.${reset}"
    fi
else
    echo "${green}✅ Skipping user creation.${reset}"
fi

# --- Finish ---
echo "${green}🎉 The installation is complete.${reset}"

echo ">>> Configuring keyboard layout: us + ru with Meta+Space toggle"
localectl set-x11-keymap us,ru pc105 , grp:win_space_toggle

# --- Reboot ---
if [[ "$reboot_sys" =~ ^[yY]$ ]]; then
    echo "${blue}Rebooting in 10 seconds... Press Ctrl+C to cancel.${reset}"
    sleep 10
    sudo systemctl reboot
fi
