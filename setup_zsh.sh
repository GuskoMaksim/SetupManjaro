#!/bin/bash

# Install dotfiles manager and MesloLGSNF font
sudo bash -c "$(curl -LSs https://github.com/dfmgr/installer/raw/main/install.sh)"
sudo fontmgr install MesloLGSNF

# Clone themes and plugins for Oh My Zsh

# Powerlevel10k theme
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    echo "Cloning powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
else
    echo "powerlevel10k is already installed."
fi

# zsh-autosuggestions plugin
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    echo "Cloning zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
else
    echo "zsh-autosuggestions is already installed."
fi

# zsh-syntax-highlighting plugin
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    echo "Cloning zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
else
    echo "zsh-syntax-highlighting is already installed."
fi

# fzf-tab plugin
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fzf-tab" ]; then
    echo "Cloning fzf-tab..."
    git clone https://github.com/Aloxaf/fzf-tab "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fzf-tab"
else
    echo "fzf-tab is already installed."
fi

# you-should-use plugin
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/you-should-use" ]; then
    echo "Cloning you-should-use..."
    git clone https://github.com/MichaelAquilina/zsh-you-should-use.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/you-should-use"
else
    echo "you-should-use is already installed."
fi

# Script to change ZSH theme to powerlevel10k
cat > change_zsh_theme.sh <<'EOF'
#!/bin/bash
ZSHRC_FILE="$HOME/.zshrc"
if [ -f "$ZSHRC_FILE" ]; then
    sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' "$ZSHRC_FILE"
    echo "ZSH theme changed to powerlevel10k!"
else
    echo ".zshrc file not found!"
fi
EOF

# Script to update ZSH plugins list and add highlighters
cat > update_zsh_plugins.sh <<'EOF'
#!/bin/bash
ZSHRC_FILE="$HOME/.zshrc"
if [ -f "$ZSHRC_FILE" ]; then
    sed -i '/plugins=(git)/c\plugins=(\n  git\n  zsh-autosuggestions\n  zsh-syntax-highlighting\n  web-search\n  dirhistory\n  history\n  fzf-tab\n  z\n  you-should-use\n)' "$ZSHRC_FILE"
    if ! grep -q "ZSH_HIGHLIGHT_HIGHLIGHTERS" "$ZSHRC_FILE"; then
        echo 'ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor root)' >> "$ZSHRC_FILE"
        echo "ZSH_HIGHLIGHT_HIGHLIGHTERS added!"
    else
        echo "ZSH_HIGHLIGHT_HIGHLIGHTERS already present!"
    fi
    echo "ZSH plugins updated!"
else
    echo ".zshrc file not found!"
fi
EOF

# Make scripts executable and run them
chmod +x change_zsh_theme.sh update_zsh_plugins.sh
./update_zsh_plugins.sh
./change_zsh_theme.sh
rm update_zsh_plugins.sh change_zsh_theme.sh

# Install vim-plug for Vim plugin management
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Run additional setup scripts
./add_yakuake_autostart.sh
./setup_vim.sh

echo "--- Activating alias ---"
ZSHRC="$HOME/.zshrc"

# Add setopt aliases if not present
if ! grep -q 'setopt aliases' "$ZSHRC"; then
    echo "Adding 'setopt aliases' to ~/.zshrc"
    echo -e "\n# Enable alias support\nsetopt aliases" >> "$ZSHRC"
else
    echo "✅ 'setopt aliases' is already set."
fi

# Add updateSystem alias if not present
echo "🔧 Adding alias 'updateSystem' to ~/.zshrc..."
if ! grep -q "alias updateSystem=" "$ZSHRC"; then
    echo "alias updateSystem='bash ~/SetupManjaro/update_all.sh'" >> "$ZSHRC"
    echo "✅ Alias 'updateSystem' added."
else
    echo "ℹ️ Alias 'updateSystem' already exists."
fi

# Reboot the system
sudo systemctl reboot
