# Unified Package Management System for Dotfiles
# Supports: apt, snap, flatpak, brew, manual installations

# Source required libraries
source "${DOTFILES_DIR}/lib/logging.sh"

# Package manager priorities (higher number = higher priority)
declare -A PACKAGE_MANAGER_PRIORITY=(
    ["apt"]=100
    ["brew"]=90
    ["snap"]=70
    ["flatpak"]=60
    ["manual"]=10
)

# Package manager commands and validation
declare -A PACKAGE_MANAGER_COMMANDS=(
    ["apt"]="apt"
    ["brew"]="brew"
    ["snap"]="snap"
    ["flatpak"]="flatpak"
    ["manual"]=""
)

# Package availability cache to avoid repeated checks
declare -A PACKAGE_AVAILABILITY_CACHE=()

# Dry-run simulation data
declare -A DRY_RUN_INSTALLED_PACKAGES=()

# Safe execution wrapper for dry-run mode
safe_execute() {
    local description="$1"
    shift
    local command=("$@")
    
    if is_dry_run; then
        log_dry_run "$description"
        log_simulate "${command[*]}"
        return 0
    else
        log_debug "Executing: ${command[*]}"
        "${command[@]}"
    fi
}

# Detect available package managers on the system
detect_package_managers() {
    local available_managers=()
    
    log_debug "Detecting available package managers"
    
    for manager in "${!PACKAGE_MANAGER_COMMANDS[@]}"; do
        local cmd="${PACKAGE_MANAGER_COMMANDS[$manager]}"
        
        if [[ "$manager" == "manual" ]]; then
            # Manual installation is always available
            available_managers+=("$manager")
            log_debug "✓ $manager installation available"
        elif [[ -n "$cmd" ]] && command -v "$cmd" >/dev/null 2>&1; then
            available_managers+=("$manager")
            log_debug "✓ $manager package manager detected"
        else
            log_debug "✗ $manager package manager not found"
            if is_dry_run; then
                log_debug "  (In dry-run: would check for installation method)"
            fi
        fi
    done
    
    if [[ ${#available_managers[@]} -eq 0 ]]; then
        if is_dry_run; then
            log_warn "No package managers found - simulating with apt"
            available_managers=("apt")
        else
            log_error "No package managers found on system"
            return 1
        fi
    fi
    
    # Sort by priority (highest first)
    printf '%s\n' "${available_managers[@]}" | while read -r manager; do
        echo "${PACKAGE_MANAGER_PRIORITY[$manager]} $manager"
    done | sort -nr | cut -d' ' -f2
}

# Check if a package is available in a specific package manager
check_package_availability() {
    local package="$1"
    local manager="$2"
    local cache_key="${manager}:${package}"
    
    # Check cache first
    if [[ -n "${PACKAGE_AVAILABILITY_CACHE[$cache_key]:-}" ]]; then
        log_debug "Cache hit for $package in $manager: ${PACKAGE_AVAILABILITY_CACHE[$cache_key]}"
        [[ "${PACKAGE_AVAILABILITY_CACHE[$cache_key]}" == "available" ]]
        return $?
    fi
    
    log_debug "Checking availability of $package in $manager"
    
    if is_dry_run; then
        # In dry-run mode, simulate availability checks
        log_simulate "check $package availability in $manager"
        
        # Simulate common packages being available
        local common_packages=("curl" "wget" "git" "vim" "htop" "build-essential" "stow" "flatpak" "zsh" "fish")
        local available=false
        
        for common in "${common_packages[@]}"; do
            if [[ "$package" == "$common" ]]; then
                available=true
                break
            fi
        done
        
        # Cache the simulated result
        if $available; then
            PACKAGE_AVAILABILITY_CACHE[$cache_key]="available"
            log_debug "✓ $package simulated as available in $manager"
        else
            PACKAGE_AVAILABILITY_CACHE[$cache_key]="unavailable"
            log_debug "✗ $package simulated as not available in $manager"
        fi
        
        $available
        return $?
    fi
    
    local available=false
    
    case "$manager" in
        "apt")
            if apt-cache show "$package" >/dev/null 2>&1; then
                available=true
            fi
            ;;
        "brew")
            if brew search "$package" | grep -q "^$package$" 2>/dev/null; then
                available=true
            fi
            ;;
        "snap")
            if snap find "$package" | grep -q "^$package " 2>/dev/null; then
                available=true
            fi
            ;;
        "flatpak")
            if flatpak search "$package" | grep -q "$package" 2>/dev/null; then
                available=true
            fi
            ;;
        "manual")
            # Manual installation is always "available" but requires custom logic
            available=true
            ;;
    esac
    
    # Cache the result
    if $available; then
        PACKAGE_AVAILABILITY_CACHE[$cache_key]="available"
        log_debug "✓ $package is available in $manager"
    else
        PACKAGE_AVAILABILITY_CACHE[$cache_key]="unavailable"
        log_debug "✗ $package is not available in $manager"
    fi
    
    $available
}

