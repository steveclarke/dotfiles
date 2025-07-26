#!/usr/bin/env bash
#
# Script Name: dependencies.sh
# Description: Dependency management system for dotfiles installation
# Platform: cross-platform
# Dependencies: lib/dotfiles.sh
#

# Source core functions
source "${DOTFILES_DIR}/lib/dotfiles.sh"

# =============================================================================
# DEPENDENCY DECLARATION FORMAT
# =============================================================================
#
# Scripts should declare dependencies using these arrays:
#
# SCRIPT_DEPENDS_COMMANDS=("git" "curl" "stow")           # Required commands
# SCRIPT_DEPENDS_PACKAGES=("build-essential" "wget")      # Required packages
# SCRIPT_DEPENDS_REPOS=("ppa:fish-shell/release-3")       # Required repositories
# SCRIPT_DEPENDS_FILES=("/etc/apt/sources.list.d/docker.list")  # Required files
# SCRIPT_DEPENDS_DIRS=("/usr/share/keyrings")             # Required directories
# SCRIPT_DEPENDS_ENV=("DOTFILES_DIR" "HOME")              # Required env vars
# SCRIPT_DEPENDS_PLATFORM=("linux")                       # Required platform
# SCRIPT_DEPENDS_DISTRO=("ubuntu" "debian")               # Required distros
# SCRIPT_DEPENDS_ARCH=("amd64" "arm64")                   # Required architectures
# SCRIPT_DEPENDS_CONFLICTS=("snap:docker")                # Conflicting packages
# SCRIPT_DEPENDS_OPTIONAL=("fish" "zsh")                  # Optional packages
# SCRIPT_DEPENDS_MINIMUM_VERSION=("git:2.0" "curl:7.0")   # Minimum versions
# SCRIPT_DEPENDS_BEFORE=("install/linux/prereq.sh")       # Must run before
# SCRIPT_DEPENDS_AFTER=("install/linux/cli.sh")           # Must run after
#
# =============================================================================

# Global arrays for dependency tracking (initialized when needed)
# These will be initialized as associative arrays when first used

# =============================================================================
# CORE DEPENDENCY VALIDATION FUNCTIONS
# =============================================================================

# Check if a command is available and optionally meets minimum version
validate_command() {
    local cmd="$1"
    local min_version="${2:-}"
    
    if ! command -v "$cmd" >/dev/null 2>&1; then
        return 1
    fi
    
    if [[ -n "$min_version" ]]; then
        # Extract version from command (implementation depends on command)
        local current_version
        case "$cmd" in
            git)
                current_version=$(git --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
                ;;
            curl)
                current_version=$(curl --version | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
                ;;
            *)
                # For other commands, assume they meet minimum version if present
                return 0
                ;;
        esac
        
        if [[ -n "$current_version" ]]; then
            # Simple version comparison (assumes semantic versioning)
            if ! version_compare "$current_version" ">=" "$min_version"; then
                return 2  # Version too old
            fi
        fi
    fi
    
    return 0
}

# Check if a package is installed using appropriate package manager
validate_package() {
    local package="$1"
    local manager="${2:-auto}"
    
    # Auto-detect package manager if not specified
    if [[ "$manager" == "auto" ]]; then
        if is_linux; then
            if command -v dpkg >/dev/null 2>&1; then
                manager="apt"
            elif command -v rpm >/dev/null 2>&1; then
                manager="rpm"
            elif command -v pacman >/dev/null 2>&1; then
                manager="pacman"
            fi
        elif is_macos; then
            manager="brew"
        fi
    fi
    
    case "$manager" in
        apt)
            dpkg -l "$package" >/dev/null 2>&1
            ;;
        brew)
            brew list "$package" >/dev/null 2>&1
            ;;
        snap)
            snap list "$package" >/dev/null 2>&1
            ;;
        flatpak)
            flatpak list | grep -q "$package"
            ;;
        *)
            # Fallback to command check
            validate_command "$package"
            ;;
    esac
}

