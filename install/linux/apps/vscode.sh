# Install Visual Studio Code
# Reference: https://code.visualstudio.com/docs/setup/linux

if ! is_installed code; then
  installing_banner "Visual Studio Code"
  
  # Install prerequisites for repository setup
  apt_install wget gpg apt-transport-https
  
  # Add Microsoft GPG key and repository
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
  sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
  echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
  rm -f packages.microsoft.gpg
  
  # Update package list and install VS Code
  sudo apt update
  apt_install code
  
  echo "✅ Visual Studio Code installed successfully"
  echo "💡 To enable Wayland support:"
  echo "   1. Copy /usr/share/applications/code.desktop to ~/.local/share/applications/"
  echo "   2. Change the Exec line to: Exec=env --ozone-platform=wayland %F"
else
  skipping "Visual Studio Code"
fi
