# Unified Package Management System

## Overview

The dotfiles repository now includes a comprehensive unified package management system that provides seamless package installation across different platforms and package managers. This system automatically detects available package managers, tries multiple installation methods, and provides intelligent fallback mechanisms.

## Architecture

### Core Components

1. **`lib/package-management.sh`** - Core unified package management library (400+ lines)
2. **`lib/dotfiles.sh`** - Updated with package management integration
3. **`lib/linux.sh`** - Linux-specific package management functions
4. **`lib/macos.sh`** - macOS-specific package management functions
5. **`bin/dotfiles`** - Enhanced utility with package management commands

### Supported Package Managers

The system supports multiple package managers with automatic priority ordering:

| Package Manager | Platform | Priority | Use Case |
|----------------|----------|----------|----------|
| **apt** | Linux | 100 | Primary package manager for Ubuntu/Debian |
| **brew** | macOS/Linux | 90 | Primary package manager for macOS |
| **snap** | Linux | 70 | Universal packages for Linux |
| **flatpak** | Linux | 60 | Sandboxed applications for Linux |
| **manual** | All | 10 | Custom installation functions |

## Key Features

### 🔄 Automatic Package Manager Detection
- Detects available package managers on the system
- Orders by priority for optimal installation experience
- Caches detection results for performance

### 📦 Unified Installation Interface
```bash
# Simple package installation
dotfiles pkg install curl

# Install with preferred package manager
dotfiles pkg install code snap

# Install multiple packages
dotfiles pkg install-bulk git curl wget stow
```

### 🔍 Intelligent Fallback System
- Tries preferred package manager first
- Falls back to alternative managers automatically
- Uses manual installation functions when available
- Provides detailed error messages with troubleshooting suggestions

### ⚡ Conflict Detection and Resolution
```bash
# Check for package conflicts
dotfiles pkg conflicts docker "snap:docker"

# Automatic conflict detection during installation
install_package "code" "apt" "" "" "snap:code"
```

### 📊 Package Availability Caching
- Caches package availability checks to improve performance
- Reduces redundant searches across package managers
- Smart cache invalidation and management

### 🛠️ Enhanced Error Handling
- Detailed error context with troubleshooting suggestions
- Integration with comprehensive logging system
- Progress tracking for multi-package installations

## Command Line Interface

### Package Management Commands

```bash
# Install packages
dotfiles pkg install <package>              # Install single package
dotfiles pkg install <package> <manager>    # Install with specific manager
dotfiles pkg install-bulk <pkg1> <pkg2>     # Install multiple packages

# Package information
dotfiles pkg list                           # List installed packages
dotfiles pkg search <package>               # Search for packages
dotfiles pkg info                          # Show package manager info
dotfiles pkg managers                      # List available managers

# Package management
dotfiles pkg remove <package>               # Remove package
dotfiles pkg conflicts <package>            # Check conflicts
```

### Examples

```bash
# Install VS Code using best available method
dotfiles pkg install code

# Install VS Code specifically via snap
dotfiles pkg install code snap --classic

# Install development tools
dotfiles pkg install-bulk git curl wget node npm

# Search for packages
dotfiles pkg search docker

# Show system package manager information
dotfiles pkg info

# List all available package managers
dotfiles pkg managers
```

## Programming Interface

### Core Functions

#### `install_package(package, manager, options, manual_function)`
Main unified package installation function.

```bash
# Basic usage
install_package "curl"

# With preferred manager
install_package "code" "snap" "--classic"

# With manual fallback
install_package "custom-app" "auto" "" "install_custom_app_manual"
```

#### `install_packages(packages...)`
Install multiple packages with progress tracking.

```bash
install_packages "git" "curl" "wget" "stow"
```

#### `is_package_installed(package, manager)`
Check if a package is installed.

```bash
if is_package_installed "docker"; then
    echo "Docker is installed"
fi
```

#### `check_package_conflicts(package, conflicts)`
Check for package conflicts before installation.

```bash
# Check if snap version conflicts with apt version
check_package_conflicts "docker" "snap:docker"
```

#### `detect_package_managers()`
Get list of available package managers in priority order.