# Check if a repository is added to the system
validate_repository() {
    local repo="$1"
    
    if is_linux; then
        if [[ "$repo" == ppa:* ]]; then
            # Check PPA repository
            local ppa_name="${repo#ppa:}"
            grep -r "$ppa_name" /etc/apt/sources.list.d/ >/dev/null 2>&1
        elif [[ "$repo" == *".list" ]]; then
            # Check APT repository file
            [[ -f "/etc/apt/sources.list.d/$repo" ]]
        else
            # Check if repository is in sources.list
            grep -q "$repo" /etc/apt/sources.list 2>/dev/null
        fi
    elif is_macos; then
        # Check Homebrew taps
        brew tap | grep -q "$repo"
    fi
}

# Check if a file exists
validate_file() {
    local file="$1"
    [[ -f "$file" ]]
}

# Check if a directory exists
validate_directory() {
    local dir="$1"
    [[ -d "$dir" ]]
}

# Check if an environment variable is set
validate_env_var() {
    local var="$1"
    [[ -n "${!var:-}" ]]
}

# Check platform compatibility
validate_platform() {
    local required_platform="$1"
    
    case "$required_platform" in
        linux)
            is_linux
            ;;
        macos)
            is_macos
            ;;
        unix)
            is_linux || is_macos
            ;;
        *)
            # Unknown platform
            return 1
            ;;
    esac
}

# Check distribution compatibility (Linux only)
validate_distro() {
    local required_distro="$1"
    
    if ! is_linux; then
        return 1
    fi
    
    if [[ -f /etc/os-release ]]; then
        local distro_id
        distro_id=$(grep "^ID=" /etc/os-release | cut -d'=' -f2 | tr -d '"')
        [[ "$distro_id" == "$required_distro" ]]
    else
        return 1
    fi
}

# Check architecture compatibility
validate_architecture() {
    local required_arch="$1"
    local current_arch
    
    if is_linux; then
        current_arch=$(dpkg --print-architecture 2>/dev/null || uname -m)
    elif is_macos; then
        current_arch=$(uname -m)
    fi
    
    case "$current_arch" in
        x86_64)
            [[ "$required_arch" == "amd64" || "$required_arch" == "x86_64" ]]
            ;;
        arm64|aarch64)
            [[ "$required_arch" == "arm64" || "$required_arch" == "aarch64" ]]
            ;;
        *)
            [[ "$current_arch" == "$required_arch" ]]
            ;;
    esac
}

# =============================================================================
# DEPENDENCY VALIDATION ORCHESTRATION
# =============================================================================

