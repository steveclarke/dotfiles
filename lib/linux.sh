# Linux-specific functions for dotfiles installation

# Source core functions
source "${DOTFILES_DIR}/lib/dotfiles.sh"
source "${DOTFILES_DIR}/lib/bootstrap.sh"

# Enhanced apt install function with logging - now using unified package management
apt_install() {
	local package="$1"
	local options="${2:-}"
	
	log_info "Installing package via apt: $package"
	
	# Use unified package management with apt preference
	if install_package "$package" "apt" "$options"; then
		log_success "Successfully installed $package via apt"
		return 0
	else
		log_error "Failed to install $package via apt"
		return 1
	fi
}

# New unified package install function for Linux
linux_install_package() {
	local package="$1"
	local preferred_manager="${2:-auto}"
	local options="${3:-}"
	local manual_function="${4:-}"
	
	log_info "Installing Linux package: $package"
	
	# On Linux, prefer apt > snap > flatpak > manual
	local linux_preference="apt"
	if [[ "$preferred_manager" == "auto" ]]; then
		preferred_manager="$linux_preference"
	fi
	
	# Use unified package management system
	install_package "$package" "$preferred_manager" "$options" "$manual_function"
}

# Install multiple packages efficiently
linux_install_packages() {
	local packages=("$@")
	
	log_banner "Installing Linux Packages"
	log_info "Installing ${#packages[@]} packages: ${packages[*]}"
	
	# Use unified package management for bulk installation
	install_packages "${packages[@]}"
}

# Enhanced prerequisites installation with progress tracking
install_linux_prerequisites() {
	log_banner "Installing Linux Prerequisites"
	
	progress_start 2 "Linux Prerequisites Installation"
	
	# Step 1: Update package lists
	progress_step "Updating package lists"
	log_info "Updating apt package lists"
	if sudo apt update; then
		log_success "Package lists updated successfully"
	else
		log_error "Failed to update package lists"
		return 1
	fi
	
	# Step 2: Install core packages using unified package management
	progress_step "Installing core packages"
	local core_packages=(
		"git"
		"curl"
		"software-properties-common"
		"build-essential"
	)
	
	log_info "Installing core packages using unified package management"
	if linux_install_packages "${core_packages[@]}"; then
		log_success "All core packages installed successfully"
	else
		log_error "Some core packages failed to install"
		return 1
	fi
	
	progress_complete
	log_success "Linux prerequisites installation completed"
}

# Enhanced package validation using unified system
validate_linux_packages() {
	local packages=("$@")
	local missing=()
	
	log_debug "Validating Linux packages: ${packages[*]}"
	
	for package in "${packages[@]}"; do
		if ! is_package_installed "$package"; then
			missing+=("$package")
		fi
	done
	
	if [[ ${#missing[@]} -gt 0 ]]; then
		log_error "Missing required packages: ${missing[*]}"
		log_info "Install missing packages with: linux_install_packages ${missing[*]}"
		return 1
	fi
	
	log_success "All required packages are installed"
}

# Package manager preference for Linux
get_linux_package_manager_preference() {
	local available_managers
	mapfile -t available_managers < <(detect_package_managers)
	
	log_debug "Available package managers on Linux: ${available_managers[*]}"
	
	# Linux-specific preference order: apt > snap > flatpak > manual
	local linux_preference=("apt" "snap" "flatpak" "manual")
	
	for preferred in "${linux_preference[@]}"; do
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

# Install package with Linux-specific logic
install_linux_package_smart() {
	local package="$1"
	local conflicts="${2:-}"
	local options="${3:-}"
	local manual_function="${4:-}"
	
	log_info "Smart installation of $package on Linux"
	
	# Check conflicts first
	if [[ -n "$conflicts" ]]; then
		if ! check_package_conflicts "$package" "$conflicts"; then
			log_error "Package conflicts detected for $package"
			return 1
		fi
	fi
	
	# Get preferred package manager for Linux
	local preferred_manager
	preferred_manager=$(get_linux_package_manager_preference)
	
	log_debug "Using preferred package manager: $preferred_manager"
	
	# Install with unified system
	install_package "$package" "$preferred_manager" "$options" "$manual_function"
}

# Linux-specific system information
get_linux_info() {
	if [[ "$DOTFILES_DEBUG" == "1" ]]; then
		log_debug "=== Linux System Information ==="
		
		# Distribution information
		if [[ -f /etc/os-release ]]; then
			local distro_name
			distro_name=$(grep '^NAME=' /etc/os-release | cut -d= -f2 | tr -d '"')
			local distro_version
			distro_version=$(grep '^VERSION=' /etc/os-release | cut -d= -f2 | tr -d '"')
			log_debug "Distribution: $distro_name $distro_version"
		fi
		
		# Kernel information
		log_debug "Kernel: $(uname -r)"
		
		# Architecture
		log_debug "Architecture: $(uname -m)"
		
		# Package manager availability
		local managers
		mapfile -t managers < <(detect_package_managers)
		log_debug "Available package managers: ${managers[*]}"
		
		# Preferred package manager
		local preferred
		preferred=$(get_linux_package_manager_preference)
		log_debug "Preferred package manager: $preferred"
		
		log_debug "=== End Linux System Information ==="
	fi
}

# Backward compatibility aliases
install_package_linux() {
	linux_install_package "$@"
}

bulk_install_linux() {
	linux_install_packages "$@"
}

# Auto-initialize Linux environment when sourced
if is_linux; then
	log_debug "Linux library loaded with unified package management"
	get_linux_info
fi 
