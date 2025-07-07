# Dependency Management System

The dotfiles repository includes a comprehensive dependency management system that ensures scripts have all required dependencies before execution and provides platform compatibility checking.

## Table of Contents

- [Quick Start](#quick-start)
- [Dependency Declaration Format](#dependency-declaration-format)
- [Validation Tools](#validation-tools)
- [Examples](#examples)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)

## Quick Start

### Check System Health
```bash
# Quick system validation
./bin/dotfiles doctor

# Comprehensive system validation  
./bin/dotfiles validate
```

### Add Dependencies to Your Script
Add these lines near the top of your script (after the header but before main logic):

```bash
# Dependency declarations
SCRIPT_DEPENDS_COMMANDS=("git" "curl" "stow")           # Required commands
SCRIPT_DEPENDS_PLATFORM=("linux")                       # Required platform
SCRIPT_DEPENDS_ENV=("DOTFILES_DIR")                     # Required env vars
```

### Test Dependency Declarations
```bash
# Check which scripts have dependency declarations
./bin/dotfiles test dependencies
# or
./bin/dotfiles test deps

# Validate a single script's dependencies
./bin/dotfiles test basic
```

## Dependency Declaration Format

Scripts declare their dependencies using special arrays at the top of the file. Here are all available dependency types:

### Commands and Tools
```bash
SCRIPT_DEPENDS_COMMANDS=("git" "curl" "stow" "apt")
```
Validates that required commands are available in PATH.

### System Packages  
```bash
SCRIPT_DEPENDS_PACKAGES=("build-essential" "wget" "ca-certificates")
```
Checks if packages are installed using the appropriate package manager.

### Repositories
```bash
SCRIPT_DEPENDS_REPOS=("ppa:fish-shell/release-3")
```
Validates that required repositories are configured (Linux PPA, Homebrew taps, etc.).

### Files and Directories
```bash
SCRIPT_DEPENDS_FILES=("/etc/apt/sources.list.d/docker.list")
SCRIPT_DEPENDS_DIRS=("/usr/share/keyrings" "/etc/apt/sources.list.d")
```
Ensures required files and directories exist.

### Environment Variables
```bash
SCRIPT_DEPENDS_ENV=("DOTFILES_DIR" "HOME" "USER")
```
Validates that required environment variables are set.

### Platform Compatibility
```bash
SCRIPT_DEPENDS_PLATFORM=("linux")                       # linux, macos, unix
SCRIPT_DEPENDS_DISTRO=("ubuntu")                        # ubuntu, debian, etc.
SCRIPT_DEPENDS_ARCH=("amd64")                           # amd64, arm64, etc.
```
Ensures the script runs only on compatible platforms.

### Version Requirements
```bash
SCRIPT_DEPENDS_MINIMUM_VERSION=("git:2.0" "curl:7.0")
```
Validates minimum version requirements for commands.

### Conflict Detection
```bash
SCRIPT_DEPENDS_CONFLICTS=("snap:docker" "command:podman")
```
Detects conflicting packages or commands that might cause issues.

### Optional Dependencies
```bash
SCRIPT_DEPENDS_OPTIONAL=("fish" "zsh")
```
Documents optional packages (for informational purposes).

### Execution Order Dependencies
```bash
SCRIPT_DEPENDS_BEFORE=("install/linux/prereq.sh")       # Must run before these
SCRIPT_DEPENDS_AFTER=("install/linux/cli.sh")           # Must run after these
```
Documents script execution order (for informational purposes).

## Validation Tools

### System Validation
```bash
# Quick health check
./bin/dotfiles doctor

# Comprehensive system validation
./bin/dotfiles validate

# Manual validation in scripts
source lib/dependencies.sh
validate_system
```

### Script Dependency Testing
```bash
# Check dependency declaration coverage
./bin/dotfiles test dependencies
./bin/dotfiles test deps

# Validate a single script's dependencies
./bin/dotfiles test basic

# Manual validation of specific scripts
source lib/dependencies.sh
validate_dependencies "path/to/script.sh"
```

### Platform Detection
```bash
# Detect current platform
source lib/dotfiles.sh
detect_os
echo "Platform: $DOTFILES_OS"  # linux, macos

# Check platform compatibility
if is_linux; then
    echo "Running on Linux"
elif is_macos; then
    echo "Running on macOS"
fi
```

## Examples

### Simple Linux Script
```bash
#!/usr/bin/env bash
#
# Script Name: install-stow.sh
# Description: Install GNU Stow for configuration management
# Platform: linux
# Dependencies: apt package manager, Ubuntu/Debian
#

set -euo pipefail

# Dependency declarations
SCRIPT_DEPENDS_COMMANDS=("apt" "dpkg")
SCRIPT_DEPENDS_PLATFORM=("linux")
SCRIPT_DEPENDS_DISTRO=("ubuntu")
SCRIPT_DEPENDS_ENV=("DOTFILES_DIR")

# Source libraries
source "${DOTFILES_DIR}/lib/linux.sh"

# Install stow
apt_install stow
```

### Complex Installation Script
```bash
#!/usr/bin/env bash
#
# Script Name: install-docker.sh
# Description: Install Docker Engine on Ubuntu
# Platform: linux
# Dependencies: Multiple tools and repositories
#

set -euo pipefail

# Comprehensive dependency declarations
SCRIPT_DEPENDS_COMMANDS=("wget" "apt" "usermod" "tee")
SCRIPT_DEPENDS_PACKAGES=("ca-certificates" "curl" "wget")
SCRIPT_DEPENDS_PLATFORM=("linux")
SCRIPT_DEPENDS_DISTRO=("ubuntu")
SCRIPT_DEPENDS_ENV=("USER" "DOTFILES_DIR")
SCRIPT_DEPENDS_DIRS=("/etc/apt/keyrings" "/etc/apt/sources.list.d")
SCRIPT_DEPENDS_CONFLICTS=("snap:docker")                # Conflict with snap version
SCRIPT_DEPENDS_MINIMUM_VERSION=("wget:1.0" "curl:7.0")

# Source libraries
source "${DOTFILES_DIR}/lib/linux.sh"

# Installation logic here...
```

### Cross-Platform Script
```bash
#!/usr/bin/env bash
#
# Script Name: install.sh
# Description: Main installation script
# Platform: cross-platform
# Dependencies: Core tools and environment
#

set -euo pipefail

# Cross-platform dependency declarations
SCRIPT_DEPENDS_COMMANDS=("stow" "git")
SCRIPT_DEPENDS_PLATFORM=("linux" "macos")
SCRIPT_DEPENDS_ENV=("DOTFILES_DIR" "HOME")
SCRIPT_DEPENDS_FILES=("${HOME}/.dotfilesrc")
SCRIPT_DEPENDS_DIRS=("${DOTFILES_DIR}/lib" "${DOTFILES_DIR}/install")
SCRIPT_DEPENDS_MINIMUM_VERSION=("git:2.0" "stow:2.0")

# Source libraries
source "${DOTFILES_DIR}/lib/dotfiles.sh"

# Installation logic here...
```

## Best Practices

### 1. Declare Dependencies Early
Place dependency declarations immediately after the script header but before any logic:

```bash
#!/usr/bin/env bash
set -euo pipefail

# Dependency declarations go here
SCRIPT_DEPENDS_COMMANDS=("git" "curl")
SCRIPT_DEPENDS_PLATFORM=("linux")

# Then source libraries
source "${DOTFILES_DIR}/lib/dotfiles.sh"
```

### 2. Be Specific with Platform Requirements
```bash
# Good: Specific platform and distro
SCRIPT_DEPENDS_PLATFORM=("linux")
SCRIPT_DEPENDS_DISTRO=("ubuntu")

# Avoid: Too generic
SCRIPT_DEPENDS_PLATFORM=("unix")
```

### 3. Include All Required Commands
Don't assume commands are available. Declare everything your script uses:

```bash
# Good: Comprehensive
SCRIPT_DEPENDS_COMMANDS=("wget" "gpg" "apt" "sudo" "grep")

# Avoid: Missing obvious dependencies
SCRIPT_DEPENDS_COMMANDS=("wget")  # Missing gpg, apt, etc.
```

### 4. Use Conflict Detection
Prevent known conflicts:

```bash
# Prevent snap/apt conflicts
SCRIPT_DEPENDS_CONFLICTS=("snap:docker")

# Prevent command conflicts  
SCRIPT_DEPENDS_CONFLICTS=("command:podman")
```

### 5. Document Optional Dependencies
```bash
# Help users understand what's optional
SCRIPT_DEPENDS_OPTIONAL=("fish" "zsh")
```

### 6. Validate Before Critical Operations
```bash
# Validate dependencies before starting
if ! validate_dependencies "${BASH_SOURCE[0]}"; then
    echo "❌ Dependencies not satisfied"
    exit 1
fi

# Proceed with installation
```

## Troubleshooting

### Common Issues

#### 1. Script Hanging During Validation
**Problem**: Test scripts hang indefinitely  
**Solution**: Check for infinite loops in dependency declarations

```bash
# Debug with timeout
timeout 10 validate_dependencies "script.sh"
```

#### 2. Platform Detection Fails
**Problem**: Platform not detected correctly  
**Solution**: Ensure OS detection runs first

```bash
source "${DOTFILES_DIR}/lib/dotfiles.sh"
detect_os  # Must call this first
echo "Platform: $DOTFILES_OS"
```

#### 3. Package Validation Fails
**Problem**: Installed packages not detected  
**Solution**: Check package manager compatibility

```bash
# Test package detection manually
validate_package "package-name" "apt"
validate_package "package-name" "auto"
```

#### 4. Environment Variables Not Found
**Problem**: Required env vars not detected  
**Solution**: Check variable names and sourcing

```bash
# Debug environment variables
echo "DOTFILES_DIR: ${DOTFILES_DIR:-NOT_SET}"
validate_env_var "DOTFILES_DIR"
```

### Debug Mode

Enable debug output for troubleshooting:

```bash
# Enable debug mode
export DOTFILES_DEBUG=1

# Run validation with debug output
./bin/dotfiles validate
```

### Manual Testing

Test individual validation functions:

```bash
# Load the library
source lib/dependencies.sh

# Test individual functions
validate_command "git"
validate_platform "linux"  
validate_distro "ubuntu"
validate_env_var "HOME"
```

### Getting Help

1. **Check system requirements**:
   ```bash
   ./bin/dotfiles doctor
   ```

2. **Run comprehensive validation**:
   ```bash
   ./bin/validate-system
   ```

3. **Test specific scripts**:
   ```bash
   ./bin/dotfiles test basic
   ./bin/dotfiles test dependencies
   ```

4. **Check the logs**: Look for specific error messages in the validation output

5. **Verify your environment**: Ensure `.dotfilesrc` is properly configured

## Integration with Existing Scripts

### Retrofitting Existing Scripts

To add dependency management to existing scripts:

1. **Add dependency declarations** after the header
2. **Keep existing logic unchanged** 
3. **Test the script** with the new declarations
4. **Validate dependencies** before critical operations (optional)

### Example Retrofit

**Before**:
```bash
#!/usr/bin/env bash
set -euo pipefail

source "${DOTFILES_DIR}/lib/linux.sh"

apt_install stow
```

**After**:
```bash
#!/usr/bin/env bash
set -euo pipefail

# Added dependency declarations
SCRIPT_DEPENDS_COMMANDS=("apt" "dpkg")
SCRIPT_DEPENDS_PLATFORM=("linux")
SCRIPT_DEPENDS_DISTRO=("ubuntu")
SCRIPT_DEPENDS_ENV=("DOTFILES_DIR")

source "${DOTFILES_DIR}/lib/linux.sh"

apt_install stow
```

The dependency management system provides robust validation and compatibility checking while remaining optional for most use cases. Scripts continue to work normally - the dependency declarations primarily serve as documentation and validation when using the dependency tools.

## Implementation Notes

All dependency testing and validation functionality is integrated directly into the main `dotfiles` utility. There are no separate scripts to maintain - everything is accessible through the unified command interface:

- `dotfiles test dependencies` - Dependency declaration coverage testing
- `dotfiles test basic` - Single script dependency validation  
- `dotfiles validate` - Comprehensive system validation
- `dotfiles doctor` - Enhanced health checking

All functionality is now consolidated into the single `dotfiles` utility for a clean, maintainable codebase. 
