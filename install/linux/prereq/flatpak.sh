#!/usr/bin/env bash
#
# Script Name: flatpak.sh
# Description: Install Flatpak package manager and configure Flathub repository
# Platform: linux
# Dependencies: apt package manager, internet connection for repository setup
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

# Install Flatpak and related components
install_flatpak() {
    log_banner "Installing Flatpak Package Manager"
    
    progress_start 4 "Flatpak Installation"
    
    # Step 1: Install Flatpak
    progress_step "Installing Flatpak package manager"
    if is_package_installed "flatpak"; then
        log_warn "Flatpak is already installed"
    else
        if install_package "flatpak" "apt"; then
            log_success "Flatpak installed successfully"
        else
            log_error "Failed to install Flatpak"
            return 1
        fi
    fi
    
    # Step 2: Install GNOME Software Flatpak plugin
    progress_step "Installing GNOME Software Flatpak plugin"
    if is_package_installed "gnome-software-plugin-flatpak"; then
        log_warn "GNOME Software Flatpak plugin is already installed"
    else
        if install_package "gnome-software-plugin-flatpak" "apt"; then
            log_success "GNOME Software Flatpak plugin installed successfully"
        else
            log_warn "Failed to install GNOME Software Flatpak plugin (non-critical)"
            log_info "This is only needed if you use GNOME Software for GUI package management"
        fi
    fi
    
    # Step 3: Add Flathub repository
    progress_step "Adding Flathub repository"
    if flatpak remote-list | grep -q "flathub"; then
        log_warn "Flathub repository is already configured"
    else
        log_info "Adding Flathub repository (primary Flatpak app source)"
        if sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo; then
            log_success "Flathub repository added successfully"
        else
            log_error "Failed to add Flathub repository"
            log_info "You can add it manually later with:"
            log_info "sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo"
            return 1
        fi
    fi
    
    # Step 4: Verify installation
    progress_step "Verifying Flatpak installation"
    if validate_flatpak_installation; then
        log_success "Flatpak verification completed"
    else
        log_error "Flatpak verification failed"
        return 1
    fi
    
    progress_complete
    
    log_success "Flatpak installation completed successfully!"
    log_info "Flatpak capabilities:"
    log_info "  • Install sandboxed applications from Flathub"
    log_info "  • Automatic dependency management"
    log_info "  • System-level and user-level application installation"
    log_info "  • Integration with GNOME Software (if available)"
}

# Validate Flatpak installation
validate_flatpak_installation() {
    log_info "Validating Flatpak installation"
    
    # Check if flatpak command is available
    if ! command -v flatpak >/dev/null 2>&1; then
        log_error "Flatpak command not found after installation"
        return 1
    fi
    
    # Check Flatpak version
    local version
    if version=$(flatpak --version 2>/dev/null); then
        log_info "Flatpak version: $version"
    else
        log_error "Could not determine Flatpak version"
        return 1
    fi
    
    # Check if Flathub repository is configured
    if flatpak remote-list | grep -q "flathub"; then
        log_success "Flathub repository is properly configured"
        
        # Get repository details
        local repo_url
        repo_url=$(flatpak remote-list --show-details | grep -A5 "flathub" | grep "URL:" | awk '{print $2}' || echo "unknown")
        log_debug "Flathub URL: $repo_url"
    else
        log_error "Flathub repository not found"
        return 1
    fi
    
    # Test basic Flatpak functionality
    log_debug "Testing Flatpak remote list functionality"
    if flatpak remote-list >/dev/null 2>&1; then
        log_debug "✓ Flatpak remote list command working"
    else
        log_error "Flatpak remote list command failed"
        return 1
    fi
    
    return 0
}

# Show usage information
show_flatpak_usage() {
    log_info "Flatpak Usage Examples:"
    log_info "  • Search apps:        flatpak search <app-name>"
    log_info "  • Install app:        flatpak install flathub <app-id>"
    log_info "  • List installed:     flatpak list"
    log_info "  • Update apps:        flatpak update"
    log_info "  • Uninstall app:      flatpak uninstall <app-id>"
    log_info ""
    log_info "Popular applications available:"
    log_info "  • VSCode:             flatpak install flathub com.visualstudio.code"
    log_info "  • Firefox:            flatpak install flathub org.mozilla.firefox"
    log_info "  • LibreOffice:        flatpak install flathub org.libreoffice.LibreOffice"
    log_info "  • Spotify:            flatpak install flathub com.spotify.Client"
}

# Main execution
main() {
    log_info "Starting Flatpak package manager installation"
    log_info "Flatpak provides sandboxed application installation and management"
    
    # Install and configure Flatpak
    if install_flatpak; then
        log_success "Flatpak installation and configuration completed successfully"
        
        # Show usage information
        show_flatpak_usage
        
        log_info "Flatpak is now ready for installing sandboxed applications"
        log_info "Note: You may need to restart your session for GUI integration"
    else
        log_error "Flatpak installation failed"
        return 1
    fi
}

# Execute main function
main