```bash
mapfile -t managers < <(detect_package_managers)
echo "Available: ${managers[*]}"
```

### Platform-Specific Functions

#### Linux Functions
```bash
# Linux-specific installation with intelligent manager selection
linux_install_package "package" "preferred_manager"

# Bulk installation optimized for Linux
linux_install_packages "pkg1" "pkg2" "pkg3"

# Get Linux package manager preference
manager=$(get_linux_package_manager_preference)
```

#### macOS Functions
```bash
# macOS-specific installation
macos_install_package "package" "preferred_manager"

# Install macOS applications
install_macos_app "Visual Studio Code" "visual-studio-code"

# Bulk install macOS apps
install_macos_apps "chrome" "firefox" "code"
```

## Integration Examples

### Enhanced Installation Scripts

#### Basic Integration
```bash
#!/usr/bin/env bash
source "${DOTFILES_DIR}/lib/linux.sh"

# Old way
apt_install "docker"

# New way - with automatic fallback and conflict detection
install_package "docker" "auto" "" "install_docker_manual"
```

#### Advanced Integration with Conflicts
```bash
#!/usr/bin/env bash
source "${DOTFILES_DIR}/lib/linux.sh"

# Dependency declarations
SCRIPT_DEPENDS_CONFLICTS=("snap:code")

install_vscode() {
    # Check conflicts
    if ! check_package_conflicts "code" "${SCRIPT_DEPENDS_CONFLICTS}"; then
        log_error "Conflicts detected - please resolve before installation"
        return 1
    fi
    
    # Install with fallback
    install_package "code" "snap" "--classic" "install_vscode_manual"
}
```

#### Manual Installation Function
```bash
install_custom_app_manual() {
    log_info "Installing custom app via manual method"
    
    # Download and install custom application
    if wget -O /tmp/custom-app.deb "https://example.com/custom-app.deb"; then
        sudo dpkg -i /tmp/custom-app.deb
        sudo apt-get install -f  # Fix dependencies
        return 0
    fi
    
    return 1
}

# Use manual function as fallback
install_package "custom-app" "auto" "" "install_custom_app_manual"
```

## Configuration

### Environment Variables

```bash
# Package management behavior
export DOTFILES_PKG_CACHE_TTL=3600          # Cache timeout (seconds)
export DOTFILES_PKG_RETRY_COUNT=3           # Retry attempts
export DOTFILES_PKG_TIMEOUT=300             # Installation timeout

# Manager preferences (space-separated, highest priority first)
export DOTFILES_LINUX_PKG_PRIORITY="apt snap flatpak manual"
export DOTFILES_MACOS_PKG_PRIORITY="brew manual"

# Logging integration
export DOTFILES_DEBUG=1                     # Enable debug output
export DOTFILES_LOG_LEVEL=DEBUG             # Detailed logging
```

### Package Manager Priority

You can customize package manager priority by modifying the priority values:

```bash
# In lib/package-management.sh
declare -A PACKAGE_MANAGER_PRIORITY=(
    ["apt"]=100        # Highest priority
    ["brew"]=90
    ["snap"]=70
    ["flatpak"]=60
    ["manual"]=10      # Lowest priority
)
```

## Performance Optimizations

### Caching System
- **Package Availability Cache**: Stores results of package availability checks
- **Manager Detection Cache**: Caches available package managers
- **Smart Cache Invalidation**: Automatically clears stale cache entries

### Parallel Operations
- **Bulk Installations**: Processes multiple packages efficiently
- **Concurrent Searches**: Searches multiple package managers simultaneously
- **Progress Tracking**: Real-time progress updates for long operations

### Reduced Network Calls
- **Availability Caching**: Avoids repeated package searches
- **Manager Optimization**: Uses most likely successful manager first
- **Smart Fallbacks**: Only tries alternative managers when necessary

## Error Handling and Troubleshooting

### Common Issues and Solutions

#### Package Not Found
```
❌ [ERROR] Failed to install package with any available method
ℹ️ [INFO] Available package managers tried: apt snap flatpak
ℹ️ [INFO] Consider installing package manually or checking package name
```

**Solution**: Check package name spelling, try manual installation, or use different package manager.

