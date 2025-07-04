# A collection of functions used in the dotfiles installation scripts

is_installed() {
	command -v "$1" >/dev/null 2>&1
}

banner() {
	echo "=== $1"
}

# Bootstrap-specific banner with decorative formatting
bootstrap_banner() {
	echo "========================================================================"
	echo " $1"
	echo "========================================================================"
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

config_banner() {
  banner "Configuring $1"
}

do_stow() {
  stow -d "${DOTFILES_DIR}/configs" -t "${HOME}" "$1"
}

# Bootstrap-specific shared functions
check_dotfilesrc() {
	if test -f ~/.dotfilesrc; then
		source "$HOME"/.dotfilesrc
	else
		echo "ERROR: ~/.dotfilesrc does not exist"
		if is_macos; then
			echo "Please download and configure it first:"
			echo "curl -o ~/.dotfilesrc https://raw.githubusercontent.com/steveclarke/dotfiles/feature/macos/.dotfilesrc.macos"
		fi
		exit 2
	fi
}

copy_ssh_keys() {
	bootstrap_banner "Copying SSH keys"
	
	# Create .ssh directory if it doesn't exist
	mkdir -p "${HOME}/.ssh"
	chmod 700 "${HOME}/.ssh"
	
	# Check if SSH keys already exist locally
	local keys_exist=true
	for key in ${DOTFILES_SSH_KEYS}; do
		if [[ ! -f "${HOME}/.ssh/${key}" ]]; then
			keys_exist=false
			break
		fi
	done
	
	if [[ "$keys_exist" == "true" ]]; then
		echo "SSH keys already exist locally, skipping copy"
		return 0
	fi
	
	# Test if remote host is reachable
	echo "Testing connection to ${DOTFILES_SSH_KEYS_HOST}..."
	if ssh -o ConnectTimeout=5 -o BatchMode=yes "${DOTFILES_SSH_KEYS_HOST}" 'exit 0' 2>/dev/null; then
		echo "Remote host is reachable, copying SSH keys..."
		# Copy each SSH key individually for better error handling
		for key in ${DOTFILES_SSH_KEYS}; do
			echo "Copying ${key}..."
			if scp "${DOTFILES_SSH_KEYS_HOST}:.ssh/${key}" "${HOME}/.ssh/${key}" 2>/dev/null; then
				echo "✓ ${key} copied successfully"
			else
				echo "⚠ Failed to copy ${key} (may not exist on remote host)"
			fi
		done
		
		# Set proper permissions
		echo "Setting SSH key permissions..."
		if is_macos; then
			chmod 600 "${HOME}/.ssh/"* 2>/dev/null || true
			chmod 644 "${HOME}/.ssh/"*.pub 2>/dev/null || true
		else
			chmod 600 "${HOME}/.ssh/"* 2>/dev/null || true
			chmod 644 "${HOME}/.ssh/"*.pub 2>/dev/null || true
		fi
		echo "SSH keys processing complete"
	else
		echo "WARNING: Cannot reach ${DOTFILES_SSH_KEYS_HOST}"
		echo "SSH keys will need to be copied manually to ${HOME}/.ssh/"
		echo "Required keys: ${DOTFILES_SSH_KEYS}"
		echo ""
		echo "You can either:"
		echo "1. Copy the keys manually to ${HOME}/.ssh/"
		echo "2. Update DOTFILES_SSH_KEYS_HOST in ~/.dotfilesrc to a reachable host"
		echo "3. Skip SSH key copying if you'll set them up differently"
		echo ""
		echo "Press Enter to continue without copying SSH keys, or Ctrl+C to abort..."
		read -r
	fi
}

configure_ssh() {
	bootstrap_banner "Configuring SSH"
	
	# Create SSH config if it doesn't exist
	if [ ! -f "${HOME}/.ssh/config" ]; then
		touch "${HOME}/.ssh/config"
		chmod 600 "${HOME}/.ssh/config"
	fi
	
	# Add identity file to SSH config
	echo "IdentityFile ~/.ssh/$DOTFILES_SSH_KEYS_PRIMARY" >> "${HOME}/.ssh/config"
}

clone_git_repo() {
	bootstrap_banner "Cloning git repo"

	if test -d "${DOTFILES_DIR}"; then
		echo "${DOTFILES_DIR} already exists"
	else
		if is_macos; then
			mkdir -p "$(dirname "${DOTFILES_DIR}")"
		fi
		git clone -b feature/macos git@github.com:steveclarke/dotfiles "${DOTFILES_DIR}"
	fi
}

bootstrap_warning() {
	if tput colors >/dev/null 2>&1 && [[ $(tput colors) -gt 0 ]]; then
		echo -e "\033[0;31m!!!!!!!!!!!!!!!!!!!!!!!!!!!\033[0m"
		echo -e "\033[0;31m!!!!!!!!! WARNING !!!!!!!!!\033[0m"
		echo -e "\033[0;31m!!!!!!!!!!!!!!!!!!!!!!!!!!!\033[0m"
	else
		echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!"
		echo "!!!!!!!!! WARNING !!!!!!!!!"
		echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!"
	fi
	
	if is_macos; then
		echo -e "This script is designed to bootstrap a fresh macOS system and may overwrite existing files."
	else
		echo -e "This script is designed to boostrap a fresh system and may overwrite existing files."
	fi
	echo -e "Are you sure you want to proceed?"
}

bootstrap_confirm() {
	echo -n "Do you want to proceed? (y/N): "
	read -r answer
	
	# convert answer to lowercase
	answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')
	
	if [ "$answer" = "y" ] || [ "$answer" = "yes" ]; then
		return 0
	else
		echo "Exiting..."
		return 1
	fi
}

install_linux_prerequisites() {
	bootstrap_banner "Installing bootstrap pre-requisites"
	sudo apt update &&
		sudo apt install -y \
			git \
			curl \
			software-properties-common \
			build-essential
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

run_installation() {
	bootstrap_banner "Running dotfiles installation"
	
	cd "${DOTFILES_DIR}" || exit 1
	bash install.sh
}
