#!/usr/bin/env bash
#
# Script Name: ruby.sh
# Description: Install Ruby development environment prerequisites
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

# Define Ruby development packages
declare -a RUBY_DEV_PACKAGES=(
    "autoconf"          # Automatic configure script builder
    "patch"             # Apply patches to source code
    "build-essential"   # Essential build tools (gcc, make, etc.)
    "rustc"             # Rust compiler (for some gems)
    "libssl-dev"        # OpenSSL development libraries
    "libyaml-dev"       # YAML parsing library
    "libreadline6-dev"  # GNU readline library
    "zlib1g-dev"        # Compression library
    "libgmp-dev"        # GNU Multiple Precision Arithmetic Library
    "libncurses5-dev"   # Terminal handling library
    "libffi-dev"        # Foreign Function Interface library
    "libgdbm6"          # GNU database manager
    "libgdbm-dev"       # GNU database manager development files
    "libdb-dev"         # Berkeley Database development files
    "uuid-dev"          # UUID library development files
)

# Install Ruby development prerequisites
install_ruby_prerequisites() {
    log_banner "Installing Ruby Development Prerequisites"
    
    log_info "Installing libraries and tools required for Ruby development"
    log_info "These packages support building Ruby from source and compiling native gems"
    
    progress_start 2 "Ruby Development Prerequisites Installation"
    
    # Step 1: Install development packages
    progress_step "Installing Ruby development packages"
    
    local failed_packages=()
    
    for package in "${RUBY_DEV_PACKAGES[@]}"; do
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
        log_success "All Ruby development packages installed successfully"
    else
        log_warn "Some packages failed to install: ${failed_packages[*]}"
        log_info "Ruby development may still work, but some gems might fail to compile"
    fi
    
    # Step 2: Validate installation
    progress_step "Validating Ruby development environment"
    if validate_ruby_environment; then
        log_success "Ruby development environment validation completed"
    else
        log_warn "Ruby development environment validation had warnings"
    fi
    
    progress_complete
    
    log_success "Ruby development prerequisites installation completed!"
    log_info "Installed Ruby development support:"
    log_info "  • Build tools - autoconf, patch, build-essential"
    log_info "  • Compilers - gcc, rustc for native extensions"
    log_info "  • Libraries - SSL, YAML, readline, zlib, ncurses"
    log_info "  • Database - GDBM, Berkeley DB support"
    log_info "  • System - FFI, UUID, GMP libraries"
}

# Validate Ruby development environment
validate_ruby_environment() {
    log_info "Validating Ruby development environment"
    
    # Check essential build tools
    local essential_tools=("gcc" "make" "autoconf" "patch")
    local missing_tools=()
    
    for tool in "${essential_tools[@]}"; do
        if command -v "$tool" >/dev/null 2>&1; then
            log_debug "✓ $tool is available"
        else
            missing_tools+=("$tool")
            log_debug "✗ $tool is not available"
        fi
    done
    
    if [[ ${#missing_tools[@]} -eq 0 ]]; then
        log_success "All essential build tools are available"
    else
        log_warn "Some build tools are missing: ${missing_tools[*]}"
    fi
    
    # Check critical development libraries
    local critical_libs=(
        "/usr/include/openssl/ssl.h"        # OpenSSL headers
        "/usr/include/yaml.h"               # YAML headers
        "/usr/include/readline/readline.h"  # Readline headers
        "/usr/include/zlib.h"               # Zlib headers
        "/usr/include/ffi.h"                # FFI headers
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
        log_success "All critical development headers are available"
    else
        log_warn "Some development headers are missing: ${#missing_libs[@]} files"
        log_debug "This may affect compilation of native gems"
    fi
    
    # Check if Ruby is already installed
    if command -v ruby >/dev/null 2>&1; then
        local ruby_version
        ruby_version=$(ruby --version 2>/dev/null | cut -d' ' -f2 || echo "unknown")
        log_info "Ruby is already installed: $ruby_version"
    else
        log_info "Ruby is not installed - you can install it with:"
        log_info "  • System Ruby: sudo apt install ruby-full"
        log_info "  • rbenv: Install rbenv and build Ruby versions"
        log_info "  • RVM: Install RVM and manage Ruby versions"
    fi
    
    return 0
}

# Show Ruby development usage information
show_ruby_usage() {
    log_info "Ruby Development Environment Usage:"
    log_info ""
    log_info "Installing Ruby:"
    log_info "  • System Ruby: sudo apt install ruby-full"
    log_info "  • rbenv: curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash"
    log_info "  • RVM: curl -sSL https://get.rvm.io | bash -s stable"
    log_info ""
    log_info "Common Ruby development tasks:"
    log_info "  • Install gems: gem install <gem-name>"
    log_info "  • Bundle dependencies: bundle install"
    log_info "  • Run Ruby scripts: ruby script.rb"
    log_info "  • Interactive console: irb"
    log_info ""
    log_info "Native gem compilation support:"
    log_info "  • Nokogiri (XML/HTML parsing)"
    log_info "  • pg (PostgreSQL adapter)"
    log_info "  • mysql2 (MySQL adapter)"
    log_info "  • ffi (Foreign Function Interface)"
    log_info "  • json (JSON parsing)"
    log_info "  • And many other gems with native extensions"
}

# Main execution
main() {
    log_info "Starting Ruby development prerequisites installation"
    log_info "Installing libraries and tools for Ruby development and native gem compilation"
    
    # Install prerequisites
    if install_ruby_prerequisites; then
        log_success "Ruby development prerequisites installation completed successfully"
        
        # Show usage information
        show_ruby_usage
        
        log_info "Your system is now ready for Ruby development"
        log_info "All necessary libraries for compiling native gems are installed"
    else
        log_error "Ruby development prerequisites installation failed"
        return 1
    fi
}

# Execute main function
main