#### Package Conflicts
```
❌ [ERROR] Package conflict detected: docker (snap) conflicts with docker
ℹ️ [INFO] Please remove docker before installing docker
ℹ️ [INFO] Command: remove_package docker snap
```

**Solution**: Remove conflicting package first, then retry installation.

#### Manager Not Available
```
⚠️ [WARN] Preferred manager snap is not available
ℹ️ [INFO] Trying available package managers in priority order
```

**Solution**: System will automatically try alternative managers.

### Debug Mode

Enable debug mode for detailed troubleshooting:

```bash
# Enable debug mode
dotfiles debug on

# Install with debug output
dotfiles pkg install package-name

# Check debug status
dotfiles debug status
```

### Log Analysis

```bash
# View recent package management logs
dotfiles logs | grep "\[PKG\]"

# Follow real-time package installation
dotfiles logs tail | grep "Installing"

# Clear logs
dotfiles logs clear
```

## Migration Guide

### From Old System

#### Before (Old Way)
```bash
# Individual manager calls
apt_install "curl"
brew_install "wget"

# Manual error handling
if ! command -v git >/dev/null; then
    sudo apt install -y git
fi
```

#### After (New Way)
```bash
# Unified installation
install_package "curl"           # Auto-detects best manager
install_package "wget"           # Works on any platform

# Automatic detection and installation
install_packages "git" "curl" "wget"  # Bulk installation with progress
```

### Updating Existing Scripts

1. **Replace direct package manager calls**:
   ```bash
   # Old
   apt_install "package"
   
   # New
   install_package "package"
   ```

2. **Add conflict declarations**:
   ```bash
   SCRIPT_DEPENDS_CONFLICTS=("snap:package")
   ```

3. **Use enhanced error handling**:
   ```bash
   if ! install_package "package"; then
       log_error "Installation failed"
       return 1
   fi
   ```

## Best Practices

### 1. Use Unified Functions
```bash
# ✅ Good - uses unified system
install_package "docker"

# ❌ Avoid - platform-specific
apt install docker
```

### 2. Declare Conflicts
```bash
# ✅ Good - declares conflicts
SCRIPT_DEPENDS_CONFLICTS=("snap:code")
check_package_conflicts "code" "${SCRIPT_DEPENDS_CONFLICTS}"

# ❌ Avoid - no conflict checking
install_package "code"
```

### 3. Provide Manual Fallbacks
```bash
# ✅ Good - provides manual installation
install_package "custom-app" "auto" "" "install_custom_app_manual"

# ❌ Avoid - no fallback
install_package "custom-app"
```

### 4. Use Bulk Operations
```bash
# ✅ Good - efficient bulk installation
install_packages "git" "curl" "wget" "stow"

# ❌ Avoid - multiple individual calls
install_package "git"
install_package "curl"
install_package "wget"
install_package "stow"
```

### 5. Check Installation Status
```bash
# ✅ Good - checks before installing
if ! is_package_installed "docker"; then
    install_package "docker"
fi

# ❌ Avoid - always tries to install
install_package "docker"
```

## Future Enhancements

### Planned Features
1. **Package Version Management**: Support for specific package versions
2. **Dependency Resolution**: Automatic dependency installation
3. **Update Management**: Unified package update system
4. **Repository Management**: Adding and managing custom repositories
5. **Package Profiles**: Predefined package sets for different use cases

### API Extensions
1. **Plugin System**: Support for custom package managers
2. **Hooks**: Pre/post installation hooks
3. **Validation**: Package integrity verification
4. **Rollback**: Package installation rollback support

## Support

### Getting Help
- **Debug Mode**: `dotfiles debug on` for detailed output
- **Log Analysis**: `dotfiles logs` for installation history
- **System Info**: `dotfiles pkg info` for system status
- **Manager List**: `dotfiles pkg managers` for available options

### Contributing
- Add support for new package managers in `lib/package-management.sh`
- Enhance platform-specific functions in `lib/linux.sh` and `lib/macos.sh`
- Improve error handling and user experience
- Add tests and validation for new features

---

This unified package management system provides a robust, intelligent, and user-friendly way to handle package installation across different platforms and package managers, significantly improving the dotfiles installation experience. 
