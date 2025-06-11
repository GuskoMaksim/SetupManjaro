#!/bin/bash

sudo bash -c "$(curl -LSs https://github.com/dfmgr/installer/raw/main/install.sh)"
sudo fontmgr install MesloLGSNF

# Клонирование тем и плагинов
# Проверка и клонирование powerlevel10k
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    echo "Клонируем powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
else
    echo "powerlevel10k уже установлен."
fi

# Проверка и клонирование zsh-autosuggestions
if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    echo "Клонируем zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
else
    echo "zsh-autosuggestions уже установлен."
fi

# Проверка и клонирование zsh-syntax-highlighting
if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    echo "Клонируем zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
else
    echo "zsh-syntax-highlighting уже установлен."
fi

# Проверка и клонирование fzf-tab
if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab" ]; then
    echo "Клонируем fzf-tab..."
    git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab
else
    echo "fzf-tab уже установлен."
fi

# Проверка и клонирование you-should-use
if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/you-should-use" ]; then
    echo "Клонируем you-should-use..."
    git clone https://github.com/MichaelAquilina/zsh-you-should-use.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/you-should-use
else
    echo "you-should-use уже установлен."
fi


# Создание скрипта для изменения темы ZSH
echo '#!/bin/bash
# Путь к файлу .zshrc
ZSHRC_FILE="$HOME/.zshrc"
# Проверь, существует ли файл .zshrc
if [ -f "$ZSHRC_FILE" ]; then
    # Замена темы robbyrussell на powerlevel10k
    sed -i '"'"'s/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/'"'"' "$ZSHRC_FILE"
    echo "Тема ZSH успешно изменена на powerlevel10k!"
else
    echo "Файл .zshrc не найден!"
fi' > change_zsh_theme.sh

# Создание скрипта для обновления плагинов ZSH
echo '#!/bin/bash
# Путь к файлу .zshrc
ZSHRC_FILE="$HOME/.zshrc"
# Проверь, существует ли файл .zshrc
if [ -f "$ZSHRC_FILE" ]; then
    # Замена строки plugins=(git) на полный список плагинов
    sed -i '"'"'/plugins=(git)/c\plugins=(\n  git\n  zsh-autosuggestions\n  zsh-syntax-highlighting\n  web-search\n  dirhistory\n  history\n  fzf-tab\n  z\n  you-should-use\n)'"'"' "$ZSHRC_FILE"
    # Проверка, если строка ZSH_HIGHLIGHT_HIGHLIGHTERS уже существует
    if ! grep -q "ZSH_HIGHLIGHT_HIGHLIGHTERS" "$ZSHRC_FILE"; then
        # Добавляем строку ZSH_HIGHLIGHT_HIGHLIGHTERS в конец файла
        echo '"'"'ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor root)'"'"' >> "$ZSHRC_FILE"
        echo "ZSH_HIGHLIGHT_HIGHLIGHTERS добавлено!"
    else
        echo "ZSH_HIGHLIGHT_HIGHLIGHTERS уже существует!"
    fi
    echo "Плагины ZSH успешно изменены!"
else
    echo "Файл .zshrc не найден!"
fi' > update_zsh_plugins.sh

# Делаем скрипты исполняемыми
chmod +x change_zsh_theme.sh
chmod +x update_zsh_plugins.sh

# Выполняем скрипты
./update_zsh_plugins.sh
./change_zsh_theme.sh
rm update_zsh_plugins.sh
rm change_zsh_theme.sh

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \

./add_yakuake_autostart.sh
./setup_vim.sh

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
    echo "alias updateSystem='bash ~/SetupManjaro/update_all.sh'" >> ~/.zshrc
    echo "✅ Alias 'updateSystem' added."
else
    echo "ℹ️ Alias 'updateSystem' already exists."
fi

# Перезагрузка системы
sudo systemctl reboot
