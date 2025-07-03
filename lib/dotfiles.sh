# A collection of functions used in the dotfiles installation scripts

is_installed() {
	command -v "$1" >/dev/null 2>&1
}

banner() {
	echo "=== $1"
}

installing_banner() {
  banner "Installing $1"
}

skipping() {
	echo "=== skipping $1 - already installed"
}

apt_install() {
	sudo apt install -y "$1"
}

# OS Detection and Platform Functions
detect_os() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    export DOTFILES_OS="macos"
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    export DOTFILES_OS="linux"
  else
    echo "Unsupported OS: $OSTYPE"
    exit 1
  fi
}

is_macos() {
  [[ "$DOTFILES_OS" == "macos" ]]
}

is_linux() {
  [[ "$DOTFILES_OS" == "linux" ]]
}

# macOS-specific helper functions
macos_defaults() {
  # Helper for setting macOS system preferences
  defaults write "$@"
}

config_banner() {
  banner "Configuring $1"
}

do_stow() {
  stow -d "${DOTFILES_DIR}/configs" -t "${HOME}" "$1"
}
