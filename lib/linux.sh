# Linux-specific functions for dotfiles installation

# Source core functions
source "${DOTFILES_DIR}/lib/dotfiles.sh"
source "${DOTFILES_DIR}/lib/bootstrap.sh"

# Enhanced apt install function with logging
apt_install() {
	local package="$1"
	log_info "Installing package via apt: $package"
	
	if ! command -v apt >/dev/null 2>&1; then
		log_error "apt command not found - this script requires Ubuntu/Debian"
		return 1
	fi
	
	log_debug "Running: sudo apt install -y $package"
	if sudo apt install -y "$package"; then
		log_success "Successfully installed $package"
	else
		log_error "Failed to install $package via apt"
		return 1
	fi
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
	
	# Step 2: Install core packages
	progress_step "Installing core packages"
	local core_packages=(
		"git"
		"curl"
		"software-properties-common"
		"build-essential"
	)
	
	log_info "Installing core packages: ${core_packages[*]}"
	for package in "${core_packages[@]}"; do
		if apt_install "$package"; then
			log_debug "✓ $package installed"
		else
			log_error "✗ Failed to install $package"
			return 1
		fi
	done
	
	progress_complete
	log_success "Linux prerequisites installation completed"
}

# Enhanced package validation
validate_linux_packages() {
	local packages=("$@")
	local missing=()
	
	log_debug "Validating Linux packages: ${packages[*]}"
	
	for package in "${packages[@]}"; do
		if ! dpkg -l "$package" >/dev/null 2>&1; then
			missing+=("$package")
		fi
	done
	
	if [[ ${#missing[@]} -gt 0 ]]; then
		log_error "Missing required packages: ${missing[*]}"
		log_info "Install missing packages with: sudo apt install ${missing[*]}"
		return 1
	fi
	
	log_success "All required packages are installed"
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
		
		# Available package managers
		local package_managers=()
		command -v apt >/dev/null 2>&1 && package_managers+=("apt")
		command -v snap >/dev/null 2>&1 && package_managers+=("snap")
		command -v flatpak >/dev/null 2>&1 && package_managers+=("flatpak")
		log_debug "Package managers: ${package_managers[*]}"
		
		log_debug "=== End Linux System Information ==="
	fi
}

# Auto-initialize Linux environment when sourced
if is_linux; then
	log_debug "Linux library loaded"
	get_linux_info
fi 
