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

setup_git=$(ask_yes_no "Настроить Git?")
setup_ssh=$(ask_yes_no "Создать SSH ключ?")
setup_gpg=$(ask_yes_no "Создать GPG ключ?")

# --- Git setup ---
if [[ "$setup_git" =~ ^[yY]$ ]]; then
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
fi

# --- SSH keys ---
if [[ "$setup_ssh" =~ ^[yY]$ ]]; then
    echo "--- Checking SSH keys ---"
    if [ ! -f ~/.ssh/id_rsa ]; then
        echo "Creating SSH key..."
        ssh-keygen -o -t rsa -b 4096 -C "gusko.maksim.n@gmail.com" -N "" -f ~/.ssh/id_rsa
    else
        echo "SSH key already exists."
    fi
fi

# --- GPG key ---
if [[ "$setup_gpg" =~ ^[yY]$ ]]; then
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
fi