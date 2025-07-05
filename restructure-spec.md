# Dotfiles Restructuring Plan

## Current Issues

1. **Inconsistent directory structure**: 
   - macOS has `install/macos/` but Linux scripts are scattered in `install/` root
   - Files like `install/cli.sh`, `install/apps.sh`, `install/prereq.sh` are Linux-only but not clearly marked

2. **Mixed platform logic**: Linux and macOS installation flows are different but not clearly separated

3. **Deprecated bootstrap scripts**: Both `bootstrap.sh` and `bootstrap-macos.sh` are marked as deprecated but still present

4. **Platform detection scattered**: OS detection logic is duplicated across multiple files

5. **Config management mixed**: `configs/stow.sh` has Linux-specific configurations mixed with cross-platform ones

6. **Fixes directory unclear**: Linux-specific fixes are not clearly categorized by platform

7. **Documentation scattered**: Multiple plan files and TODO files in root directory

8. **Library file oversized**: `lib/dotfiles.sh` is 275 lines with mixed responsibilities

## Proposed Reorganization

### 1. Install Directory Structure

Restructure the `install/` directory to clearly separate platforms:

```
install/
├── linux/
│   ├── cli.sh                    # [MOVE] from install/cli.sh
│   ├── apps.sh                   # [MOVE] from install/apps.sh  
│   ├── prereq.sh                 # [MOVE] from install/prereq.sh
│   ├── desktop-entries.sh        # [MOVE] from install/desktop-entries.sh
│   ├── cli/                      # [MOVE] from install/cli/
│   ├── apps/                     # [MOVE] from install/apps/
│   ├── prereq/                   # [MOVE] from install/prereq/
│   └── desktop-entries/          # [MOVE] from install/desktop-entries/
├── macos/
│   ├── brew.sh                   # [KEEP] already exists
│   ├── prereq.sh                 # [KEEP] already exists  
│   └── fish.sh                   # [KEEP] already exists
└── optional/                     # [KEEP] cross-platform optional installs
```

### 2. Config Management Separation

Split configuration management by platform:

```
configs/
├── stow.sh                       # [MODIFY] Cross-platform configurations only
├── linux/
│   └── stow-linux.sh            # [CREATE] Linux-specific configurations (i3, polybar, etc.)
├── macos/
│   └── stow-macos.sh            # [CREATE] macOS-specific configurations (future)
└── [existing config directories] # [KEEP] actual config files
```

### 3. Fixes Directory Organization

Organize fixes by platform:

```
fixes/
├── linux/
│   ├── chrome-wayland.sh        # [MOVE] from fixes/chrome-wayland.sh
│   ├── dns-resolution.sh        # [MOVE] from fixes/dns-resolution.sh
│   └── electron-wayland.sh      # [MOVE] from fixes/electron-wayland.sh
└── macos/                       # [CREATE] for future macOS-specific fixes
```

### 4. Library Structure Improvement

Split the oversized library file:

```
lib/
├── dotfiles.sh                  # [MODIFY] Core functions and OS detection
├── linux.sh                    # [CREATE] Linux-specific functions
├── macos.sh                    # [CREATE] macOS-specific functions
└── bootstrap.sh                # [CREATE] Bootstrap-specific functions
```

### 5. Documentation Organization

Create a dedicated docs directory:

```
docs/
├── macos-plan.md               # [MOVE] from root
├── TODO.md                     # [MOVE] from root
└── CHANGELOG.md                # [CREATE] for tracking changes
```

### 6. Root Directory Cleanup

Clean up deprecated and temporary files:

```
# Files to remove:
- bootstrap.sh                   # [DELETE] deprecated
- bootstrap-macos.sh            # [DELETE] deprecated
- restructure-plan.md           # [DELETE] after restructuring complete
```

### Benefits of This Structure

1. **Clear platform separation**: Each platform has its own subdirectory
2. **Consistent organization**: Both platforms follow the same structure pattern
3. **Easier maintenance**: Platform-specific changes are contained in their respective directories
4. **Clearer installation flows**: The main `install.sh` will be simplified with clear platform-specific paths
5. **Better documentation**: Organized documentation that doesn't clutter the root directory
6. **Smaller, focused files**: Library functions split by responsibility and platform
7. **Future-proof**: Structure accommodates future platforms or fixes

