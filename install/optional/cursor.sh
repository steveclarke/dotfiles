#!/bin/bash

# Cursor AI IDE Installer
# Based on: https://gist.github.com/evgenyneu/5c5c37ca68886bf1bea38026f60603b6

# Configuration variables
CURSOR_URL="https://downloader.cursor.sh/linux/appImage/x64"
ICON_URL="https://registry.npmmirror.com/@lobehub/icons-static-png/latest/files/dark/cursor.png"
APPIMAGE_PATH="/opt/cursor.appimage"
ICON_PATH="/opt/cursor.png"
DESKTOP_ENTRY_PATH="/usr/share/applications/cursor.desktop"

# Check if already installed
check_installation() {
    if [ -f "$APPIMAGE_PATH" ]; then
        echo "Cursor AI IDE is already installed."
        return 1
    fi
    return 0
}

# Check for sudo privileges
check_sudo() {
    if [ "$(id -u)" -ne 0 ]; then
        echo "This script needs sudo privileges to install Cursor AI."
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

# Download Cursor AppImage and icon
download_files() {
    echo "Downloading Cursor AppImage..."
    if ! curl -L "$CURSOR_URL" -o "$APPIMAGE_PATH"; then
        echo "Failed to download Cursor AppImage. Please check your internet connection."
        return 1
    fi
    chmod +x "$APPIMAGE_PATH"

    echo "Downloading Cursor icon..."
    curl -L "$ICON_URL" -o "$ICON_PATH" || {
        echo "Failed to download Cursor icon, but continuing installation."
    }
    return 0
}

# Create desktop entry
create_desktop_entry() {
    echo "Creating .desktop entry for Cursor..."
    cat > "$DESKTOP_ENTRY_PATH" <<EOL
[Desktop Entry]
Name=Cursor AI IDE
Exec=$APPIMAGE_PATH --no-sandbox
Icon=$ICON_PATH
Type=Application
Categories=Development;
EOL
    return 0
}

# Add shell aliases
add_shell_aliases() {
    # Bash alias
    if [ -f "$HOME/.bashrc" ]; then
        echo "Adding cursor alias to .bashrc..."
        cat >> "$HOME/.bashrc" <<EOL

# Cursor alias
function cursor() {
    $APPIMAGE_PATH --no-sandbox "\${@}" > /dev/null 2>&1 & disown
}
EOL
        echo "Alias added. To use it in this terminal session, run: source $HOME/.bashrc"
    else
        echo "Could not find .bashrc file. Cursor can still be launched from the application menu."
    fi

    # Fish shell alias
    FISH_CONFIG="$HOME/.config/fish/config.fish"
    if [ -f "$FISH_CONFIG" ]; then
        echo "Adding cursor alias to fish config..."
        cat >> "$FISH_CONFIG" <<EOL

# Cursor alias
function cursor
    $APPIMAGE_PATH --no-sandbox \$argv > /dev/null 2>&1 & disown
end
EOL
        echo "Fish alias added. To use it in this terminal session, run: source $FISH_CONFIG"
    fi
    return 0
}

# Main installation function
installCursor() {
    echo "Installing Cursor AI IDE..."
    
    check_installation || return 0
    check_sudo || return 1
    install_dependencies || return 1
    download_files || return 1
    create_desktop_entry
    add_shell_aliases
    
    echo "Cursor AI IDE installation complete. You can find it in your application menu."
    return 0
}

# Execute the installation
installCursor
