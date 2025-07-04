#!/usr/bin/env bash

set -e -o pipefail

# Check for .dotfilesrc. if it doesn't exist exit with return value 2
if test -f ~/.dotfilesrc; then
	source "$HOME"/.dotfilesrc
else
	echo "ERROR: ~/.dotfilesrc does not exist"
	exit 2
fi

banner() {
	echo "========================================================================"
	echo " $1"
	echo "========================================================================"
}

install_pre_requisites() {
	banner "Installing bootstrap pre-requisites"
	
	if [[ "$OSTYPE" == "darwin"* ]]; then
		# macOS
		# Check if Xcode Command Line Tools are installed
		if ! xcode-select -p &> /dev/null; then
			echo "Installing Xcode Command Line Tools (includes git)..."
			xcode-select --install
			echo "Please wait for the Xcode Command Line Tools installation to complete,"
			echo "then run this script again."
			exit 0
		fi
		
		echo "Xcode Command Line Tools are installed (git is now available)"
		# curl is available by default on macOS, git is now available via Xcode tools
	else
		# Linux (Debian-based)
		sudo apt update &&
			sudo apt install -y \
				git \
				curl \
				software-properties-common \
				build-essential
	fi
}

copy_ssh_keys() {
	banner "Copying SSH keys"
	rsync -avz --files-from=<(printf "%s\n" "${DOTFILES_SSH_KEYS// /$'\n'}") "${DOTFILES_SSH_KEYS_HOST}:.ssh/" "${HOME}/.ssh"
}

configure_ssh() {
	banner "Configuring SSH"

	echo "IdentityFile ~/.ssh/$DOTFILES_SSH_KEYS_PRIMARY" >>~/.ssh/config
}

clone_git_repo() {
	banner "Cloning git repo"

	if test -d "${DOTFILES_DIR}"; then
		echo "${DOTFILES_DIR} already exists"
	else
		git clone git@github.com:steveclarke/dotfiles "${DOTFILES_DIR}"
	fi
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
echo -e "This script is designed to boostrap a fresh system and may overwrite existing files."
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
else
	echo "Exiting..."
fi
