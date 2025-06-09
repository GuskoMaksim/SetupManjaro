#!/bin/bash

PROGRAM_NAME="Yakuake"
EXEC_COMMAND="yakuake"

# Path to autostart directory
AUTOSTART_DIR="$HOME/.config/autostart"

# Check if the directory exists
if [ ! -d "$AUTOSTART_DIR" ]; then
    mkdir -p "$AUTOSTART_DIR"
fi

# Path to the autostart file
DESKTOP_FILE="$AUTOSTART_DIR/$PROGRAM_NAME.desktop"

# Create .desktop file with settings
cat <<EOL > "$DESKTOP_FILE"
[Desktop Entry]
Type=Application
Exec=$EXEC_COMMAND
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=$PROGRAM_NAME
Comment=Launch Yakuake on system startup
EOL

# Make the file executable
chmod +x "$DESKTOP_FILE"

echo "Yakuake has been added to autostart."

