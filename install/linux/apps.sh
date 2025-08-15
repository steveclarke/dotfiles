#!/usr/bin/env bash
#
# Script Name: apps.sh
# Description: Install Linux GUI applications by orchestrating all scripts in apps/ directory
# Platform: linux
# Dependencies: .dotfilesrc, GNOME settings, application installation scripts
#

# Exit on error, undefined variables, and pipe failures
set -euo pipefail

# Source required libraries
source "${HOME}"/.dotfilesrc
source "${DOTFILES_DIR}"/lib/linux.sh

# Dependency declarations
SCRIPT_DEPENDS_COMMANDS=("apt" "dpkg")
SCRIPT_DEPENDS_PLATFORM=("linux")
SCRIPT_DEPENDS_DISTRO=("ubuntu")
SCRIPT_DEPENDS_ENV=("DOTFILES_DIR")

# Get GUI application installation scripts
get_app_scripts() {
    local scripts=()
    
    # Find all GUI application installation scripts
    for installer in "${DOTFILES_DIR}"/install/linux/apps/*.sh; do
        if [[ -f "$installer" ]]; then
            scripts+=("$installer")
        fi
    done
    
    # Sort scripts for consistent installation order
    IFS=$'\n' scripts=($(sort <<<"${scripts[*]}"))
    unset IFS
    
    printf '%s\n' "${scripts[@]}"
}

# Configure GNOME settings to prevent sleep during installation
configure_gnome_for_installation() {
    log_info "Configuring GNOME settings for uninterrupted installation"
    
    # Check if GNOME is available
    if ! command -v gsettings >/dev/null 2>&1; then
        log_warn "gsettings not available - skipping GNOME configuration"
        return 0
    fi
    
    # Store original settings for restoration
    local original_lock_enabled
    local original_idle_delay
    
    original_lock_enabled=$(gsettings get org.gnome.desktop.screensaver lock-enabled 2>/dev/null || echo "true")
    original_idle_delay=$(gsettings get org.gnome.desktop.session idle-delay 2>/dev/null || echo "300")
    
    # Store original values in temporary files
    echo "$original_lock_enabled" > /tmp/dotfiles_original_lock_enabled
    echo "$original_idle_delay" > /tmp/dotfiles_original_idle_delay
    
    # Disable screensaver and sleep during installation
    log_info "Disabling screensaver and idle sleep during installation"
    gsettings set org.gnome.desktop.screensaver lock-enabled false
    gsettings set org.gnome.desktop.session idle-delay 0
    
    log_success "GNOME settings configured for installation"
}

# Restore original GNOME settings
restore_gnome_settings() {
    log_info "Restoring original GNOME settings"
    
    # Check if GNOME is available
    if ! command -v gsettings >/dev/null 2>&1; then
        log_warn "gsettings not available - skipping GNOME restoration"
        return 0
    fi
    
    # Restore original settings
    if [[ -f /tmp/dotfiles_original_lock_enabled ]]; then
        local original_lock_enabled
        original_lock_enabled=$(cat /tmp/dotfiles_original_lock_enabled)
        gsettings set org.gnome.desktop.screensaver lock-enabled "$original_lock_enabled"
        rm -f /tmp/dotfiles_original_lock_enabled
    else
        # Default fallback
        gsettings set org.gnome.desktop.screensaver lock-enabled true
    fi
    
    if [[ -f /tmp/dotfiles_original_idle_delay ]]; then
        local original_idle_delay
        original_idle_delay=$(cat /tmp/dotfiles_original_idle_delay)
        gsettings set org.gnome.desktop.session idle-delay "$original_idle_delay"
        rm -f /tmp/dotfiles_original_idle_delay
    else
        # Default fallback (5 minutes)
        gsettings set org.gnome.desktop.session idle-delay 300
    fi
    
    log_success "GNOME settings restored to original values"
}

# Install GUI applications orchestration
install_gui_applications() {
    log_banner "Installing Linux GUI Applications"
    
    # Get list of GUI application installation scripts
    local app_scripts
    readarray -t app_scripts < <(get_app_scripts)
    
    if [[ ${#app_scripts[@]} -eq 0 ]]; then
        log_warn "No GUI application installation scripts found in ${DOTFILES_DIR}/install/linux/apps/"
        return 0
    fi
    
    log_info "Found ${#app_scripts[@]} GUI application installation scripts"
    
    # Configure GNOME settings for installation
    configure_gnome_for_installation
    
    # Start progress tracking
    progress_start ${#app_scripts[@]} "GUI Applications Installation"
    
    local successful_installs=0
    local failed_installs=0
    local failed_scripts=()
    
    # Execute each GUI application installation script
    for installer in "${app_scripts[@]}"; do
        local script_name
        script_name=$(basename "$installer")
        
        progress_step "Installing GUI app: $script_name"
        log_info "Running GUI app installer: $script_name"
        
        # Execute the installer script
        if bash "$installer"; then
            log_success "✓ $script_name completed successfully"
            ((successful_installs++))
        else
            log_error "✗ $script_name failed"
            failed_scripts+=("$script_name")
            ((failed_installs++))
        fi
    done
    
    progress_complete
    
    # Restore GNOME settings
    restore_gnome_settings
    
    # Report installation results
    log_info "GUI Applications Installation Summary:"
    log_info "  • Successful: $successful_installs"
    log_info "  • Failed: $failed_installs"
    log_info "  • Total: ${#app_scripts[@]}"
    
    if [[ $failed_installs -eq 0 ]]; then
        log_success "All GUI applications installed successfully!"
    else
        log_warn "Some GUI applications failed to install: ${failed_scripts[*]}"
        log_info "Check the logs above for specific error details"
    fi
    
    return $failed_installs
}

# Show installed GUI applications
show_installed_gui_apps() {
    log_info "Verifying installed GUI applications:"
    
    # Common GUI applications that might be installed
    local common_gui_apps=(
        "code" "chrome" "firefox" "discord" "spotify" "obs" "vlc" "gimp" 
        "libreoffice" "thunderbird" "audacity" "handbrake" "pinta" "flameshot"
        "telegram" "obsidian" "postman" "deja-dup" "gnome-tweaks"
    )
    
    local installed_apps=()
    local missing_apps=()
    
    for app in "${common_gui_apps[@]}"; do
        if command -v "$app" >/dev/null 2>&1; then
            installed_apps+=("$app")
        else
            missing_apps+=("$app")
        fi
    done
    
    if [[ ${#installed_apps[@]} -gt 0 ]]; then
        log_info "Available GUI applications: ${installed_apps[*]}"
    fi
    
    if [[ ${#missing_apps[@]} -gt 0 ]]; then
        log_debug "Not installed: ${missing_apps[*]}"
    fi
}

# Check if reboot is recommended
check_reboot_recommendation() {
    log_info "Checking if system reboot is recommended"
    
    # Check if there are any pending kernel updates or system changes
    local reboot_required=false
    
    # Check for reboot-required flag
    if [[ -f /var/run/reboot-required ]]; then
        reboot_required=true
        log_warn "System reboot is required for kernel or system updates"
    fi
    
    # Check for newly installed desktop files that might need session refresh
    local new_desktop_files
    new_desktop_files=$(find /usr/share/applications /var/lib/flatpak/exports/share/applications ~/.local/share/applications -name "*.desktop" -newer /var/log/lastlog 2>/dev/null | wc -l)
    
    if [[ $new_desktop_files -gt 0 ]]; then
        log_info "New desktop applications installed - session refresh recommended"
        reboot_required=true
    fi
    
    if [[ $reboot_required == true ]]; then
        log_warn "System reboot is recommended for all changes to take effect"
        log_info "You can reboot now or later at your convenience"
        log_info "Command: sudo reboot"
    else
        log_info "No reboot required - all changes should be active"
    fi
}

# Main execution
main() {
    log_info "Starting Linux GUI applications installation orchestration"
    log_info "This will install all GUI applications defined in ${DOTFILES_DIR}/install/linux/apps/"
    
    # Install GUI applications
    if install_gui_applications; then
        log_success "GUI applications installation orchestration completed successfully"
        
        # Show verification
        show_installed_gui_apps
        
        # Check if reboot is recommended
        check_reboot_recommendation
        
        log_info "All GUI applications are now ready for use"
    else
        log_error "GUI applications installation orchestration completed with errors"
        log_info "Some GUI applications may not be available - check the logs above"
        return 1
    fi
}

# Execute main function
main