# Validate all dependencies for a script
validate_script_dependencies() {
    local script_name="$1"
    local validation_results=()
    local has_errors=false
    
    echo "🔍 Validating dependencies for $script_name..."
    
    # Validate platform compatibility first
    if [[ -n "${SCRIPT_DEPENDS_PLATFORM[*]:-}" ]]; then
        for platform in "${SCRIPT_DEPENDS_PLATFORM[@]}"; do
            if ! validate_platform "$platform"; then
                validation_results+=("❌ Platform '$platform' not supported (current: $DOTFILES_OS)")
                has_errors=true
            else
                validation_results+=("✅ Platform '$platform' supported")
            fi
        done
    fi
    
    # Validate distribution compatibility
    if [[ -n "${SCRIPT_DEPENDS_DISTRO[*]:-}" ]]; then
        for distro in "${SCRIPT_DEPENDS_DISTRO[@]}"; do
            if ! validate_distro "$distro"; then
                validation_results+=("❌ Distribution '$distro' not supported")
                has_errors=true
            else
                validation_results+=("✅ Distribution '$distro' supported")
            fi
        done
    fi
    
    # Validate architecture compatibility
    if [[ -n "${SCRIPT_DEPENDS_ARCH[*]:-}" ]]; then
        for arch in "${SCRIPT_DEPENDS_ARCH[@]}"; do
            if ! validate_architecture "$arch"; then
                validation_results+=("❌ Architecture '$arch' not supported")
                has_errors=true
            else
                validation_results+=("✅ Architecture '$arch' supported")
            fi
        done
    fi
    
    # Validate required commands
    if [[ -n "${SCRIPT_DEPENDS_COMMANDS[*]:-}" ]]; then
        for cmd in "${SCRIPT_DEPENDS_COMMANDS[@]}"; do
            if validate_command "$cmd"; then
                validation_results+=("✅ Command '$cmd' available")
            else
                validation_results+=("❌ Command '$cmd' not found")
                has_errors=true
            fi
        done
    fi
    
    # Validate required packages
    if [[ -n "${SCRIPT_DEPENDS_PACKAGES[*]:-}" ]]; then
        for package in "${SCRIPT_DEPENDS_PACKAGES[@]}"; do
            if validate_package "$package"; then
                validation_results+=("✅ Package '$package' installed")
            else
                validation_results+=("❌ Package '$package' not installed")
                has_errors=true
            fi
        done
    fi
    
    # Validate required repositories
    if [[ -n "${SCRIPT_DEPENDS_REPOS[*]:-}" ]]; then
        for repo in "${SCRIPT_DEPENDS_REPOS[@]}"; do
            if validate_repository "$repo"; then
                validation_results+=("✅ Repository '$repo' configured")
            else
                validation_results+=("❌ Repository '$repo' not configured")
                has_errors=true
            fi
        done
    fi
    
    # Validate required files
    if [[ -n "${SCRIPT_DEPENDS_FILES[*]:-}" ]]; then
        for file in "${SCRIPT_DEPENDS_FILES[@]}"; do
            if validate_file "$file"; then
                validation_results+=("✅ File '$file' exists")
            else
                validation_results+=("❌ File '$file' not found")
                has_errors=true
            fi
        done
    fi
    
    # Validate required directories
    if [[ -n "${SCRIPT_DEPENDS_DIRS[*]:-}" ]]; then
        for dir in "${SCRIPT_DEPENDS_DIRS[@]}"; do
            if validate_directory "$dir"; then
                validation_results+=("✅ Directory '$dir' exists")
            else
                validation_results+=("❌ Directory '$dir' not found")
                has_errors=true
            fi
        done
    fi
    
    # Validate required environment variables
    if [[ -n "${SCRIPT_DEPENDS_ENV[*]:-}" ]]; then
        for env_var in "${SCRIPT_DEPENDS_ENV[@]}"; do
            if validate_env_var "$env_var"; then
                validation_results+=("✅ Environment variable '$env_var' set")
            else
                validation_results+=("❌ Environment variable '$env_var' not set")
                has_errors=true
            fi
        done
    fi
    
    # Validate minimum versions
    if [[ -n "${SCRIPT_DEPENDS_MINIMUM_VERSION[*]:-}" ]]; then
        for version_spec in "${SCRIPT_DEPENDS_MINIMUM_VERSION[@]}"; do
            local cmd="${version_spec%%:*}"
            local min_version="${version_spec#*:}"
            
            case $(validate_command "$cmd" "$min_version") in
                0)
                    validation_results+=("✅ Command '$cmd' meets minimum version $min_version")
                    ;;
                1)
                    validation_results+=("❌ Command '$cmd' not found")
                    has_errors=true
                    ;;
                2)
                    validation_results+=("❌ Command '$cmd' version too old (minimum: $min_version)")
                    has_errors=true
                    ;;
            esac
        done
    fi
    
    # Check for conflicts
    if [[ -n "${SCRIPT_DEPENDS_CONFLICTS[*]:-}" ]]; then
        for conflict in "${SCRIPT_DEPENDS_CONFLICTS[@]}"; do
            local conflict_type="${conflict%%:*}"
            local conflict_item="${conflict#*:}"
            
            case "$conflict_type" in
                snap)
                    if validate_package "$conflict_item" "snap"; then
                        validation_results+=("⚠️  Conflicting snap package '$conflict_item' detected")
                        has_errors=true
                    fi
                    ;;
                apt)
                    if validate_package "$conflict_item" "apt"; then
                        validation_results+=("⚠️  Conflicting apt package '$conflict_item' detected")
                        has_errors=true
                    fi
                    ;;
                command)
                    if validate_command "$conflict_item"; then
                        validation_results+=("⚠️  Conflicting command '$conflict_item' detected")
                        has_errors=true
                    fi
                    ;;
            esac
        done
    fi
    
    # Display results
    for result in "${validation_results[@]}"; do
        echo "$result"
    done
    
    if [[ "$has_errors" == "true" ]]; then
        echo ""
        echo "❌ Dependency validation failed for $script_name"
        return 1
    else
        echo ""
        echo "✅ All dependencies satisfied for $script_name"
        return 0
    fi
}

