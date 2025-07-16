# macOS-specific functions for dotfiles installation

# Source core functions
source "${DOTFILES_DIR}/lib/dotfiles.sh"
source "${DOTFILES_DIR}/lib/bootstrap.sh"

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

# Enhanced brew install function with logging - now using unified package management
brew_install() {
	local package="$1"
	local options="${2:-}"
	
	log_info "Installing package via brew: $package"
	
	# Use unified package management with brew preference
	if install_package "$package" "brew" "$options"; then
		log_success "Successfully installed $package via brew"
		return 0
	else
		log_error "Failed to install $package via brew"
		return 1
	fi
}

# New unified package install function for macOS
macos_install_package() {
	local package="$1"
	local preferred_manager="${2:-auto}"
	local options="${3:-}"
	local manual_function="${4:-}"
	
	log_info "Installing macOS package: $package"
	
	# On macOS, prefer brew > manual
	local macos_preference="brew"
	if [[ "$preferred_manager" == "auto" ]]; then
		preferred_manager="$macos_preference"
	fi
	
	# Use unified package management system
	install_package "$package" "$preferred_manager" "$options" "$manual_function"
}

# Install multiple packages efficiently
macos_install_packages() {
	local packages=("$@")
	
	log_banner "Installing macOS Packages"
	log_info "Installing ${#packages[@]} packages: ${packages[*]}"
	
	# Use unified package management for bulk installation
	install_packages "${packages[@]}"
}

# Enhanced prerequisites installation with progress tracking
install_macos_prerequisites() {
	log_banner "Installing macOS Prerequisites"
	
	progress_start 2 "macOS Prerequisites Installation"
	
	# Step 1: Check/install Homebrew
	progress_step "Checking Homebrew installation"
	if ! command -v brew >/dev/null 2>&1; then
		log_info "Installing Homebrew"
		if /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
			log_success "Homebrew installed successfully"
		else
			log_error "Failed to install Homebrew"
			return 1
		fi
	else
		log_info "Homebrew already installed"
	fi
	
	# Step 2: Install core packages using unified package management
	progress_step "Installing core packages"
	local core_packages=(
		"git"
		"curl"
		"wget"
		"stow"
	)
	
	log_info "Installing core packages using unified package management"
	if macos_install_packages "${core_packages[@]}"; then
		log_success "All core packages installed successfully"
	else
		log_error "Some core packages failed to install"
		return 1
	fi
	
	progress_complete
	log_success "macOS prerequisites installation completed"
}

# Enhanced package validation using unified system
validate_macos_packages() {
	local packages=("$@")
	local missing=()
	
	log_debug "Validating macOS packages: ${packages[*]}"
	
	for package in "${packages[@]}"; do
		if ! is_package_installed "$package"; then
			missing+=("$package")
		fi
	done
	
	if [[ ${#missing[@]} -gt 0 ]]; then
		log_error "Missing required packages: ${missing[*]}"
		log_info "Install missing packages with: macos_install_packages ${missing[*]}"
		return 1
	fi
	
	log_success "All required packages are installed"
}

# Package manager preference for macOS
get_macos_package_manager_preference() {
	local available_managers
	mapfile -t available_managers < <(detect_package_managers)
	
	log_debug "Available package managers on macOS: ${available_managers[*]}"
	
	# macOS-specific preference order: brew > manual
	local macos_preference=("brew" "manual")
	
	for preferred in "${macos_preference[@]}"; do
		for available in "${available_managers[@]}"; do
			if [[ "$preferred" == "$available" ]]; then
				echo "$preferred"
				return 0
			fi
		done
	done
	
	# Fallback to first available
	if [[ ${#available_managers[@]} -gt 0 ]]; then
		echo "${available_managers[0]}"
	else
		log_error "No package managers available"
		return 1
	fi
}

# Install package with macOS-specific logic
install_macos_package_smart() {
	local package="$1"
	local conflicts="${2:-}"
	local options="${3:-}"
	local manual_function="${4:-}"
	
	log_info "Smart installation of $package on macOS"
	
	# Check conflicts first
	if [[ -n "$conflicts" ]]; then
		if ! check_package_conflicts "$package" "$conflicts"; then
			log_error "Package conflicts detected for $package"
			return 1
		fi
	fi
	
	# Get preferred package manager for macOS
	local preferred_manager
	preferred_manager=$(get_macos_package_manager_preference)
	
	log_debug "Using preferred package manager: $preferred_manager"
	
	# Install with unified system
	install_package "$package" "$preferred_manager" "$options" "$manual_function"
}

# Install macOS-specific applications
install_macos_app() {
	local app_name="$1"
	local cask_name="${2:-$app_name}"
	local options="${3:-}"
	
	log_info "Installing macOS application: $app_name"
	
	# Use brew cask for app installation
	if install_package "$cask_name" "brew" "--cask $options"; then
		log_success "$app_name installed successfully"
	else
		log_error "Failed to install $app_name"
		return 1
	fi
}

# Bulk install macOS applications
install_macos_apps() {
	local apps=("$@")
	
	log_banner "Installing macOS Applications"
	progress_start ${#apps[@]} "macOS Applications Installation"
	
	for app in "${apps[@]}"; do
		progress_step "Installing $app"
		if install_macos_app "$app"; then
			log_debug "✓ $app installation successful"
		else
			log_debug "✗ $app installation failed"
		fi
	done
	
	progress_complete
}

# macOS-specific system information
get_macos_info() {
	if [[ "$DOTFILES_DEBUG" == "1" ]]; then
		log_debug "=== macOS System Information ==="
		
		# macOS version
		local macos_version
		macos_version=$(sw_vers -productVersion 2>/dev/null || echo "unknown")
		log_debug "macOS Version: $macos_version"
		
		# Architecture
		log_debug "Architecture: $(uname -m)"
		
		# Package manager availability
		local managers
		mapfile -t managers < <(detect_package_managers)
		log_debug "Available package managers: ${managers[*]}"
		
		# Preferred package manager
		local preferred
		preferred=$(get_macos_package_manager_preference)
		log_debug "Preferred package manager: $preferred"
		
		# Homebrew info if available
		if command -v brew >/dev/null 2>&1; then
			local brew_version
			brew_version=$(brew --version | head -1)
			log_debug "Homebrew: $brew_version"
			
			local brew_prefix
			brew_prefix=$(brew --prefix)
			log_debug "Homebrew prefix: $brew_prefix"
		fi
		
		log_debug "=== End macOS System Information ==="
	fi
}

# Backward compatibility aliases
install_package_macos() {
	macos_install_package "$@"
}

bulk_install_macos() {
	macos_install_packages "$@"
}

cask_install() {
	local app="$1"
	install_macos_app "$app"
}

# Auto-initialize macOS environment when sourced
if is_macos; then
	log_debug "macOS library loaded with unified package management"
	get_macos_info
fi 
