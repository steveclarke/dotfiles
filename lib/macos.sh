# macOS-specific functions for dotfiles installation

# Source core functions
source "${DOTFILES_DIR}/lib/dotfiles.sh"
source "${DOTFILES_DIR}/lib/bootstrap.sh"

# macOS-specific helper functions
macos_defaults() {
  # Helper for setting macOS system preferences
  defaults write "$@"
}

# Sudo credential caching helper
cache_sudo_credentials() {
  if is_macos; then
    echo "Caching sudo credentials for package installation..."
    sudo -v
    
    # Keep sudo timestamp refreshed in background (for long installations)
    # This will refresh the timestamp every 60 seconds until the script exits
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
  fi
}

install_macos_prerequisites() {
	bootstrap_banner "Installing bootstrap pre-requisites"
	
	# Install Xcode Command Line Tools if not already installed
	if ! xcode-select -p &>/dev/null; then
		echo "Installing Xcode Command Line Tools..."
		xcode-select --install
		echo "Please complete the Xcode Command Line Tools installation and re-run this script."
		exit 1
	fi
	
	# Install Homebrew if not already installed
	if ! command -v brew &>/dev/null; then
		echo "Installing Homebrew..."
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
		
		# Add Homebrew to PATH for current session
		eval "$(/opt/homebrew/bin/brew shellenv)"
		
		# Also add to shell profile for future sessions
		echo "eval \"\$(/opt/homebrew/bin/brew shellenv)\"" >> "${HOME}/.zprofile"
	fi
	
	# Install git if not already available
	if ! command -v git &>/dev/null; then
		echo "Installing git..."
		brew install git
	fi
} 
