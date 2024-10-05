#!/usr/bin/env bash

source "${HOME}"/.dotfilesrc
source "${DOTFILES_DIR}"/lib/dotfiles.sh

install () {
  # Install prerequisites
  bash "${DOTFILES_DIR}"/install/prereq.sh

  # Stow configs
  bash "${DOTFILES_DIR}"/configs/stow.sh

  bash "$DOTFILES_DIR"/install/cli.sh
  bash "$DOTFILES_DIR"/install/apps.sh
  bash "$DOTFILES_DIR"/install/desktop-entries.sh
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