## Implementation Order

1. **Phase 1**: Install directory restructuring
2. **Phase 2**: Config management separation  
3. **Phase 3**: Fixes directory organization
4. **Phase 4**: Library structure improvement
5. **Phase 5**: Documentation organization
6. **Phase 6**: Root directory cleanup

## Additional Restructuring Ideas

_(Continue examining for more opportunities)_

### 7. Script Consistency and Standards

**Issues Found:**
- Inconsistent error handling: Some scripts use `set -euo pipefail`, others don't
- Mixed dependency checking patterns: Some use `is_installed`, others use `command -v` directly
- Inconsistent script headers and documentation
- Various package installation approaches with different error handling

**Proposed Standards:**
```bash
# Standard script header template
#!/usr/bin/env bash
set -euo pipefail

# Source common functions
source "${DOTFILES_DIR}/lib/dotfiles.sh"

# Script-specific logic here
```

### 8. Enhanced Utility Script

**Current State**: The `bin/dotfiles` script is useful but limited

**Proposed Enhancements:**
```bash
# Add new commands:
dotfiles install [platform]     # Reinstall platform-specific packages
dotfiles config                 # Re-run configuration/stow
dotfiles update                 # Update everything (git pull, stow, packages)
dotfiles doctor                 # Check system health and dependencies
dotfiles clean                  # Clean up temporary files and caches
```

### 9. Dependency Management Improvements

**Current Issues:**
- No clear dependency declarations between scripts
- Some scripts assume prerequisites without checking
- No validation of system requirements before installation

**Proposed Solution:**
```bash
# Create dependency declaration system
# Each script declares its dependencies at the top
# Dependencies: [homebrew, git, curl]
# Platform: [macos, linux]
# Conflicts: [package-name]
```

### 10. Enhanced Error Handling and Logging

**Current Issues:**
- Inconsistent error messages and logging
- No centralized error handling
- Limited debugging capabilities

**Proposed Improvements:**
```bash
# Standardized logging functions
log_info() { echo "[INFO] $*"; }
log_warn() { echo "[WARN] $*" >&2; }
log_error() { echo "[ERROR] $*" >&2; }
log_debug() { [[ -n "${DEBUG:-}" ]] && echo "[DEBUG] $*"; }

# Enhanced error handling
handle_error() {
    log_error "Command failed: $*"
    log_error "Script: ${BASH_SOURCE[1]}, Line: ${BASH_LINENO[0]}"
    exit 1
}

trap 'handle_error "$BASH_COMMAND"' ERR
```

### 11. Package Management Unification

**Current Issues:**
- Different package managers handled differently
- No unified approach to package installation
- Limited ability to handle package conflicts

**Proposed Solution:**
```bash
# Create unified package management functions
install_package() {
    local package="$1"
    local method="${2:-auto}"  # auto, apt, snap, brew, manual
    
    case "$method" in
        auto) detect_and_install_package "$package" ;;
        apt) apt_install "$package" ;;
        snap) snap_install "$package" ;;
        brew) brew_install "$package" ;;
        manual) manual_install "$package" ;;
    esac
}
```

### 12. Installation Progress and Resumability

**Current Issues:**
- No progress tracking during installation
- Cannot resume interrupted installations
- No way to skip already completed steps

**Proposed Enhancement:**
```bash
# Add installation state tracking
INSTALL_STATE_FILE="${DOTFILES_DIR}/.install-state"

mark_step_complete() {
    echo "$1:$(date)" >> "$INSTALL_STATE_FILE"
}

is_step_complete() {
    grep -q "^$1:" "$INSTALL_STATE_FILE" 2>/dev/null
}

run_step() {
    local step="$1"
    if is_step_complete "$step"; then
        log_info "Skipping $step (already completed)"
        return 0
    fi
    
    log_info "Running $step"
    "$@"
    mark_step_complete "$step"
}
```
