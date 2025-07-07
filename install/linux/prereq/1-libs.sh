#!/usr/bin/env bash
#
# Script Name: 1-libs.sh
# Description: Install essential development libraries and tools
# Platform: linux
# Dependencies: apt package manager, Ubuntu/Debian distribution
#
# Note: This must run first (hence the "1-" prefix) to provide dependencies 
# for other installations and development tools.
#

# Exit on error, undefined variables, and pipe failures
set -euo pipefail

# Source required libraries
source "${DOTFILES_DIR}/lib/linux.sh"

# Parse command line arguments (includes --dry-run, --debug, etc.)
parse_script_arguments "$@"

# Show dry-run information if enabled
show_dry_run_info

# Dependency declarations
SCRIPT_DEPENDS_COMMANDS=("apt" "dpkg")
SCRIPT_DEPENDS_PLATFORM=("linux")
SCRIPT_DEPENDS_DISTRO=("ubuntu")
SCRIPT_DEPENDS_ENV=("DOTFILES_DIR")
SCRIPT_DEPENDS_PACKAGES=("ca-certificates")

# Define package groups for better organization
declare -a ESSENTIAL_PACKAGES=(
    "curl"               # Data transfer tool
    "wget"               # Web content retriever  
    "git"                # Version control system
    "vim"                # Text editor
    "unzip"              # Archive extraction tool
    "software-properties-common"  # Repository management
    "apt-transport-https"         # HTTPS repository support
    "ca-certificates"            # SSL certificates
    "gnupg"              # GNU Privacy Guard
    "lsb-release"        # LSB information
)

declare -a BUILD_TOOLS=(
    "build-essential"    # Compilation tools (gcc, make, etc.)
    "cmake"              # Cross-platform build system
    "pkg-config"         # Package configuration tool
    "libtool"            # Generic library support script
    "autotools-dev"      # Tools for building Debian packages
    "automake"           # Tool for generating Makefile.in
    "autoconf"           # Tool for generating configure scripts
)

declare -a DEVELOPMENT_LIBS=(
    "libssl-dev"         # SSL development libraries
    "libffi-dev"         # Foreign function interface library
    "libreadline-dev"    # Readline library for interactive programs
    "libbz2-dev"         # Bzip2 compression library
    "libsqlite3-dev"     # SQLite3 development files
    "libncurses5-dev"    # Terminal control library
    "libgdbm-dev"        # GNU database manager
    "libnss3-dev"        # Network Security Services
    "libxml2-dev"        # XML parsing library
    "libxslt1-dev"       # XSLT processing library
    "libyaml-dev"        # YAML parsing library
    "zlib1g-dev"         # Compression library
)

declare -a PYTHON_DEPS=(
    "python3"            # Python 3 interpreter
    "python3-pip"        # Python package installer
    "python3-dev"        # Python development headers
    "python3-venv"       # Virtual environment support
    "python3-setuptools" # Python package development tools
)

declare -a SYSTEM_UTILS=(
    "htop"               # Interactive process viewer
    "tree"               # Directory tree display
    "jq"                 # JSON processor
    "bc"                 # Basic calculator
    "xz-utils"           # XZ compression utilities
    "p7zip-full"         # 7-Zip file archiver
)

# Validate dependencies before proceeding
main() {
    log_banner "Installing Essential Development Libraries and Tools"
    
    # Validate all dependencies
    validate_dependencies || {
        log_error "Dependency validation failed"
        if is_dry_run; then
            log_warn "Continuing simulation despite dependency failures"
        else
            exit 1
        fi
    }
    
    # Update package cache
    update_package_cache
    
    # Install package groups
    install_package_groups
    
    # Verify installations
    verify_installations
    
    # Show summary
    show_installation_summary
}

# Update system package cache
update_package_cache() {
    log_step 1 "Updating package cache"
    
    if is_dry_run; then
        log_dry_run "update package cache"
        log_simulate "sudo apt update"
    else
        if sudo apt update; then
            log_success "Package cache updated successfully"
        else
            log_error "Failed to update package cache"
            exit 1
        fi
    fi
}

# Install all package groups
install_package_groups() {
    log_step 2 "Installing package groups"
    
    # Calculate total packages for progress tracking
    local total_packages=0
    total_packages=$((${#ESSENTIAL_PACKAGES[@]} + ${#BUILD_TOOLS[@]} + ${#DEVELOPMENT_LIBS[@]} + ${#PYTHON_DEPS[@]} + ${#SYSTEM_UTILS[@]}))
    
    progress_start "$total_packages" "Installing essential packages"
    
    # Install each group
    install_package_group "Essential Packages" ESSENTIAL_PACKAGES[@]
    install_package_group "Build Tools" BUILD_TOOLS[@]
    install_package_group "Development Libraries" DEVELOPMENT_LIBS[@]
    install_package_group "Python Dependencies" PYTHON_DEPS[@]
    install_package_group "System Utilities" SYSTEM_UTILS[@]
    
    progress_complete
}

# Install a specific package group
install_package_group() {
    local group_name="$1"
    local -n packages=$2
    
    log_info "Installing: $group_name"
    
    for package in "${packages[@]}"; do
        progress_step "Installing $package"
        
        if is_package_installed "$package"; then
            log_debug "✓ $package already installed"
        else
            if install_package "$package" "apt"; then
                log_debug "✓ $package installed successfully"
            else
                log_warn "✗ Failed to install $package"
                if ! is_dry_run; then
                    log_info "Continuing with remaining packages..."
                fi
            fi
        fi
    done
}

# Verify critical installations
verify_installations() {
    log_step 3 "Verifying critical installations"
    
    local critical_tools=("curl" "wget" "git" "build-essential" "python3")
    local missing_tools=()
    
    for tool in "${critical_tools[@]}"; do
        if is_package_installed "$tool"; then
            log_debug "✓ $tool verified"
        else
            missing_tools+=("$tool")
            log_warn "✗ $tool not found"
        fi
    done
    
    if [[ ${#missing_tools[@]} -eq 0 ]]; then
        log_success "All critical tools verified successfully"
    else
        log_error "Missing critical tools: ${missing_tools[*]}"
        if is_dry_run; then
            log_warn "In dry-run mode: verification failures are simulated"
        else
            log_info "Please install missing tools manually or re-run the script"
            exit 1
        fi
    fi
}

# Show installation summary
show_installation_summary() {
    log_step 4 "Installation Summary"
    
    local total_packages=0
    total_packages=$((${#ESSENTIAL_PACKAGES[@]} + ${#BUILD_TOOLS[@]} + ${#DEVELOPMENT_LIBS[@]} + ${#PYTHON_DEPS[@]} + ${#SYSTEM_UTILS[@]}))
    
    log_success "Essential development environment setup completed"
    log_info "Package groups installed:"
    log_info "  • Essential Packages: ${#ESSENTIAL_PACKAGES[@]} packages"
    log_info "  • Build Tools: ${#BUILD_TOOLS[@]} packages"  
    log_info "  • Development Libraries: ${#DEVELOPMENT_LIBS[@]} packages"
    log_info "  • Python Dependencies: ${#PYTHON_DEPS[@]} packages"
    log_info "  • System Utilities: ${#SYSTEM_UTILS[@]} packages"
    log_info "Total packages processed: $total_packages"
    
    if is_dry_run; then
        show_dry_run_summary
    fi
}

# Run main function
main
