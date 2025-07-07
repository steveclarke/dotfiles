#!/usr/bin/env bash
#
# Script Name: cli.sh
# Description: Install Linux CLI tools by orchestrating all scripts in cli/ directory
# Platform: linux
# Dependencies: .dotfilesrc, apt, CLI installation scripts
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

# Get CLI installation scripts
get_cli_scripts() {
    local scripts=()
    
    # Find all CLI installation scripts
    for installer in "${DOTFILES_DIR}"/install/linux/cli/*.sh; do
        if [[ -f "$installer" ]]; then
            scripts+=("$installer")
        fi
    done
    
    # Sort scripts for consistent installation order
    IFS=$'\n' scripts=($(sort <<<"${scripts[*]}"))
    unset IFS
    
    printf '%s\n' "${scripts[@]}"
}

# Install CLI tools orchestration
install_cli_tools() {
    log_banner "Installing Linux CLI Tools"
    
    # Get list of CLI installation scripts
    local cli_scripts
    readarray -t cli_scripts < <(get_cli_scripts)
    
    if [[ ${#cli_scripts[@]} -eq 0 ]]; then
        log_warn "No CLI installation scripts found in ${DOTFILES_DIR}/install/linux/cli/"
        return 0
    fi
    
    log_info "Found ${#cli_scripts[@]} CLI installation scripts"
    
    # Start progress tracking
    progress_start ${#cli_scripts[@]} "CLI Tools Installation"
    
    local successful_installs=0
    local failed_installs=0
    local failed_scripts=()
    
    # Execute each CLI installation script
    for installer in "${cli_scripts[@]}"; do
        local script_name
        script_name=$(basename "$installer")
        
        progress_step "Installing CLI tool: $script_name"
        log_info "Running CLI installer: $script_name"
        
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
    log_info "CLI Tools Installation Summary:"
    log_info "  • Successful: $successful_installs"
    log_info "  • Failed: $failed_installs"
    log_info "  • Total: ${#cli_scripts[@]}"
    
    if [[ $failed_installs -eq 0 ]]; then
        log_success "All CLI tools installed successfully!"
    else
        log_warn "Some CLI tools failed to install: ${failed_scripts[*]}"
        log_info "Check the logs above for specific error details"
    fi
    
    return $failed_installs
}

# Show installed CLI tools
show_installed_cli_tools() {
    log_info "Verifying installed CLI tools:"
    
    # Common CLI tools that might be installed
    local common_cli_tools=(
        "docker" "fish" "htop" "vim" "mise" "brew" "fastfetch" "ollama"
        "heroku" "doctl" "nala" "wavemon" "wl-clipboard" "xclip"
    )
    
    local installed_tools=()
    local missing_tools=()
    
    for tool in "${common_cli_tools[@]}"; do
        if command -v "$tool" >/dev/null 2>&1; then
            installed_tools+=("$tool")
        else
            missing_tools+=("$tool")
        fi
    done
    
    if [[ ${#installed_tools[@]} -gt 0 ]]; then
        log_info "Available CLI tools: ${installed_tools[*]}"
    fi
    
    if [[ ${#missing_tools[@]} -gt 0 ]]; then
        log_debug "Not installed: ${missing_tools[*]}"
    fi
}

# Main execution
main() {
    log_info "Starting Linux CLI tools installation orchestration"
    log_info "This will install all CLI tools defined in ${DOTFILES_DIR}/install/linux/cli/"
    
    # Install CLI tools
    if install_cli_tools; then
        log_success "CLI tools installation orchestration completed successfully"
        
        # Show verification
        show_installed_cli_tools
        
        log_info "All CLI tools are now ready for use"
    else
        log_error "CLI tools installation orchestration completed with errors"
        log_info "Some CLI tools may not be available - check the logs above"
        return 1
    fi
}

# Execute main function
main
