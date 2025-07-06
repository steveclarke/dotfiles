# Install Google Chrome
# Reference: https://www.google.com/chrome/

if ! is_installed google-chrome-stable; then
  installing_banner "Google Chrome"
  
  # Download Chrome package to temporary directory
  TEMP_DIR=$(mktemp -d)
  cd "$TEMP_DIR" || exit 1
  
  # Download Chrome .deb package
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  
  # Install Chrome using apt
  sudo apt install -y ./google-chrome-stable_current_amd64.deb
  
  # Set Chrome as default web browser
  if command -v xdg-settings >/dev/null 2>&1; then
    xdg-settings set default-web-browser google-chrome.desktop
  fi
  
  # Clean up
  cd - || exit 1
  rm -rf "$TEMP_DIR"
  
  echo "✅ Google Chrome installed successfully"
else
  skipping "Google Chrome"
fi
