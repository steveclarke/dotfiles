# Core cross-platform functions for dotfiles installation

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

config_banner() {
  banner "Configuring $1"
}

do_stow() {
  stow -d "${DOTFILES_DIR}/configs" -t "${HOME}" "$1"
}
