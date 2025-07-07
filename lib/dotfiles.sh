# Core cross-platform functions for dotfiles installation

# Source logging and error handling functions
source "${DOTFILES_DIR}/lib/logging.sh"

# Source unified package management system
source "${DOTFILES_DIR}/lib/package-management.sh"

# Source installation state tracking system
source "${DOTFILES_DIR}/lib/installation-state.sh"

# Set up error handling for all scripts using this library
setup_error_handling

is_installed() {
	command -v "$1" >/dev/null 2>&1
}

# Enhanced banner functions that use logging
banner() {
	log_banner "$1"
}

installing_banner() {
	log_banner "Installing $1"
	log_info "Starting installation of $1"
}

skipping() {
	log_warn "Skipping $1 - already installed"
}

# OS Detection and Platform Functions
detect_os() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    export DOTFILES_OS="macos"
    log_debug "Detected macOS operating system"
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    export DOTFILES_OS="linux"
    log_debug "Detected Linux operating system"
  else
    log_error "Unsupported OS: $OSTYPE"
    exit 1
  fi
}

is_macos() {
  [[ "${DOTFILES_OS:-}" == "macos" ]]
}

is_linux() {
  [[ "${DOTFILES_OS:-}" == "linux" ]]
}

config_banner() {
  log_banner "Configuring $1"
  log_info "Starting configuration of $1"
}

do_stow() {
  log_debug "Stowing configuration: $1"
  if stow -d "${DOTFILES_DIR}/configs" -t "${HOME}" "$1"; then
    log_success "Successfully stowed $1"
  else
    log_error "Failed to stow $1"
    return 1
  fi
}

# Enhanced validation function
validate_environment() {
  log_debug "Validating environment variables"
  validate_required_vars "DOTFILES_DIR" "HOME" "USER"
  log_debug "Environment validation complete"
}

# Enhanced installation wrapper using unified package management
safe_install() {
  local package_name="$1"
  local preferred_manager="${2:-auto}"
  local options="${3:-}"
  local manual_install_function="${4:-}"
  
  log_info "Attempting to install $package_name using unified package management"
  
  # Use the new unified package installation system
  if install_package "$package_name" "$preferred_manager" "$options" "$manual_install_function"; then
    log_success "$package_name installation completed successfully"
    return 0
  else
    log_error "Failed to install $package_name"
    return 1
  fi
}

# Backward compatibility function - enhanced to use unified package management
install_package_compat() {
  local package="$1"
  local preferred_manager="${2:-auto}"
  
  if is_package_installed "$package"; then
    log_warn "$package is already installed"
    return 0
  fi
  
  log_info "Installing $package using unified package management"
  install_package "$package" "$preferred_manager"
}

# Enhanced bulk package installation
install_multiple_packages() {
  local packages=("$@")
  
  log_banner "Installing Multiple Packages"
  log_info "Packages to install: ${packages[*]}"
  
  # Use the unified package management system
  install_packages "${packages[@]}"
}

# Package manager detection wrapper
get_available_package_managers() {
  detect_package_managers
}

# Package conflict checking wrapper
check_conflicts() {
  local package="$1"
  local conflicts="${2:-}"
  
  if [[ -n "$conflicts" ]]; then
    log_info "Checking package conflicts for $package"
    check_package_conflicts "$package" "$conflicts"
  fi
}

# Auto-initialize environment when sourced
if [[ -z "${DOTFILES_OS:-}" ]]; then
  detect_os
fi

# Validate environment if DOTFILES_DIR is set
if [[ -n "$DOTFILES_DIR" ]]; then
  validate_environment
fi

# Show debug info if enabled
debug_env

# Show package manager info in debug mode
if [[ "$DOTFILES_DEBUG" == "1" ]]; then
  show_package_manager_info
fi
