#!/usr/bin/env bash
#
# Script Name: stow.sh
# Description: Install GNU Stow for configuration management
# Platform: linux
# Dependencies: apt package manager, Ubuntu/Debian distribution
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

# Install GNU Stow
install_stow() {
    log_banner "Installing GNU Stow"
    
    # Check if already installed
    if is_package_installed "stow"; then
        log_warn "GNU Stow is already installed"
        local version
        if is_dry_run; then
            version="(simulated version)"
        else
            version=$(stow --version 2>/dev/null | head -1 | grep -oE '[0-9]+\.[0-9]+' || echo "unknown")
        fi
        log_info "Current version: $version"
        return 0
    fi
    
    log_info "Installing GNU Stow for configuration management"
    log_info "GNU Stow creates symbolic links to manage dotfiles and configurations"
    
    if install_package "stow" "apt"; then
        log_success "GNU Stow installed successfully"
        
        # Verify installation
        if is_dry_run; then
            log_simulate "stow --version"
            log_info "Installed version: (simulated version)"
            log_info "GNU Stow is ready for configuration management"
        else
            if command -v stow >/dev/null 2>&1; then
                local version
                version=$(stow --version 2>/dev/null | head -1 | grep -oE '[0-9]+\.[0-9]+' || echo "unknown")
                log_info "Installed version: $version"
                log_info "GNU Stow is ready for configuration management"
            else
                log_error "GNU Stow installation verification failed"
                return 1
            fi
        fi
    else
        log_error "Failed to install GNU Stow"
        log_info "GNU Stow is required for dotfiles configuration management"
        log_info "Please install manually with: sudo apt install stow"
        if is_dry_run; then
            log_warn "In dry-run mode: continuing simulation despite failure"
        else
            return 1
        fi
    fi
}

# Validate stow functionality
validate_stow() {
    log_info "Validating GNU Stow functionality"
    
    if is_dry_run; then
        log_simulate "stow command availability check"
        log_simulate "stow --help"
        log_success "GNU Stow is working correctly (simulated)"
        log_debug "GNU Stow help command successful (simulated)"
    else
        # Check if stow command is available
        if ! command -v stow >/dev/null 2>&1; then
            log_error "GNU Stow command not found after installation"
            return 1
        fi
        
        # Check if we can get help (basic functionality test)
        if stow --help >/dev/null 2>&1; then
            log_success "GNU Stow is working correctly"
            log_debug "GNU Stow help command successful"
        else
            log_error "GNU Stow help command failed"
            return 1
        fi
    fi
    
    # Check if DOTFILES_DIR exists for future stow operations
    if [[ -d "$DOTFILES_DIR/configs" ]]; then
        log_info "Dotfiles configurations directory found: $DOTFILES_DIR/configs"
    else
        log_warn "Dotfiles configurations directory not found: $DOTFILES_DIR/configs"
        log_info "This is normal during initial setup - configs will be created later"
    fi
    
    return 0
}

# Main execution
main() {
    log_info "Starting GNU Stow installation"
    log_info "GNU Stow manages configuration files using symbolic links"
    
    # Validate dependencies before proceeding
    validate_dependencies || {
        log_error "Dependency validation failed"
        if is_dry_run; then
            log_warn "Continuing simulation despite dependency failures"
        else
            exit 1
        fi
    }
    
    # Install GNU Stow
    if install_stow; then
        # Validate the installation
        if validate_stow; then
            log_success "GNU Stow installation and validation completed successfully"
            log_info "Ready for dotfiles configuration management"
            
            if is_dry_run; then
                show_dry_run_summary
            fi
        else
            log_error "GNU Stow validation failed"
            if ! is_dry_run; then
                return 1
            fi
        fi
    else
        log_error "GNU Stow installation failed"
        if ! is_dry_run; then
            return 1
        fi
    fi
}

# Execute main function
main
