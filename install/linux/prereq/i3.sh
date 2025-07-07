#!/usr/bin/env bash
#
# Script Name: i3.sh
# Description: Install i3 window manager prerequisites and related tools
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
SCRIPT_DEPENDS_ENV=("DOTFILES_DIR" "DOTFILES_CONFIG_I3")
SCRIPT_DEPENDS_PACKAGES=("ca-certificates")

# Define i3 related packages
declare -a I3_PACKAGES=(
    "polybar"       # Status bar for i3
    "rofi"          # Application launcher and window switcher
    "picom"         # Compositor for transparency and effects
    "redshift"      # Blue light filter
    "xautolock"     # Automatic screen locking
    "numlockx"      # Numlock management
    "playerctl"     # Media player control
    "yad"           # Yet Another Dialog - GUI dialogs
)

# Install i3 prerequisites
install_i3_prerequisites() {
    log_banner "Installing i3 Window Manager Requirements"
    
    log_info "Installing tools and utilities for i3 window manager"
    log_info "These packages provide status bar, compositor, and desktop utilities"
    
    progress_start 2 "i3 Prerequisites Installation"
    
    # Step 1: Install i3 packages
    progress_step "Installing i3 window manager packages"
    
    local failed_packages=()
    
    for package in "${I3_PACKAGES[@]}"; do
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
        log_success "All i3 packages installed successfully"
    else
        log_warn "Some packages failed to install: ${failed_packages[*]}"
        log_info "i3 may still work, but some features might be missing"
    fi
    
    # Step 2: Validate installation
    progress_step "Validating i3 installation"
    if validate_i3_installation; then
        log_success "i3 installation validation completed"
    else
        log_warn "i3 installation validation had warnings"
    fi
    
    progress_complete
    
    log_success "i3 prerequisites installation completed!"
    log_info "Installed i3 components:"
    log_info "  • Polybar - Modern status bar with customizable modules"
    log_info "  • Rofi - Application launcher and window switcher"
    log_info "  • Picom - Compositor for transparency and visual effects"
    log_info "  • Redshift - Blue light filter for eye comfort"
    log_info "  • Xautolock - Automatic screen locking"
    log_info "  • Playerctl - Media player control from command line"
    log_info "  • Additional utilities for desktop management"
}

# Validate i3 installation
validate_i3_installation() {
    log_info "Validating i3 installation"
    
    # Check critical i3 utilities
    local critical_commands=("polybar" "rofi" "picom" "redshift")
    local missing_commands=()
    
    for cmd in "${critical_commands[@]}"; do
        if command -v "$cmd" >/dev/null 2>&1; then
            log_debug "✓ $cmd is available"
        else
            missing_commands+=("$cmd")
            log_debug "✗ $cmd is not available"
        fi
    done
    
    if [[ ${#missing_commands[@]} -eq 0 ]]; then
        log_success "All critical i3 utilities are available"
    else
        log_warn "Some i3 utilities are missing: ${missing_commands[*]}"
    fi
    
    # Check if i3 configuration directory exists
    local i3_config_dir="$HOME/.config/i3"
    if [[ -d "$i3_config_dir" ]]; then
        log_info "i3 configuration directory exists: $i3_config_dir"
    else
        log_info "i3 configuration directory not found (will be created when i3 runs)"
    fi
    
    # Check if dotfiles i3 config exists
    local dotfiles_i3_config="$DOTFILES_DIR/configs/i3"
    if [[ -d "$dotfiles_i3_config" ]]; then
        log_info "Dotfiles i3 configuration found: $dotfiles_i3_config"
    else
        log_warn "Dotfiles i3 configuration not found: $dotfiles_i3_config"
    fi
    
    return 0
}

# Show i3 usage information
show_i3_usage() {
    log_info "i3 Window Manager Usage:"
    log_info "  • Start i3: Select i3 from your display manager login screen"
    log_info "  • Default mod key: Alt (can be changed to Super/Windows key)"
    log_info "  • Open terminal: Mod+Enter"
    log_info "  • Application launcher: Mod+d (rofi)"
    log_info "  • Configuration: ~/.config/i3/config"
    log_info ""
    log_info "Essential i3 shortcuts:"
    log_info "  • Mod+Shift+q - Close window"
    log_info "  • Mod+f - Toggle fullscreen"
    log_info "  • Mod+Shift+Space - Toggle floating/tiling"
    log_info "  • Mod+1-9 - Switch to workspace"
    log_info "  • Mod+Shift+1-9 - Move window to workspace"
    log_info ""
    log_info "Configuration files:"
    log_info "  • i3: ~/.config/i3/config"
    log_info "  • Polybar: ~/.config/polybar/"
    log_info "  • Rofi: ~/.config/rofi/"
    log_info "  • Picom: ~/.config/picom/"
}

# Main execution
main() {
    log_info "Starting i3 prerequisites installation"
    
    # Check if i3 is enabled in configuration
    local i3_enabled="${DOTFILES_CONFIG_I3:-false}"
    if [[ "${i3_enabled^^}" != "TRUE" ]]; then
        log_info "i3 is not enabled in configuration (DOTFILES_CONFIG_I3=${i3_enabled})"
        log_info "Skipping i3 prerequisites installation"
        log_info "To enable i3, set DOTFILES_CONFIG_I3=true in your configuration"
        return 0
    fi
    
    log_info "i3 is enabled in configuration - proceeding with installation"
    log_info "Installing i3 window manager prerequisites and utilities"
    
    # Install prerequisites
    if install_i3_prerequisites; then
        log_success "i3 prerequisites installation completed successfully"
        
        # Show usage information
        show_i3_usage
        
        log_info "Your system is now ready for i3 window manager"
        log_info "Note: You'll need to install i3 itself if not already installed"
        log_info "Install i3: sudo apt install i3"
    else
        log_error "i3 prerequisites installation failed"
        return 1
    fi
}

# Execute main function
main
