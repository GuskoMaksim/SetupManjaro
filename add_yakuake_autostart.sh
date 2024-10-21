#!/bin/bash

PROGRAM_NAME="Yakuake"
EXEC_COMMAND="yakuake"

# Путь к директории автозагрузки
AUTOSTART_DIR="$HOME/.config/autostart"

# Проверяем, существует ли директория
if [ ! -d "$AUTOSTART_DIR" ]; then
    mkdir -p "$AUTOSTART_DIR"
fi

# Путь к файлу автозапуска
DESKTOP_FILE="$AUTOSTART_DIR/$PROGRAM_NAME.desktop"

# Создаем .desktop файл с настройками
cat <<EOL > "$DESKTOP_FILE"
[Desktop Entry]
Type=Application
Exec=$EXEC_COMMAND
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=$PROGRAM_NAME
Comment=Запуск Yakuake при старте системы
EOL

# Делаем файл исполняемым
chmod +x "$DESKTOP_FILE"

echo "Yakuake добавлен в автозапуск."