# =============================================================================
# UTILITY FUNCTIONS
# =============================================================================

# Simple version comparison function
version_compare() {
    local version1="$1"
    local operator="$2"
    local version2="$3"
    
    # Convert versions to comparable format
    local ver1_numeric ver2_numeric
    ver1_numeric=$(echo "$version1" | awk -F. '{printf "%d%03d%03d", $1, $2, $3}')
    ver2_numeric=$(echo "$version2" | awk -F. '{printf "%d%03d%03d", $1, $2, $3}')
    
    case "$operator" in
        ">=")
            [[ "$ver1_numeric" -ge "$ver2_numeric" ]]
            ;;
        ">")
            [[ "$ver1_numeric" -gt "$ver2_numeric" ]]
            ;;
        "<=")
            [[ "$ver1_numeric" -le "$ver2_numeric" ]]
            ;;
        "<")
            [[ "$ver1_numeric" -lt "$ver2_numeric" ]]
            ;;
        "="|"==")
            [[ "$ver1_numeric" -eq "$ver2_numeric" ]]
            ;;
        *)
            return 1
            ;;
    esac
}

# Get system information for debugging
get_system_info() {
    echo "🖥️  System Information:"
    echo "   Platform: $DOTFILES_OS"
    echo "   OS Type: $OSTYPE"
    
    if is_linux; then
        if [[ -f /etc/os-release ]]; then
            local distro_name distro_version
            distro_name=$(grep "^NAME=" /etc/os-release | cut -d'=' -f2 | tr -d '"')
            distro_version=$(grep "^VERSION=" /etc/os-release | cut -d'=' -f2 | tr -d '"')
            echo "   Distribution: $distro_name $distro_version"
        fi
        echo "   Architecture: $(dpkg --print-architecture 2>/dev/null || uname -m)"
    elif is_macos; then
        echo "   macOS Version: $(sw_vers -productVersion)"
        echo "   Architecture: $(uname -m)"
    fi
    
    echo "   Shell: $SHELL"
    echo "   User: $USER"
    echo "   Home: $HOME"
    echo "   Dotfiles: $DOTFILES_DIR"
    echo ""
}

# =============================================================================
# MAIN VALIDATION ENTRY POINT
# =============================================================================

