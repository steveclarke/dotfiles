# Core cross-platform functions for dotfiles installation

# Source logging and error handling functions
source "${DOTFILES_DIR}/lib/logging.sh"

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
  [[ "$DOTFILES_OS" == "macos" ]]
}

is_linux() {
  [[ "$DOTFILES_OS" == "linux" ]]
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

# Enhanced installation wrapper
safe_install() {
  local package_name="$1"
  local install_function="$2"
  
  log_info "Attempting to install $package_name"
  
  if is_installed "$package_name"; then
    log_warn "$package_name is already installed"
    return 0
  fi
  
  if [[ -n "$install_function" ]] && declare -f "$install_function" > /dev/null; then
    log_debug "Calling install function: $install_function"
    "$install_function"
    log_success "$package_name installed successfully"
  else
    log_error "Install function '$install_function' not found for $package_name"
    return 1
  fi
}

# Auto-initialize environment when sourced
if [[ -z "$DOTFILES_OS" ]]; then
  detect_os
fi

# Validate environment if DOTFILES_DIR is set
if [[ -n "$DOTFILES_DIR" ]]; then
  validate_environment
fi

# Show debug info if enabled
debug_env
