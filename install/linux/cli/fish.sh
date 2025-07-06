# Install Fish shell from official PPA

if ! is_installed fish; then
  installing_banner "Fish shell"
  
  # Add official Fish shell PPA
  sudo apt-add-repository -y ppa:fish-shell/release-3
  sudo apt update
  
  # Install fish shell
  apt_install fish
  
  # Set fish as the default shell
  sudo chsh -s /usr/bin/fish "$USER"
else
  skipping "Fish shell"
fi
