# Install Fish shell from official PPA

# Dependency declarations
SCRIPT_DEPENDS_COMMANDS=("apt" "apt-add-repository" "chsh")
SCRIPT_DEPENDS_PLATFORM=("linux")
SCRIPT_DEPENDS_DISTRO=("ubuntu")
SCRIPT_DEPENDS_ENV=("USER" "DOTFILES_DIR")
SCRIPT_DEPENDS_REPOS=("ppa:fish-shell/release-3")
SCRIPT_DEPENDS_MINIMUM_VERSION=("apt:1.0")

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
