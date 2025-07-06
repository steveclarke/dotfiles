# Install GNU Stow for configuration management

# Dependency declarations
SCRIPT_DEPENDS_COMMANDS=("apt" "dpkg")
SCRIPT_DEPENDS_PLATFORM=("linux")
SCRIPT_DEPENDS_DISTRO=("ubuntu")
SCRIPT_DEPENDS_ENV=("DOTFILES_DIR")

apt_install stow
