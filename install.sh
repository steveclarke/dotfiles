#!/usr/bin/env bash

source "${HOME}"/.dotfilesrc
source "${DOTFILES_DIR}"/lib/dotfiles.sh

install () {
  # Install prerequisites
  source "${DOTFILES_DIR}"/install/prereq.sh

  # Stow configs
  source "${DOTFILES_DIR}"/configs/stow.sh

  source "$DOTFILES_DIR"/install/cli.sh

  if [ "${DOTFILES_INSTALL_GUI^^}" = "TRUE" ]; then
    source "$DOTFILES_DIR"/install/apps.sh
    source "$DOTFILES_DIR"/install/desktop-entries.sh
  else
    echo "Skipping GUI apps installation."
  fi

  # Run setups
  for installer in "${DOTFILES_DIR}"/setups/*.sh; do source $installer; done

  echo "You're all set! You should now reboot the system."
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
