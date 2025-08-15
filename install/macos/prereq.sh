#!/usr/bin/env bash
#
# Script Name: prereq.sh
# Description: Install macOS prerequisites (Xcode CLI tools, Homebrew, Stow)
# Platform: macos
# Dependencies: internet connection, macOS, sudo access
#

# Exit on error, undefined variables, and pipe failures
set -euo pipefail

# Source required libraries
source "${DOTFILES_DIR}"/lib/macos.sh

# Parse command line arguments (includes --dry-run, --debug, etc.)
parse_script_arguments "$@"

# Show dry-run information if enabled
show_dry_run_info

# Dependency declarations
SCRIPT_DEPENDS_COMMANDS=("curl" "xcode-select")
SCRIPT_DEPENDS_PLATFORM=("macos")
SCRIPT_DEPENDS_ENV=("DOTFILES_DIR" "HOME")
SCRIPT_DEPENDS_NETWORK=("https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh")

# Install Xcode Command Line Tools
install_xcode_tools() {
    log_banner "Installing Xcode Command Line Tools"
    
    if is_dry_run; then
        log_simulate "xcode-select -p"
        log_info "Checking if Xcode Command Line Tools are installed..."
        
        # Simulate the check
        if command -v xcode-select >/dev/null 2>&1; then
            if xcode-select -p &>/dev/null; then
                log_success "Xcode Command Line Tools are already installed"
                return 0
            fi
        fi
        
        log_info "Xcode Command Line Tools need to be installed"
        log_dry_run "execute: xcode-select --install"
        log_info "Would prompt user to complete installation via GUI"
        log_warn "In real mode, script would exit here to wait for user completion"
        return 0
    fi
    
    # Real installation
    if ! xcode-select -p &>/dev/null; then
        log_info "Installing Xcode Command Line Tools..."
        log_warn "This will open a GUI installer - please complete it and re-run this script"
        xcode-select --install
        log_error "Please complete the Xcode Command Line Tools installation and re-run this script."
        exit 1
    else
        log_success "Xcode Command Line Tools are already installed"
    fi
}

# Install Homebrew
install_homebrew() {
    log_banner "Installing Homebrew Package Manager"
    
    if is_dry_run; then
        log_simulate "command -v brew"
        
        if command -v brew >/dev/null 2>&1; then
            log_success "Homebrew is already installed"
            local version
            version=$(brew --version 2>/dev/null | head -1 || echo "unknown version")
            log_info "Current version: $version"
        else
            log_info "Homebrew needs to be installed"
            log_dry_run "download and execute Homebrew installation script"
            log_simulate "curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
            log_simulate "/bin/bash -c \"$(curl -fsSL ...)\""
            log_dry_run "add Homebrew to PATH in current session"
            log_dry_run "add Homebrew to ~/.zprofile for future sessions"
            log_success "Homebrew installation simulated successfully"
        fi
        return 0
    fi
    
    # Real installation
    if ! command -v brew >/dev/null 2>&1; then
        log_info "Installing Homebrew package manager..."
        log_info "This may take several minutes and will require your password"
        
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH for current session
        if [[ -f "/opt/homebrew/bin/brew" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
            log_debug "Added Homebrew to current session PATH"
        fi
        
        # Also add to shell profile for future sessions
        if ! grep -q 'eval "$(/opt/homebrew/bin/brew shellenv)"' "${HOME}/.zprofile" 2>/dev/null; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "${HOME}/.zprofile"
            log_debug "Added Homebrew to ~/.zprofile"
        fi
        
        log_success "Homebrew installed successfully"
    else
        log_success "Homebrew is already installed"
        local version
        version=$(brew --version 2>/dev/null | head -1 || echo "unknown version")
        log_info "Current version: $version"
    fi
}

# Install GNU Stow
install_gnu_stow() {
    log_banner "Installing GNU Stow"
    
    if is_dry_run; then
        log_simulate "brew list stow"
        
        # Check if stow is installed
        if command -v stow >/dev/null 2>&1; then
            log_success "GNU Stow is already installed"
            local version="(simulated version)"
            log_info "Current version: $version"
        else
            log_info "GNU Stow needs to be installed via Homebrew"
            log_dry_run "execute: brew install stow"
            log_success "GNU Stow installation simulated successfully"
        fi
        return 0
    fi
    
    # Real installation
    if ! command -v stow >/dev/null 2>&1; then
        log_info "Installing GNU Stow for configuration management..."
        brew install stow
        log_success "GNU Stow installed successfully"
        
        # Verify installation
        if command -v stow >/dev/null 2>&1; then
            local version
            version=$(stow --version 2>/dev/null | head -1 | grep -oE '[0-9]+\.[0-9]+' || echo "unknown")
            log_info "Installed version: $version"
        fi
    else
        log_success "GNU Stow is already installed"
        local version
        version=$(stow --version 2>/dev/null | head -1 | grep -oE '[0-9]+\.[0-9]+' || echo "unknown")
        log_info "Current version: $version"
    fi
}

# Validate installation
validate_prerequisites() {
    log_banner "Validating Prerequisites"
    
    local missing_tools=()
    local required_tools=("xcode-select" "brew" "stow")
    
    for tool in "${required_tools[@]}"; do
        if is_dry_run; then
            log_simulate "command -v $tool"
            log_debug "✓ $tool validated (simulated)"
        else
            if command -v "$tool" >/dev/null 2>&1; then
                log_debug "✓ $tool is available"
            else
                missing_tools+=("$tool")
                log_warn "✗ $tool is not available"
            fi
        fi
    done
    
    if [[ ${#missing_tools[@]} -eq 0 ]]; then
        log_success "All prerequisites are available and ready"
        
        if ! is_dry_run; then
            # Show versions
            log_info "Installed versions:"
            log_info "  • Xcode CLI: $(xcode-select --version 2>/dev/null | head -1 || echo 'unknown')"
            log_info "  • Homebrew: $(brew --version 2>/dev/null | head -1 || echo 'unknown')"
            log_info "  • GNU Stow: $(stow --version 2>/dev/null | head -1 || echo 'unknown')"
        else
            log_info "All tools would be available after installation"
        fi
        
        return 0
    else
        log_error "Missing required tools: ${missing_tools[*]}"
        if is_dry_run; then
            log_warn "In dry-run mode: validation failures are simulated"
            return 0
        else
            log_info "Please re-run this script to install missing prerequisites"
            return 1
        fi
    fi
}

# Main execution
main() {
    log_info "Starting macOS prerequisites installation"
    log_info "This will install essential tools for dotfiles management"
    
    # Validate dependencies before proceeding
    validate_dependencies || {
        log_error "Dependency validation failed"
        if is_dry_run; then
            log_warn "Continuing simulation despite dependency failures"
        else
            exit 1
        fi
    }
    
    # Cache sudo credentials for installations that may require it
    if ! is_dry_run; then
        cache_sudo_credentials
    else
        log_dry_run "cache sudo credentials"
    fi
    
    # Install each prerequisite
    install_xcode_tools
    install_homebrew  
    install_gnu_stow
    
    # Validate everything is working
    if validate_prerequisites; then
        log_success "macOS prerequisites installation completed successfully!"
        log_info "Your Mac is ready for dotfiles installation and management"
        
        if is_dry_run; then
            show_dry_run_summary
        fi
    else
        log_error "Prerequisites validation failed"
        if ! is_dry_run; then
            exit 1
        fi
    fi
}

# Execute main function
main