# Main function to validate dependencies for a script
validate_dependencies() {
    local script_path="$1"
    local script_name
    script_name=$(basename "$script_path")
    
    # Clear previous dependency declarations
    unset SCRIPT_DEPENDS_COMMANDS SCRIPT_DEPENDS_PACKAGES SCRIPT_DEPENDS_REPOS
    unset SCRIPT_DEPENDS_FILES SCRIPT_DEPENDS_DIRS SCRIPT_DEPENDS_ENV
    unset SCRIPT_DEPENDS_PLATFORM SCRIPT_DEPENDS_DISTRO SCRIPT_DEPENDS_ARCH
    unset SCRIPT_DEPENDS_CONFLICTS SCRIPT_DEPENDS_OPTIONAL SCRIPT_DEPENDS_MINIMUM_VERSION
    unset SCRIPT_DEPENDS_BEFORE SCRIPT_DEPENDS_AFTER
    
    # Source the script to load its dependency declarations
    # (This assumes the script has dependency declarations at the top)
    if [[ -f "$script_path" ]]; then
        # Extract dependency declarations from the script in a safer way
        local temp_file="/tmp/dotfiles-deps-$$.sh"
        
        # Create a temporary file with just the dependency declarations
        echo "#!/bin/bash" > "$temp_file"
        grep '^SCRIPT_DEPENDS_' "$script_path" >> "$temp_file" 2>/dev/null || true
        
        # Source the temporary file if it has content
        if [[ -s "$temp_file" ]]; then
            # shellcheck disable=SC1090
            source "$temp_file"
            rm -f "$temp_file"
        else
            echo "⚠️  No dependency declarations found in $script_path"
            rm -f "$temp_file"
            return 0
        fi
        
        # Validate dependencies
        validate_script_dependencies "$script_name"
    else
        echo "❌ Script not found: $script_path"
        return 1
    fi
}

# Pre-installation system validation
validate_system() {
    echo "🔍 Running comprehensive system validation..."
    echo ""
    
    get_system_info
    
    local validation_passed=true
    
    # Check core system requirements
    echo "🔧 Checking core system requirements..."
    
    # Check essential commands
    local essential_commands=("bash" "curl" "wget" "git")
    for cmd in "${essential_commands[@]}"; do
        if validate_command "$cmd"; then
            echo "✅ Essential command '$cmd' available"
        else
            echo "❌ Essential command '$cmd' not found"
            validation_passed=false
        fi
    done
    
    # Check platform-specific requirements
    if is_linux; then
        echo ""
        echo "🐧 Linux-specific checks..."
        
        # Check package managers
        if validate_command "apt"; then
            echo "✅ APT package manager available"
        else
            echo "❌ APT package manager not found"
            validation_passed=false
        fi
        
        # Check sudo access
        if sudo -n true 2>/dev/null; then
            echo "✅ Sudo access available"
        else
            echo "⚠️  Sudo access may require password"
        fi
        
    elif is_macos; then
        echo ""
        echo "🍎 macOS-specific checks..."
        
        # Check Xcode Command Line Tools
        if xcode-select -p &>/dev/null; then
            echo "✅ Xcode Command Line Tools installed"
        else
            echo "❌ Xcode Command Line Tools not installed"
            validation_passed=false
        fi
        
        # Check Homebrew
        if validate_command "brew"; then
            echo "✅ Homebrew available"
        else
            echo "⚠️  Homebrew not installed (will be installed)"
        fi
    fi
    
    # Check dotfiles environment
    echo ""
    echo "📁 Dotfiles environment checks..."
    
    if validate_env_var "DOTFILES_DIR"; then
        echo "✅ DOTFILES_DIR environment variable set"
        if validate_directory "$DOTFILES_DIR"; then
            echo "✅ Dotfiles directory exists"
        else
            echo "❌ Dotfiles directory not found: $DOTFILES_DIR"
            validation_passed=false
        fi
    else
        echo "❌ DOTFILES_DIR environment variable not set"
        validation_passed=false
    fi
    
    if validate_file "$HOME/.dotfilesrc"; then
        echo "✅ .dotfilesrc configuration file exists"
    else
        echo "❌ .dotfilesrc configuration file not found"
        validation_passed=false
    fi
    
    echo ""
    if [[ "$validation_passed" == "true" ]]; then
        echo "✅ System validation passed! Ready for installation."
        return 0
    else
        echo "❌ System validation failed. Please fix the issues above before proceeding."
        return 1
    fi
}

# Export functions for use in other scripts
export -f validate_command validate_package validate_repository validate_file
export -f validate_directory validate_env_var validate_platform validate_distro
export -f validate_architecture validate_script_dependencies validate_dependencies
export -f validate_system version_compare get_system_info 
