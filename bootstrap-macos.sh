#!/usr/bin/env bash
# macOS Bootstrap Script

set -e -o pipefail

# Check for .dotfilesrc. if it doesn't exist exit with return value 2
if test -f ~/.dotfilesrc; then
	source "$HOME"/.dotfilesrc
else
	echo "ERROR: ~/.dotfilesrc does not exist"
	echo "Please download and configure it first:"
	echo "curl -o ~/.dotfilesrc https://raw.githubusercontent.com/steveclarke/dotfiles/master/.dotfilesrc.macos"
	exit 2
fi

banner() {
	echo "========================================================================"
	echo " $1"
	echo "========================================================================"
}

install_pre_requisites() {
	banner "Installing bootstrap pre-requisites"
	
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
		echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "${HOME}/.zprofile"
	fi
	
	# Install git if not already available
	if ! command -v git &>/dev/null; then
		echo "Installing git..."
		brew install git
	fi
}

copy_ssh_keys() {
	banner "Copying SSH keys"
	
	# Create .ssh directory if it doesn't exist
	mkdir -p "${HOME}/.ssh"
	chmod 700 "${HOME}/.ssh"
	
	# Copy SSH keys from remote host
	rsync -avz --files-from=<(printf "%s\n" "${DOTFILES_SSH_KEYS// /$'\n'}") "${DOTFILES_SSH_KEYS_HOST}:.ssh/" "${HOME}/.ssh"
	
	# Set proper permissions
	chmod 600 "${HOME}/.ssh/"*
	chmod 644 "${HOME}/.ssh/"*.pub
}

configure_ssh() {
	banner "Configuring SSH"
	
	# Create SSH config if it doesn't exist
	if [ ! -f "${HOME}/.ssh/config" ]; then
		touch "${HOME}/.ssh/config"
		chmod 600 "${HOME}/.ssh/config"
	fi
	
	# Add identity file to SSH config
	echo "IdentityFile ~/.ssh/$DOTFILES_SSH_KEYS_PRIMARY" >> "${HOME}/.ssh/config"
}

clone_git_repo() {
	banner "Cloning git repo"

	if test -d "${DOTFILES_DIR}"; then
		echo "${DOTFILES_DIR} already exists"
	else
		mkdir -p "$(dirname "${DOTFILES_DIR}")"
		git clone git@github.com:steveclarke/dotfiles "${DOTFILES_DIR}"
	fi
}

run_installation() {
	banner "Running dotfiles installation"
	
	cd "${DOTFILES_DIR}" || exit 1
	bash install.sh
}

# [[ Entry Point ]]
if tput colors >/dev/null 2>&1 && [[ $(tput colors) -gt 0 ]]; then
	echo -e "\033[0;31m!!!!!!!!!!!!!!!!!!!!!!!!!!!\033[0m"
	echo -e "\033[0;31m!!!!!!!!! WARNING !!!!!!!!!\033[0m"
	echo -e "\033[0;31m!!!!!!!!!!!!!!!!!!!!!!!!!!!\033[0m"
else
	echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!"
	echo "!!!!!!!!! WARNING !!!!!!!!!"
	echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!"
fi
echo -e "This script is designed to bootstrap a fresh macOS system and may overwrite existing files."
echo -e "Are you sure you want to proceed?"

echo -n "Do you want to proceed? (y/N): "
read -r answer

# convert answer to lowercase
answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')

if [ "$answer" = "y" ] || [ "$answer" = "yes" ]; then
	install_pre_requisites
	copy_ssh_keys
	configure_ssh
	clone_git_repo
	run_installation
	
	echo ""
	banner "Bootstrap complete!"
	echo "Consider restarting your terminal or running 'source ~/.zprofile' to ensure all changes take effect."
else
	echo "Exiting..."
fi 
