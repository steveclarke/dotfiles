#!/usr/bin/env bash
#
# Script Name: desktop-entries.sh
# Description: Install custom desktop entries by orchestrating all scripts in desktop-entries/ directory
# Platform: linux
# Dependencies: .dotfilesrc, desktop entry creation scripts
#

# Exit on error, undefined variables, and pipe failures
set -euo pipefail

# Source required libraries
source "${HOME}"/.dotfilesrc
source "${DOTFILES_DIR}"/lib/linux.sh

# Dependency declarations
SCRIPT_DEPENDS_COMMANDS=("cp" "mkdir")
SCRIPT_DEPENDS_PLATFORM=("linux")
SCRIPT_DEPENDS_ENV=("DOTFILES_DIR" "HOME")

# Get desktop entry installation scripts
get_desktop_entry_scripts() {
    local scripts=()
    
    # Find all desktop entry installation scripts
    for installer in "${DOTFILES_DIR}"/install/linux/desktop-entries/*.sh; do
        if [[ -f "$installer" ]]; then
            scripts+=("$installer")
        fi
    done
    
    # Sort scripts for consistent installation order
    IFS=$'\n' scripts=($(sort <<<"${scripts[*]}"))
    unset IFS
    
    printf '%s\n' "${scripts[@]}"
}

# Ensure desktop directories exist
setup_desktop_directories() {
    log_info "Setting up desktop entry directories"
    
    # Create user desktop applications directory if it doesn't exist
    local user_desktop_dir="$HOME/.local/share/applications"
    if [[ ! -d "$user_desktop_dir" ]]; then
        log_info "Creating user desktop applications directory: $user_desktop_dir"
        mkdir -p "$user_desktop_dir"
    else
        log_debug "User desktop applications directory exists: $user_desktop_dir"
    fi
    
    # Create user icons directory if it doesn't exist
    local user_icons_dir="$HOME/.local/share/icons"
    if [[ ! -d "$user_icons_dir" ]]; then
        log_info "Creating user icons directory: $user_icons_dir"
        mkdir -p "$user_icons_dir"
    else
        log_debug "User icons directory exists: $user_icons_dir"
    fi
    
    log_success "Desktop directories are ready"
}

# Install desktop entries orchestration
install_desktop_entries() {
    log_banner "Installing Custom Desktop Entries"
    
    # Get list of desktop entry installation scripts
    local desktop_scripts
    readarray -t desktop_scripts < <(get_desktop_entry_scripts)
    
    if [[ ${#desktop_scripts[@]} -eq 0 ]]; then
        log_warn "No desktop entry installation scripts found in ${DOTFILES_DIR}/install/linux/desktop-entries/"
        log_info "Desktop entries allow custom applications to appear in application menus"
        return 0
    fi
    
    log_info "Found ${#desktop_scripts[@]} desktop entry installation scripts"
    
    # Setup desktop directories
    setup_desktop_directories
    
    # Start progress tracking
    progress_start ${#desktop_scripts[@]} "Desktop Entries Installation"
    
    local successful_installs=0
    local failed_installs=0
    local failed_scripts=()
    
    # Execute each desktop entry installation script
    for installer in "${desktop_scripts[@]}"; do
        local script_name
        script_name=$(basename "$installer")
        
        progress_step "Installing desktop entry: $script_name"
        log_info "Running desktop entry installer: $script_name"
        
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
    
    # Report installation results
    log_info "Desktop Entries Installation Summary:"
    log_info "  • Successful: $successful_installs"
    log_info "  • Failed: $failed_installs"
    log_info "  • Total: ${#desktop_scripts[@]}"
    
    if [[ $failed_installs -eq 0 ]]; then
        log_success "All desktop entries installed successfully!"
    else
        log_warn "Some desktop entries failed to install: ${failed_scripts[*]}"
        log_info "Check the logs above for specific error details"
    fi
    
    return $failed_installs
}

# Validate desktop entries installation
validate_desktop_entries() {
    log_info "Validating installed desktop entries"
    
    local user_desktop_dir="$HOME/.local/share/applications"
    local installed_entries=()
    
    # Find all desktop entries in user directory
    if [[ -d "$user_desktop_dir" ]]; then
        while IFS= read -r -d '' desktop_file; do
            local entry_name
            entry_name=$(basename "$desktop_file" .desktop)
            installed_entries+=("$entry_name")
        done < <(find "$user_desktop_dir" -name "*.desktop" -print0 2>/dev/null)
    fi
    
    if [[ ${#installed_entries[@]} -gt 0 ]]; then
        log_info "Installed desktop entries: ${installed_entries[*]}"
        
        # Validate each desktop entry
        local valid_entries=0
        local invalid_entries=0
        
        for entry in "${installed_entries[@]}"; do
            local desktop_file="$user_desktop_dir/$entry.desktop"
            if desktop-file-validate "$desktop_file" 2>/dev/null; then
                log_debug "✓ $entry.desktop is valid"
                ((valid_entries++))
            else
                log_warn "✗ $entry.desktop has validation issues"
                ((invalid_entries++))
            fi
        done
        
        log_info "Desktop entry validation: $valid_entries valid, $invalid_entries with issues"
    else
        log_info "No custom desktop entries found in user directory"
    fi
}

# Refresh desktop database
refresh_desktop_database() {
    log_info "Refreshing desktop database for application menu updates"
    
    # Update desktop database if update-desktop-database is available
    if command -v update-desktop-database >/dev/null 2>&1; then
        local user_desktop_dir="$HOME/.local/share/applications"
        if update-desktop-database "$user_desktop_dir" 2>/dev/null; then
            log_success "Desktop database updated successfully"
        else
            log_warn "Desktop database update failed (non-critical)"
        fi
    else
        log_debug "update-desktop-database not available"
    fi
    
    # Update icon cache if gtk-update-icon-cache is available
    if command -v gtk-update-icon-cache >/dev/null 2>&1; then
        local user_icons_dir="$HOME/.local/share/icons"
        if [[ -d "$user_icons_dir" ]]; then
            if gtk-update-icon-cache "$user_icons_dir" 2>/dev/null; then
                log_success "Icon cache updated successfully"
            else
                log_warn "Icon cache update failed (non-critical)"
            fi
        fi
    else
        log_debug "gtk-update-icon-cache not available"
    fi
    
    log_info "Desktop database refresh completed"
    log_info "New applications should appear in your application menu"
}

# Show desktop entry usage information
show_desktop_entry_info() {
    log_info "Desktop Entry Information:"
    log_info "  • User desktop entries: ~/.local/share/applications/"
    log_info "  • User icons: ~/.local/share/icons/"
    log_info "  • System desktop entries: /usr/share/applications/"
    log_info "  • System icons: /usr/share/icons/"
    log_info ""
    log_info "Desktop entry format (*.desktop files):"
    log_info "  • [Desktop Entry] section required"
    log_info "  • Name= Application name"
    log_info "  • Exec= Command to execute"
    log_info "  • Icon= Icon name or path"
    log_info "  • Type=Application (for applications)"
    log_info "  • Categories= Menu categories (e.g., Development;)"
    log_info ""
    log_info "Useful commands:"
    log_info "  • Validate: desktop-file-validate file.desktop"
    log_info "  • Install: desktop-file-install --dir ~/.local/share/applications file.desktop"
    log_info "  • Update database: update-desktop-database ~/.local/share/applications"
}

# Main execution
main() {
    log_info "Starting custom desktop entries installation orchestration"
    log_info "This will install custom desktop entries defined in ${DOTFILES_DIR}/install/linux/desktop-entries/"
    log_info "Desktop entries make applications appear in your application menu and launcher"
    
    # Install desktop entries
    if install_desktop_entries; then
        log_success "Desktop entries installation orchestration completed successfully"
        
        # Validate installation
        validate_desktop_entries
        
        # Refresh desktop database
        refresh_desktop_database
        
        # Show information
        show_desktop_entry_info
        
        log_info "Custom desktop entries are now available in your application menu"
    else
        log_error "Desktop entries installation orchestration completed with errors"
        log_info "Some desktop entries may not be available - check the logs above"
        return 1
    fi
}

# Execute main function
main