# Install package using specific package manager
install_with_manager() {
    local package="$1"
    local manager="$2"
    local options="${3:-}"
    
    log_info "Installing $package using $manager"
    
    if is_dry_run; then
        log_simulate "package installation: $package via $manager"
        
        # Simulate the installation command
        case "$manager" in
            "apt")
                if [[ -n "$options" ]]; then
                    log_dry_run "execute: sudo apt install -y $options \"$package\""
                else
                    log_dry_run "execute: sudo apt install -y \"$package\""
                fi
                ;;
            "brew")
                if [[ -n "$options" ]]; then
                    log_dry_run "execute: brew install $options \"$package\""
                else
                    log_dry_run "execute: brew install \"$package\""
                fi
                ;;
            "snap")
                if [[ -n "$options" ]]; then
                    log_dry_run "execute: sudo snap install $options \"$package\""
                else
                    log_dry_run "execute: sudo snap install \"$package\""
                fi
                ;;
            "flatpak")
                if [[ -n "$options" ]]; then
                    log_dry_run "execute: flatpak install -y $options \"$package\""
                else
                    log_dry_run "execute: flatpak install -y flathub \"$package\""
                fi
                ;;
            "manual")
                log_dry_run "execute: manual installation function for $package"
                ;;
        esac
        
        # Mark as "installed" in simulation
        DRY_RUN_INSTALLED_PACKAGES["$package"]="$manager"
        log_success "Simulated: $package installed via $manager"
        return 0
    fi
    
    case "$manager" in
        "apt")
            if [[ -n "$options" ]]; then
                sudo apt install -y $options "$package"
            else
                sudo apt install -y "$package"
            fi
            ;;
        "brew")
            if [[ -n "$options" ]]; then
                brew install $options "$package"
            else
                brew install "$package"
            fi
            ;;
        "snap")
            if [[ -n "$options" ]]; then
                sudo snap install $options "$package"
            else
                sudo snap install "$package"
            fi
            ;;
        "flatpak")
            if [[ -n "$options" ]]; then
                flatpak install -y $options "$package"
            else
                flatpak install -y flathub "$package"
            fi
            ;;
        "manual")
            log_error "Manual installation of $package requires custom implementation"
            return 1
            ;;
        *)
            log_error "Unsupported package manager: $manager"
            return 1
            ;;
    esac
}

# Check if package is already installed
is_package_installed() {
    local package="$1"
    local manager="${2:-auto}"
    
    log_debug "Checking if $package is installed"
    
    # Check dry-run simulation data first
    if is_dry_run && [[ -n "${DRY_RUN_INSTALLED_PACKAGES[$package]:-}" ]]; then
        log_debug "✓ $package found in dry-run simulation (via ${DRY_RUN_INSTALLED_PACKAGES[$package]})"
        return 0
    fi
    
    # First try generic command check (works for most packages)
    if command -v "$package" >/dev/null 2>&1; then
        log_debug "✓ $package found in PATH"
        return 0
    fi
    
    # In dry-run mode, don't perform actual system checks for missing packages
    if is_dry_run; then
        log_debug "✗ $package not found (dry-run mode - not checking system packages)"
        return 1
    fi
    
    # If manager is specified, check with that manager
    if [[ "$manager" != "auto" ]]; then
        case "$manager" in
            "apt")
                dpkg -l "$package" >/dev/null 2>&1
                ;;
            "brew")
                brew list "$package" >/dev/null 2>&1
                ;;
            "snap")
                snap list "$package" >/dev/null 2>&1
                ;;
            "flatpak")
                flatpak list | grep -q "$package" 2>/dev/null
                ;;
            *)
                return 1
                ;;
        esac
        return $?
    fi
    
    # Check all available package managers
    local managers
    mapfile -t managers < <(detect_package_managers)
    
    for mgr in "${managers[@]}"; do
        case "$mgr" in
            "apt")
                if dpkg -l "$package" >/dev/null 2>&1; then
                    log_debug "✓ $package found via apt"
                    return 0
                fi
                ;;
            "brew")
                if brew list "$package" >/dev/null 2>&1; then
                    log_debug "✓ $package found via brew"
                    return 0
                fi
                ;;
            "snap")
                if snap list "$package" >/dev/null 2>&1; then
                    log_debug "✓ $package found via snap"
                    return 0
                fi
                ;;
            "flatpak")
                if flatpak list | grep -q "$package" 2>/dev/null; then
                    log_debug "✓ $package found via flatpak"
                    return 0
                fi
                ;;
        esac
    done
    
    log_debug "✗ $package not found"
    return 1
}

