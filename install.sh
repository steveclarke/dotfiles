#!/usr/bin/env bash

source "${HOME}"/.dotfilesrc
source "${DOTFILES_DIR}"/lib/dotfiles.sh

# Detect OS at start
detect_os

install () {
  if is_macos; then
    # macOS installation flow
    banner "Starting macOS installation"
    
    # Install macOS prerequisites
    source "${DOTFILES_DIR}"/install/macos/prereq.sh
    
    # Stow configs
    source "${DOTFILES_DIR}"/configs/stow.sh
    
    # Install packages via Homebrew
    source "${DOTFILES_DIR}"/install/macos/brew.sh
    
    # Configure fish shell as default
    source "${DOTFILES_DIR}"/install/macos/fish.sh
    
    # Run macOS-specific setups
    for setup in "${DOTFILES_DIR}"/setups/macos/*.sh; do 
      [[ -f $setup ]] && source "$setup"
    done
    
    # Run cross-platform setups (scripts that work on both Linux and macOS)
    for setup in "${DOTFILES_DIR}"/setups/*.sh; do
      [[ -f $setup ]] && source "$setup"
    done
    
    echo "macOS installation complete! Consider restarting to apply system changes."
  else
    # Linux installation flow (existing logic)
    banner "Starting Linux installation"
    
    # Install prerequisites
    source "${DOTFILES_DIR}"/install/linux/prereq.sh

    # Stow configs
    source "${DOTFILES_DIR}"/configs/stow.sh

    source "$DOTFILES_DIR"/install/linux/cli.sh

    if [ "${DOTFILES_INSTALL_GUI^^}" = "TRUE" ]; then
      source "$DOTFILES_DIR"/install/linux/apps.sh
      source "$DOTFILES_DIR"/install/linux/desktop-entries.sh
    fi

    # Run cross-platform setups
    for setup in "${DOTFILES_DIR}"/setups/*.sh; do 
      [[ -f $setup ]] && source "$setup"
    done
    
    # Run Linux-specific setups
    for setup in "${DOTFILES_DIR}"/setups/linux/*.sh; do 
      [[ -f $setup ]] && source "$setup"
    done

    echo "Linux installation complete! You should now reboot the system."
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
echo -e "This script is designed to set up a fresh system and may overwrite existing files."
echo -e "Are you sure you want to proceed?"

echo -n "Do you want to proceed? (y/N): "
read -r answer

# convert answer to lowercase
answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')

if [ "$answer" = "y" ] || [ "$answer" = "yes" ]; then
	install
else
	echo "Exiting..."
fi
