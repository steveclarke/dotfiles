#!/usr/bin/env bash
# Install Visual Studio Code
# Reference: https://code.visualstudio.com/docs/setup/linux

# Enable strict error handling
set -euo pipefail

# Source required libraries
source "${DOTFILES_DIR}/lib/linux.sh"

# Dependency declarations
SCRIPT_DEPENDS_COMMANDS=("wget" "gpg")
SCRIPT_DEPENDS_PACKAGES=("apt-transport-https")
SCRIPT_DEPENDS_PLATFORM=("linux")
SCRIPT_DEPENDS_DISTRO=("ubuntu")
SCRIPT_DEPENDS_ENV=("DOTFILES_DIR")
SCRIPT_DEPENDS_DIRS=("/etc/apt/keyrings" "/etc/apt/sources.list.d")
SCRIPT_DEPENDS_MINIMUM_VERSION=("wget:1.0" "gpg:2.0")
SCRIPT_DEPENDS_CONFLICTS=("snap:code")

# Manual installation function for VS Code
install_vscode_manual() {
  log_info "Installing Visual Studio Code via manual repository setup"
  
  # Install prerequisites using unified package management
  local prereqs=("wget" "gpg" "apt-transport-https")
  log_info "Installing prerequisites: ${prereqs[*]}"
  
  if ! linux_install_packages "${prereqs[@]}"; then
    log_error "Failed to install prerequisites for VS Code"
    return 1
  fi
  
  # Add Microsoft GPG key and repository
  log_info "Adding Microsoft GPG key and repository"
  if ! wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg; then
    log_error "Failed to download Microsoft GPG key"
    return 1
  fi
  
  if ! sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg; then
    log_error "Failed to install Microsoft GPG key"
    return 1
  fi
  
  log_info "Adding VS Code repository to sources"
  if ! echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null; then
    log_error "Failed to add VS Code repository"
    return 1
  fi
  
  # Clean up temporary GPG key file
  rm -f packages.microsoft.gpg
  
  # Update package list
  log_info "Updating package lists"
  if ! sudo apt update; then
    log_error "Failed to update package lists"
    return 1
  fi
  
  # Install VS Code using apt
  log_info "Installing Visual Studio Code from repository"
  if install_package "code" "apt"; then
    log_success "Visual Studio Code installed successfully via manual setup"
    return 0
  else
    log_error "Failed to install Visual Studio Code from repository"
    return 1
  fi
}

# Main installation function
install_vscode() {
  log_banner "Installing Visual Studio Code"
  
  # Check if already installed
  if is_package_installed "code"; then
    log_warn "Visual Studio Code is already installed"
    return 0
  fi
  
  # Check for conflicts (e.g., snap version)
  if ! check_package_conflicts "code" "${SCRIPT_DEPENDS_CONFLICTS:-}"; then
    log_error "Package conflicts detected for Visual Studio Code"
    log_info "Please resolve conflicts before installing"
    return 1
  fi
  
  # Try unified package management with fallback to manual installation
  log_info "Attempting to install Visual Studio Code using unified package management"
  
  # First try snap (if available and no conflicts)
  if install_package "code" "snap" "--classic" "install_vscode_manual"; then
    log_success "Visual Studio Code installed successfully"
    
    # Show helpful tips
    log_info "Installation complete! Helpful tips:"
    log_info "• Launch VS Code with: code"
    log_info "• For Wayland support, use: code --ozone-platform=wayland"
    log_info "• Install extensions with: code --install-extension <extension-id>"
    
    return 0
  else
    log_error "Failed to install Visual Studio Code"
    return 1
  fi
}

# Alternative installation methods
install_vscode_snap() {
  log_info "Installing Visual Studio Code via Snap"
  install_package "code" "snap" "--classic"
}

install_vscode_flatpak() {
  log_info "Installing Visual Studio Code via Flatpak"
  install_package "com.visualstudio.code" "flatpak"
}

# Validation function
validate_vscode_installation() {
  log_info "Validating Visual Studio Code installation"
  
  if command -v code >/dev/null 2>&1; then
    local version
    version=$(code --version | head -1 2>/dev/null || echo "unknown")
    log_success "Visual Studio Code is installed (version: $version)"
    
    # Check for common issues
    if [[ "$XDG_SESSION_TYPE" == "wayland" ]]; then
      log_info "Wayland session detected - you may want to use: code --ozone-platform=wayland"
    fi
    
    return 0
  else
    log_error "Visual Studio Code validation failed - command not found"
    return 1
  fi
}

# Show installation options
show_vscode_options() {
  log_info "Visual Studio Code installation options:"
  log_info "  1. Unified package management (recommended) - tries snap, then manual"
  log_info "  2. Snap package - install_vscode_snap"
  log_info "  3. Flatpak package - install_vscode_flatpak"
  log_info "  4. Manual repository setup - install_vscode_manual"
}

# Main execution
main() {
  local action="${1:-install}"
  
  case "$action" in
    install)
      install_vscode
      ;;
    snap)
      install_vscode_snap
      ;;
    flatpak)
      install_vscode_flatpak
      ;;
    manual)
      install_vscode_manual
      ;;
    validate)
      validate_vscode_installation
      ;;
    options)
      show_vscode_options
      ;;
    *)
      log_error "Invalid action: $action"
      log_info "Available actions: install, snap, flatpak, manual, validate, options"
      exit 1
      ;;
  esac
}

# Execute main function if script is run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi
