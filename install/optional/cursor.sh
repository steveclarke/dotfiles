# #!/bin/bash

cd /tmp || exit
curl -L "https://www.cursor.com/api/download?platform=linux-x64&releaseTrack=stable" | jq -r '.downloadUrl' | xargs curl -L -o cursor.appimage
sudo mv cursor.appimage /opt/cursor/cursor.appimage
sudo chmod +x /opt/cursor/cursor.appimage
sudo apt install -y fuse3
sudo apt install -y libfuse2t64

ICON_URL="https://registry.npmmirror.com/@lobehub/icons-static-png/latest/files/dark/cursor.png"

# Download Cursor icon
echo "Downloading Cursor icon..."
if ! sudo curl -L $ICON_URL -o /opt/cursor/cursor.png; then
	echo "Failed to download Cursor icon, but continuing installation."
fi

DESKTOP_FILE="/usr/share/applications/cursor.desktop"

sudo bash -c "cat > $DESKTOP_FILE" <<EOL
[Desktop Entry]
Name=Cursor
Comment=AI-powered code editor
Exec=/opt/cursor/cursor.appimage --no-sandbox --ozone-platform=wayland %F
Icon=/opt/cursor/cursor.png
Type=Application
Categories=Development;IDE;
EOL

if [ -f "$DESKTOP_FILE" ]; then
	echo "cursor.desktop created successfully"
else
	echo "Failed to create cursor.desktop"
fi
