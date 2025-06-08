#!/bin/bash

set -e

NEW_USER="gusko_work"

# Получаем имя текущего пользователя
CURRENT_USER=$(logname)

echo "🧾 Current user: $CURRENT_USER"
echo "👤 Creating user: $NEW_USER"

# Проверяем, существует ли пользователь
if id "$NEW_USER" &>/dev/null; then
    echo "⚠️ User $NEW_USER already exists."
    exit 1
fi

# Получаем группы текущего пользователя через пробелы
USER_GROUPS=$(id -nG "$CURRENT_USER")

# Добавляем группу docker, если её нет
if ! echo "$USER_GROUPS" | grep -qw "docker"; then
    USER_GROUPS="$USER_GROUPS docker"
fi

# Преобразуем пробелы в запятые для передачи в -G
GROUPS_CSV=$(echo "$USER_GROUPS" | tr ' ' ',')

echo "Добавляем пользователя $NEW_USER с группами: $GROUPS_CSV"

sudo useradd -m -G "$GROUPS_CSV" "$NEW_USER"

echo "🔐 Установите пароль для $NEW_USER:"
sudo passwd "$NEW_USER"

echo "✅ Пользователь $NEW_USER создан с группами: $GROUPS_CSV"