# Main unified package installation function
install_package() {
    local package="$1"
    local preferred_manager="${2:-auto}"
    local options="${3:-}"
    local manual_install_function="${4:-}"
    
    log_banner "Installing Package: $package"
    
    # Check if already installed
    if is_package_installed "$package"; then
        log_warn "$package is already installed"
        return 0
    fi
    
    # Get available package managers
    local managers
    mapfile -t managers < <(detect_package_managers)
    
    if [[ ${#managers[@]} -eq 0 ]]; then
        if is_dry_run; then
            log_warn "No package managers available - simulating installation"
            log_simulate "install $package with simulated package manager"
            DRY_RUN_INSTALLED_PACKAGES["$package"]="simulated"
            return 0
        else
            log_error "No package managers available"
            return 1
        fi
    fi
    
    # If preferred manager is specified, try it first
    if [[ "$preferred_manager" != "auto" ]]; then
        log_info "Attempting installation with preferred manager: $preferred_manager"
        
        # Check if preferred manager is available
        local preferred_available=false
        for mgr in "${managers[@]}"; do
            if [[ "$mgr" == "$preferred_manager" ]]; then
                preferred_available=true
                break
            fi
        done
        
        if $preferred_available || is_dry_run; then
            if check_package_availability "$package" "$preferred_manager"; then
                log_info "Installing $package with preferred manager: $preferred_manager"
                if install_with_manager "$package" "$preferred_manager" "$options"; then
                    log_success "$package installed successfully using $preferred_manager"
                    return 0
                else
                    log_warn "Failed to install $package with preferred manager $preferred_manager"
                fi
            else
                log_warn "$package not available in preferred manager $preferred_manager"
            fi
        else
            log_warn "Preferred manager $preferred_manager is not available"
        fi
    fi
    
    # Try each available manager in priority order
    log_info "Trying available package managers in priority order"
    
    for manager in "${managers[@]}"; do
        # Skip manual installation for now (try it last)
        if [[ "$manager" == "manual" ]]; then
            continue
        fi
        
        log_info "Attempting installation with $manager"
        
        if check_package_availability "$package" "$manager"; then
            log_info "Installing $package with $manager"
            if install_with_manager "$package" "$manager" "$options"; then
                log_success "$package installed successfully using $manager"
                return 0
            else
                log_warn "Failed to install $package with $manager, trying next manager"
            fi
        else
            log_debug "$package not available in $manager"
        fi
    done
    
    # Try manual installation if function is provided
    if [[ -n "$manual_install_function" ]] && declare -f "$manual_install_function" >/dev/null; then
        log_info "Attempting manual installation using function: $manual_install_function"
        
        if is_dry_run; then
            log_simulate "manual installation: $manual_install_function"
            log_dry_run "execute: $manual_install_function"
            DRY_RUN_INSTALLED_PACKAGES["$package"]="manual:$manual_install_function"
            log_success "Simulated: $package installed via manual function"
            return 0
        else
            if "$manual_install_function"; then
                log_success "$package installed successfully using manual installation"
                return 0
            else
                log_error "Manual installation of $package failed"
            fi
        fi
    fi
    
    # All installation methods failed
    log_error "Failed to install $package with any available method"
    log_info "Available package managers tried: ${managers[*]}"
    log_info "Consider installing $package manually or checking package name"
    
    if is_dry_run; then
        log_warn "In dry-run mode: simulating failure but continuing"
        return 1
    fi
    
    return 1
}

# Install multiple packages with unified management
install_packages() {
    local packages=("$@")
    local failed_packages=()
    local success_count=0
    
    log_banner "Installing Multiple Packages"
    progress_start ${#packages[@]} "Package Installation"
    
    for package in "${packages[@]}"; do
        progress_step "Installing $package"
        
        if install_package "$package"; then
            ((success_count++))
            log_debug "✓ $package installation successful"
        else
            failed_packages+=("$package")
            log_debug "✗ $package installation failed"
        fi
    done
    
    progress_complete
    
    if [[ ${#failed_packages[@]} -eq 0 ]]; then
        log_success "All packages installed successfully ($success_count/${#packages[@]})"
    else
        log_warn "Some packages failed to install (${#failed_packages[@]}/${#packages[@]} failed)"
        log_info "Failed packages: ${failed_packages[*]}"
        log_info "Successfully installed: $success_count packages"
        
        if is_dry_run; then
            log_info "(Note: In dry-run mode - no actual failures occurred)"
        fi
        
        return 1
    fi
}

# Package conflict detection and resolution
check_package_conflicts() {
    local package="$1"
    local conflicts="${2:-}"
    
    if [[ -z "$conflicts" ]]; then
        return 0
    fi
    
    log_debug "Checking conflicts for $package: $conflicts"
    
    # Parse conflicts (format: "manager:package,manager:package")
    IFS=',' read -ra conflict_list <<< "$conflicts"
    
    for conflict in "${conflict_list[@]}"; do
        if [[ "$conflict" == *":"* ]]; then
            local conflict_manager="${conflict%%:*}"
            local conflict_package="${conflict##*:}"
            
            log_debug "Checking conflict: $conflict_package in $conflict_manager"
            
            if is_package_installed "$conflict_package" "$conflict_manager"; then
                log_error "Package conflict detected: $conflict_package ($conflict_manager) conflicts with $package"
                log_info "Please remove $conflict_package before installing $package"
                log_info "Command: remove_package $conflict_package $conflict_manager"
                
                if is_dry_run; then
                    log_warn "In dry-run mode: conflict detected but continuing simulation"
                    return 0
                fi
                
                return 1
            fi
        else
            # No manager specified, check all
            if is_package_installed "$conflict"; then
                log_error "Package conflict detected: $conflict conflicts with $package"
                log_info "Please remove $conflict before installing $package"
                
                if is_dry_run; then
                    log_warn "In dry-run mode: conflict detected but continuing simulation"
                    return 0
                fi
                
                return 1
            fi
        fi
    done
    
    log_debug "No conflicts found for $package"
    return 0
}

# Remove package using appropriate manager
remove_package() {
    local package="$1"
    local manager="${2:-auto}"
    
    log_info "Removing package: $package"
    
    if ! is_package_installed "$package" "$manager"; then
        log_warn "$package is not installed"
        return 0
    fi
    
    if is_dry_run; then
        log_simulate "package removal: $package"
        
        # Remove from simulation data if present
        if [[ -n "${DRY_RUN_INSTALLED_PACKAGES[$package]:-}" ]]; then
            unset DRY_RUN_INSTALLED_PACKAGES["$package"]
            log_dry_run "remove $package from simulation data"
        fi
        
        # Show what removal command would be executed
        if [[ "$manager" != "auto" ]]; then
            case "$manager" in
                "apt")
                    log_dry_run "execute: sudo apt remove -y \"$package\""
                    ;;
                "brew")
                    log_dry_run "execute: brew uninstall \"$package\""
                    ;;
                "snap")
                    log_dry_run "execute: sudo snap remove \"$package\""
                    ;;
                "flatpak")
                    log_dry_run "execute: flatpak uninstall -y \"$package\""
                    ;;
            esac
        fi
        
        log_success "Simulated: $package removed"
        return 0
    fi
    
    # If manager is specified, use it
    if [[ "$manager" != "auto" ]]; then
        case "$manager" in
            "apt")
                sudo apt remove -y "$package"
                ;;
            "brew")
                brew uninstall "$package"
                ;;
            "snap")
                sudo snap remove "$package"
                ;;
            "flatpak")
                flatpak uninstall -y "$package"
                ;;
            *)
                log_error "Unsupported package manager for removal: $manager"
                return 1
                ;;
        esac
    else
        # Auto-detect and remove
        local managers
        mapfile -t managers < <(detect_package_managers)
        
        for mgr in "${managers[@]}"; do
            if is_package_installed "$package" "$mgr"; then
                log_info "Removing $package using $mgr"
                remove_package "$package" "$mgr"
                return $?
            fi
        done
        
        log_error "Could not determine how to remove $package"
        return 1
    fi
}

