#!/bin/bash

set -euo pipefail

# Colors
green=$(tput setaf 2)
yellow=$(tput setaf 3)
red=$(tput setaf 1)
blue=$(tput setaf 6)
reset=$(tput sgr0)

# Logging to file + output to terminal
LOGFILE="$HOME/update-$(date +%Y%m%d-%H%M%S).log"
exec > >(tee -a "$LOGFILE") 2>&1

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

echo "${blue}🔍 Starting system update...${reset}"

do_reboot=$(ask_yes_no "Reboot the system?")
do_refresh_mirrors=$(ask_yes_no "Refresh mirror list (pacman-mirrors -g)?")
do_refresh_keys=$(ask_yes_no "Refresh pacman keys?")

if [[ "$do_refresh_mirrors" =~ ^[yY]$ ]]; then
    echo "${blue}🔄 Refreshing pacman mirrors...${reset}"
    sudo pacman-mirrors -g
fi

if [[ "$do_refresh_keys" =~ ^[yY]$ ]]; then
    echo "${blue}🔐 Refreshing pacman keys...${reset}"
    sudo pacman-key --refresh-keys
    sudo pacman -Sy --noconfirm archlinux-keyring
fi

echo "${blue}🔧 [1/4] Updating system packages with pacman...${reset}"
sudo pacman -Syy --noconfirm
sudo pacman -Syu --noconfirm

echo "${blue}🧹 Cleaning pacman cache (keeping last 3 versions)...${reset}"
sudo paccache -r

echo "${blue}📦 [2/4] Updating Flatpak packages...${reset}"
if command -v flatpak &>/dev/null; then
    flatpak update -y
else
    echo "${yellow}⚠️ Flatpak not found, skipping...${reset}"
fi

echo "${blue}📦 [3/4] Updating AUR packages with yay...${reset}"
if command -v yay &>/dev/null; then
    yay -Syu --noconfirm
else
    echo "${yellow}⚠️ yay not found, skipping AUR updates.${reset}"
fi

echo "${blue}🧹 [4/4] Cleaning orphan packages...${reset}"
orphans=$(pacman -Qtdq 2>/dev/null || true)
if [[ -n "$orphans" ]]; then
    echo "${blue}Removing orphan packages...${reset}"
    sudo pacman -Rns $orphans
else
    echo "${green}✅ No orphans to remove.${reset}"
fi

echo "${green}🎉 All updates and cleanups completed successfully.${reset}"
echo "${green}📅 Finished at: $(date)${reset}"
echo "${green}🖥️ Kernel version: $(uname -r)${reset}"
echo "${green}📄 Log saved to: $LOGFILE${reset}"

if [[ "$do_reboot" =~ ^[yY]$ ]]; then
    echo "${yellow}Rebooting...${reset}"
    sudo reboot
fi
