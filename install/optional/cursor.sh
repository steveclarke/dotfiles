#!/bin/bash

# Cursor AI IDE Installer
# Based on: https://gist.github.com/evgenyneu/5c5c37ca68886bf1bea38026f60603b6

# Configuration variables
ICON_URL="https://registry.npmmirror.com/@lobehub/icons-static-png/latest/files/dark/cursor.png"
CURSOR_DIR="/opt/cursor"
APPIMAGE_PATH="$CURSOR_DIR/cursor.appimage"
ICON_PATH="$CURSOR_DIR/cursor.png"
DESKTOP_ENTRY_PATH="/usr/share/applications/cursor.desktop"

# Get the actual user's home directory, even when run with sudo
get_user_home() {
    if [ -n "$SUDO_USER" ]; then
        USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
    else
        USER_HOME=$HOME
    fi
    echo "$USER_HOME"
}

# Find downloaded Cursor AppImage
find_cursor_appimage() {
    USER_HOME=$(get_user_home)
    DOWNLOADS_DIR="$USER_HOME/Downloads"
    
    echo "Looking for Cursor AppImage in $DOWNLOADS_DIR..."
    CURSOR_APPIMAGE=$(find "$DOWNLOADS_DIR" -maxdepth 1 -name "Cursor*.AppImage" -type f -print -quit 2>/dev/null)
    
    if [ -z "$CURSOR_APPIMAGE" ]; then
        echo "Error: Could not find Cursor AppImage in $DOWNLOADS_DIR"
        echo "Please download the latest version from https://cursor.sh/download"
        echo "After downloading, run this script again."
        return 1
    fi
    
    echo "Found Cursor AppImage: $CURSOR_APPIMAGE"
    return 0
}

# Check installation status
check_installation() {
    # Check for current installation location
    if [ -f "$APPIMAGE_PATH" ]; then
        echo "Cursor AI IDE is already installed at: $APPIMAGE_PATH"
        echo "Will update to the latest version."
        return 1
    fi
    
    # No installation found
    echo "No existing Cursor installation found. Will perform a fresh install."
    return 0
}

# Check for sudo privileges
check_sudo() {
    if [ "$(id -u)" -ne 0 ]; then
        echo "This script needs sudo privileges to install/update Cursor AI."
        echo "Please run with: sudo $0"
        return 1
    fi
    return 0
}

# Install dependencies
install_dependencies() {
    if ! command -v curl &> /dev/null; then
        echo "curl is not installed. Installing..."
        apt-get update && apt-get install -y curl || {
            echo "Failed to install curl. Aborting installation."
            return 1
        }
    fi
    return 0
}

# Install Cursor from downloaded AppImage
install_cursor() {
    echo "Installing Cursor AppImage to $CURSOR_DIR..."
    mkdir -p "$CURSOR_DIR"
    
    # Copy the AppImage to the installation directory
    cp "$CURSOR_APPIMAGE" "$APPIMAGE_PATH"
    chmod +x "$APPIMAGE_PATH"
    
    echo "Downloading Cursor icon..."
    curl -L "$ICON_URL" -o "$ICON_PATH" || {
        echo "Failed to download Cursor icon, but continuing installation."
    }
    return 0
}

# Create desktop entry
create_desktop_entry() {
    echo "Creating/updating .desktop entry for Cursor..."
    cat > "$DESKTOP_ENTRY_PATH" <<EOL
[Desktop Entry]
Name=Cursor AI IDE
Exec=$APPIMAGE_PATH --no-sandbox --class=Cursor %F
Icon=$ICON_PATH
Type=Application
Categories=Development;IDE;
StartupWMClass=Cursor
StartupNotify=true
MimeType=text/plain;inode/directory;
EOL
    return 0
}

# Main installation function
installCursor() {
    echo "Installing/Updating Cursor AI IDE..."
    
    check_sudo || return 1
    install_dependencies || return 1
    
    # Find Cursor AppImage in Downloads directory
    find_cursor_appimage || return 1
    
    # Get installation status
    check_installation
    
    # Install or update from downloaded AppImage
    install_cursor || return 1
    
    create_desktop_entry
    
    echo "Cursor AI IDE installation/update complete. You can find it in your application menu."
    echo "You can launch it from the application menu or by running: $APPIMAGE_PATH"
    return 0
}

# Execute the installation
installCursor