# System package manager info and diagnostics
show_package_manager_info() {
    log_banner "Package Manager Information"
    
    local managers
    mapfile -t managers < <(detect_package_managers)
    
    log_info "Available package managers (in priority order):"
    for manager in "${managers[@]}"; do
        local cmd="${PACKAGE_MANAGER_COMMANDS[$manager]}"
        local priority="${PACKAGE_MANAGER_PRIORITY[$manager]}"
        
        if [[ "$manager" == "manual" ]]; then
            log_info "  $manager (priority: $priority) - Custom installation functions"
        else
            local version=""
            if is_dry_run; then
                version="(simulated version)"
            else
                case "$manager" in
                    "apt")
                        version=$(apt --version 2>/dev/null | head -1 || echo "unknown")
                        ;;
                    "brew")
                        version=$(brew --version 2>/dev/null | head -1 || echo "unknown")
                        ;;
                    "snap")
                        version=$(snap version 2>/dev/null | head -1 || echo "unknown")
                        ;;
                    "flatpak")
                        version=$(flatpak --version 2>/dev/null || echo "unknown")
                        ;;
                esac
            fi
            log_info "  $manager (priority: $priority) - $version"
        fi
    done
    
    # Show cache stats
    local cache_size=${#PACKAGE_AVAILABILITY_CACHE[@]}
    log_info "Package availability cache: $cache_size entries"
    
    # Show dry-run simulation data
    if is_dry_run; then
        local sim_count=${#DRY_RUN_INSTALLED_PACKAGES[@]}
        log_info "Dry-run simulated packages: $sim_count installed"
        
        if [[ $sim_count -gt 0 ]]; then
            log_debug "Simulated installed packages:"
            for pkg in "${!DRY_RUN_INSTALLED_PACKAGES[@]}"; do
                log_debug "  $pkg (via ${DRY_RUN_INSTALLED_PACKAGES[$pkg]})"
            done
        fi
    fi
    
    if [[ "$DOTFILES_DEBUG" == "1" && $cache_size -gt 0 ]]; then
        log_debug "Cache contents:"
        for key in "${!PACKAGE_AVAILABILITY_CACHE[@]}"; do
            log_debug "  $key: ${PACKAGE_AVAILABILITY_CACHE[$key]}"
        done
    fi
}

# Show dry-run simulation summary
show_dry_run_summary() {
    if is_dry_run; then
        log_banner "Dry-Run Simulation Summary"
        
        local sim_count=${#DRY_RUN_INSTALLED_PACKAGES[@]}
        
        if [[ $sim_count -gt 0 ]]; then
            log_info "Packages that would be installed ($sim_count):"
            for pkg in "${!DRY_RUN_INSTALLED_PACKAGES[@]}"; do
                log_info "  • $pkg (via ${DRY_RUN_INSTALLED_PACKAGES[$pkg]})"
            done
        else
            log_info "No packages would be installed"
        fi
        
        log_info ""
        log_info "To perform actual installation, run the script without --dry-run"
    fi
}

# Initialize package management system
init_package_management() {
    log_debug "Initializing package management system"
    
    # Clear cache
    PACKAGE_AVAILABILITY_CACHE=()
    
    # Detect available managers
    local managers
    mapfile -t managers < <(detect_package_managers)
    
    if [[ ${#managers[@]} -eq 0 ]]; then
        log_warn "No package managers detected"
        return 1
    fi
    
    log_debug "Package management system initialized with managers: ${managers[*]}"
    return 0
}

# Auto-initialize when sourced
init_package_management 
