#!/usr/bin/env bash
#
# Script Name: appimage.sh
# Description: Install AppImage prerequisites and support libraries
# Platform: linux
# Dependencies: apt package manager, Ubuntu/Debian distribution
#

# Exit on error, undefined variables, and pipe failures
set -euo pipefail

# Source required libraries
source "${DOTFILES_DIR}/lib/linux.sh"

# Dependency declarations
SCRIPT_DEPENDS_COMMANDS=("apt" "dpkg")
SCRIPT_DEPENDS_PLATFORM=("linux")
SCRIPT_DEPENDS_DISTRO=("ubuntu")
SCRIPT_DEPENDS_ENV=("DOTFILES_DIR")
SCRIPT_DEPENDS_PACKAGES=("ca-certificates")

# Define AppImage prerequisite packages
declare -a APPIMAGE_PREREQS=(
    "libfuse2"          # FUSE library for AppImage mounting
    "libxi6"            # X11 Input extension library
    "libxrender1"       # X Rendering Extension library
    "mesa-utils"        # OpenGL utilities
    "libfontconfig1"    # Font configuration library (corrected package name)
    "libgtk-3-bin"      # GTK3 binaries and utilities
)

# Install AppImage prerequisites
install_appimage_prerequisites() {
    log_banner "Installing AppImage Prerequisites"
    
    log_info "Installing libraries required for AppImage support"
    log_info "AppImages are portable application packages that run on most Linux distributions"
    
    progress_start 2 "AppImage Prerequisites Installation"
    
    # Step 1: Install prerequisite packages
    progress_step "Installing AppImage support libraries"
    
    local failed_packages=()
    
    for package in "${APPIMAGE_PREREQS[@]}"; do
        if is_package_installed "$package"; then
            log_debug "✓ $package already installed"
        else
            log_info "Installing $package..."
            if install_package "$package" "apt"; then
                log_debug "✓ $package installed successfully"
            else
                log_warn "✗ Failed to install $package"
                failed_packages+=("$package")
            fi
        fi
    done
    
    # Report installation results
    if [[ ${#failed_packages[@]} -eq 0 ]]; then
        log_success "All AppImage prerequisites installed successfully"
    else
        log_warn "Some packages failed to install: ${failed_packages[*]}"
        log_info "AppImages may still work, but some applications might have issues"
    fi
    
    # Step 2: Validate installation
    progress_step "Validating AppImage support"
    if validate_appimage_support; then
        log_success "AppImage support validation completed"
    else
        log_warn "AppImage support validation had warnings"
    fi
    
    progress_complete
    
    log_success "AppImage prerequisites installation completed!"
    log_info "AppImage capabilities:"
    log_info "  • FUSE support for mounting AppImage files"
    log_info "  • X11 libraries for graphical applications"
    log_info "  • OpenGL support for graphics-intensive apps"
    log_info "  • Font configuration for proper text rendering"
    log_info "  • GTK3 support for modern Linux applications"
}

# Validate AppImage support
validate_appimage_support() {
    log_info "Validating AppImage support"
    
    # Check if FUSE is available (most critical for AppImages)
    if [[ -c /dev/fuse ]]; then
        log_success "FUSE device is available (/dev/fuse)"
    else
        log_warn "FUSE device not found - AppImages may not work properly"
        log_info "Try: sudo modprobe fuse"
    fi
    
    # Check if libfuse2 is installed (required for many AppImages)
    if is_package_installed "libfuse2"; then
        log_success "libfuse2 is installed"
    else
        log_warn "libfuse2 not found - some AppImages may not run"
    fi
    
    # Check for common library files
    local critical_libs=(
        "/usr/lib/x86_64-linux-gnu/libfuse.so.2"
        "/usr/lib/x86_64-linux-gnu/libXi.so.6"
        "/usr/lib/x86_64-linux-gnu/libXrender.so.1"
    )
    
    local missing_libs=()
    for lib in "${critical_libs[@]}"; do
        if [[ -f "$lib" ]]; then
            log_debug "✓ Found: $lib"
        else
            missing_libs+=("$lib")
            log_debug "✗ Missing: $lib"
        fi
    done
    
    if [[ ${#missing_libs[@]} -eq 0 ]]; then
        log_success "All critical AppImage libraries are available"
    else
        log_warn "Some AppImage libraries are missing: ${#missing_libs[@]} files"
        log_debug "Missing: ${missing_libs[*]}"
    fi
    
    return 0
}

# Show AppImage usage information
show_appimage_usage() {
    log_info "AppImage Usage:"
    log_info "  1. Download an AppImage file (e.g., application.AppImage)"
    log_info "  2. Make it executable: chmod +x application.AppImage"
    log_info "  3. Run it: ./application.AppImage"
    log_info ""
    log_info "Optional AppImage management tools:"
    log_info "  • AppImageLauncher - GUI for managing AppImages"
    log_info "  • appimaged - Daemon for desktop integration"
    log_info ""
    log_info "Popular AppImage applications:"
    log_info "  • Obsidian, Discord, Telegram, Signal"
    log_info "  • Development tools, media editors, games"
    log_info "  • Download from official app websites or AppImageHub.com"
}

# Main execution
main() {
    log_info "Starting AppImage prerequisites installation"
    log_info "AppImages provide portable application packages for Linux"
    
    # Install prerequisites
    if install_appimage_prerequisites; then
        log_success "AppImage prerequisites installation completed successfully"
        
        # Show usage information
        show_appimage_usage
        
        log_info "Your system is now ready to run AppImage applications"
    else
        log_error "AppImage prerequisites installation failed"
        return 1
    fi
}

# Execute main function
main
