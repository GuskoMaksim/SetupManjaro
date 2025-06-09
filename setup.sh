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

# --- Git setup ---
echo "--- Git setup ---"
if [ "$(git config --global --get user.name)" != "Gusko Maksim" ]; then
    echo "Setting Git user name..."
    git config --global user.name "Gusko Maksim"
else
    echo "Git user name is already set."
fi

if [ "$(git config --global --get user.email)" != "gusko.maksim.n@gmail.com" ]; then
    echo "Setting Git email..."
    git config --global user.email "gusko.maksim.n@gmail.com"
else
    echo "Git user email is already set."
fi

# --- SSH keys ---
echo "--- Checking SSH keys ---"
if [ ! -f ~/.ssh/id_rsa ]; then
    echo "Creating SSH key..."
    ssh-keygen -o -t rsa -b 4096 -C "gusko.maksim.n@gmail.com" -N "" -f ~/.ssh/id_rsa
else
    echo "SSH key already exists."
fi

# --- GPG key ---
echo "--- Checking GPG key ---"
if ! gpg --list-keys "gusko.maksim.n@gmail.com" &> /dev/null; then
    echo "Creating GPG key..."
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
    echo "GPG key created."
else
    echo "GPG key already exists."
fi

# --- Install yay and flatpak ---
echo "--- Installing yay and flatpak ---"
sudo pacman -S --noconfirm \
    yay \
    flatpak 

# --- pacman ---
echo "--- Configuring pacman ---"
chmod +x update-pacman.sh
./update-pacman.sh

# --- pamac and aur ---
echo "--- Configuring pamac and aur ---"
chmod +x enable-aur.sh
./enable-aur.sh

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

echo "--- Activating alias ---"
ZSHRC="$HOME/.zshrc"

# Add setopt aliases if not present
if ! grep -q 'setopt aliases' "$ZSHRC"; then
    echo "Adding 'setopt aliases' to ~/.zshrc"
    echo -e "\n# Enable alias support\nsetopt aliases" >> "$ZSHRC"
else
    echo "✅ setopt aliases is already set."
fi

echo "🔧 Adding alias 'updateSystem' to ~/.zshrc..."
if ! grep -q "alias updateSystem=" ~/.zshrc; then
    echo "alias updateSystem='bash ~/SetupManjaro/update-all.sh'" >> ~/.zshrc
    echo "✅ Alias 'updateSystem' added."
else
    echo "ℹ️ Alias 'updateSystem' already exists."
fi

# --- Flathub ---
echo "--- Configuring Flathub ---"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub com.google.Chrome

echo "--- Installing programs ---"
chmod +x install_program.sh
./install_program.sh

sudo pacman -Rns --noconfirm kde-applications-meta kde-education-meta kde-games-meta
sudo pacman -Rns $(pacman -Qdtq)
sudo paccache -rk1

# --- Create user GuskoWork ---
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
