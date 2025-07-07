#!/usr/bin/env bash
#
# Script Name: install.sh
# Description: Main installation script for dotfiles across Linux and macOS
# Platform: cross-platform
# Dependencies: .dotfilesrc, stow, platform-specific package managers
#

# Exit on error, undefined variables, and pipe failures
set -euo pipefail

# Source required libraries
source "${HOME}"/.dotfilesrc
source "${DOTFILES_DIR}"/lib/dotfiles.sh

# Dependency declarations
SCRIPT_DEPENDS_COMMANDS=("stow" "git")
SCRIPT_DEPENDS_PLATFORM=("linux" "macos")
SCRIPT_DEPENDS_ENV=("DOTFILES_DIR" "HOME" "DOTFILES_INSTALL_GUI")
SCRIPT_DEPENDS_FILES=("${HOME}/.dotfilesrc")
SCRIPT_DEPENDS_DIRS=("${DOTFILES_DIR}/lib" "${DOTFILES_DIR}/install" "${DOTFILES_DIR}/configs")
SCRIPT_DEPENDS_MINIMUM_VERSION=("git:2.0" "stow:2.0")

# Detect OS at start
detect_os

# Individual installation step functions for resumable installation
run_macos_prereq() {
  bash "${DOTFILES_DIR}"/install/macos/prereq.sh
}

run_macos_stow() {
  bash "${DOTFILES_DIR}"/configs/stow.sh
}

run_macos_brew() {
  bash "${DOTFILES_DIR}"/install/macos/brew.sh
}

run_macos_fonts() {
  bash "${DOTFILES_DIR}"/install/macos/fonts.sh
}

run_macos_fish() {
  bash "${DOTFILES_DIR}"/install/macos/fish.sh
}

run_macos_setups() {
  for setup in "${DOTFILES_DIR}"/setups/macos/*.sh; do 
    # shellcheck disable=SC1090
    [[ -f $setup ]] && bash "$setup"
  done
}

run_cross_platform_setups() {
  for setup in "${DOTFILES_DIR}"/setups/*.sh; do
    # shellcheck disable=SC1090
    [[ -f $setup ]] && bash "$setup"
  done
}

run_linux_prereq() {
  bash "${DOTFILES_DIR}"/install/linux/prereq.sh
}

run_linux_stow() {
  bash "${DOTFILES_DIR}"/configs/stow.sh
}

run_linux_cli() {
  bash "$DOTFILES_DIR"/install/linux/cli.sh
}

run_linux_apps() {
  if [ "${DOTFILES_INSTALL_GUI^^}" = "TRUE" ]; then
    bash "$DOTFILES_DIR"/install/linux/apps.sh
  else
    log_info "Skipping GUI applications (DOTFILES_INSTALL_GUI not set to true)"
  fi
}

run_linux_desktop_entries() {
  if [ "${DOTFILES_INSTALL_GUI^^}" = "TRUE" ]; then
    bash "$DOTFILES_DIR"/install/linux/desktop-entries.sh
  else
    log_info "Skipping desktop entries (DOTFILES_INSTALL_GUI not set to true)"
  fi
}

run_linux_setups() {
  for setup in "${DOTFILES_DIR}"/setups/linux/*.sh; do 
    # shellcheck disable=SC1090
    [[ -f $setup ]] && bash "$setup"
  done
}

install() {
  # Initialize installation state tracking
  init_installation_state "install"
  
  if is_macos; then
    # macOS installation flow with resumable steps
    log_installation_banner "Starting macOS installation"
    
    # Run each step with resumable functionality
    run_step "macos_prereq" "Install macOS prerequisites" run_macos_prereq
    run_step "macos_stow" "Configure dotfiles with stow" run_macos_stow
    run_step "macos_brew" "Install packages via Homebrew" run_macos_brew
    run_step "macos_fonts" "Install fonts" run_macos_fonts
    run_step "macos_fish" "Configure fish shell" run_macos_fish
    run_step "macos_setups" "Run macOS-specific setups" run_macos_setups
    run_step "cross_platform_setups" "Run cross-platform setups" run_cross_platform_setups
    
    log_success "macOS installation complete! Consider restarting to apply system changes."
  else
    # Linux installation flow with resumable steps
    log_installation_banner "Starting Linux installation"
    
    # Run each step with resumable functionality
    run_step "linux_prereq" "Install Linux prerequisites" run_linux_prereq
    run_step "linux_stow" "Configure dotfiles with stow" run_linux_stow
    run_step "linux_cli" "Install CLI tools" run_linux_cli
    run_step "linux_apps" "Install GUI applications" run_linux_apps
    run_step "linux_desktop_entries" "Install desktop entries" run_linux_desktop_entries
    run_step "cross_platform_setups" "Run cross-platform setups" run_cross_platform_setups
    run_step "linux_setups" "Run Linux-specific setups" run_linux_setups
    
    log_success "Linux installation complete! You should now reboot the system."
  fi
  
  # Show final installation progress
  show_installation_progress
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
