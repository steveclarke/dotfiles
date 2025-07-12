# Comprehensive Script Migration Plan

## Overview

This document outlines a comprehensive phased plan to migrate all existing scripts in the dotfiles repository to take full advantage of the newly introduced systems:

- **Dependency Management System** - Standardized dependency declarations and validation
- **Logging and Error Handling System** - Enhanced logging, progress tracking, and error context
- **Unified Package Management System** - Cross-platform package installation with intelligent fallbacks
- **Resumable Installation System** - State tracking and resumable installations
- **Standard Script Header Template** - Consistent script structure and error handling

## Migration Status Overview

### ✅ Already Modernized (Core Infrastructure)
- `lib/dotfiles.sh` - Enhanced with all new systems
- `lib/logging.sh` - Complete logging implementation
- `lib/package-management.sh` - Full unified package management
- `lib/dependencies.sh` - Comprehensive dependency management
- `lib/installation-state.sh` - Full resumable installation system
- `bin/dotfiles` - Complete utility with all new commands
- `install.sh` - Uses resumable installation system

### 🔄 Partially Modernized (Need Updates)
- Some individual installation scripts have dependency declarations but need full modernization
- Main orchestration scripts use new libraries but individual scripts still use old patterns

### ❌ Needs Full Modernization
- Most installation scripts (70+ files)
- All setup scripts
- Fix scripts
- Platform-specific scripts

## Phase 1: Critical Infrastructure Scripts (Week 1)

### Priority: HIGH - Scripts that are entry points or affect core functionality

#### 1.1 Platform Prerequisites Scripts
**Status**: Partial modernization needed

**Files to Update**:
- `install/linux/prereq.sh` ✅ Has orchestration pattern
- `install/macos/prereq.sh` ✅ Has proper header
- `install/linux/prereq/*.sh` - 7 files ❌ Need full modernization
- `install/macos/*.sh` - 4 files 🔄 Need dependency declarations

**Migration Tasks**:
- [ ] Add standard headers with dependency declarations
- [ ] Replace `apt_install` with `install_package` unified calls
- [ ] Add progress tracking with `progress_start/step/complete`
- [ ] Add proper error handling and logging
- [ ] Add conflict detection where applicable

**Example Transformation** (`install/linux/prereq/stow.sh`):
```bash
# BEFORE:
SCRIPT_DEPENDS_COMMANDS=("apt" "dpkg")
SCRIPT_DEPENDS_PLATFORM=("linux")
SCRIPT_DEPENDS_DISTRO=("ubuntu")
SCRIPT_DEPENDS_ENV=("DOTFILES_DIR")

apt_install stow

# AFTER:
#!/usr/bin/env bash
# [Standard header with metadata]
set -euo pipefail

source "${DOTFILES_DIR}/lib/linux.sh"

# Enhanced dependency declarations
SCRIPT_DEPENDS_COMMANDS=("apt" "dpkg")
SCRIPT_DEPENDS_PLATFORM=("linux")
SCRIPT_DEPENDS_DISTRO=("ubuntu")
SCRIPT_DEPENDS_ENV=("DOTFILES_DIR")
SCRIPT_DEPENDS_PACKAGES=("ca-certificates")

install_stow() {
    log_banner "Installing GNU Stow"
    
    if is_package_installed "stow"; then
        log_warn "GNU Stow is already installed"
        return 0
    fi
    
    log_info "Installing GNU Stow for configuration management"
    if install_package "stow" "apt"; then
        log_success "GNU Stow installed successfully"
    else
        log_error "Failed to install GNU Stow"
        return 1
    fi
}

install_stow
```

#### 1.2 Core Orchestration Scripts
**Status**: Partial modernization needed

**Files to Update**:
- `install/linux/cli.sh` 🔄 Has orchestration but lacks logging
- `install/linux/apps.sh` 🔄 Has orchestration but lacks logging
- `install/linux/desktop-entries.sh` ❌ Very basic
- Platform-specific orchestrators

**Migration Tasks**:
- [ ] Add proper logging and progress tracking
- [ ] Add dependency validation before running sub-scripts
- [ ] Enhance error handling for failed sub-scripts
- [ ] Add summary reporting

## Phase 2: Command Line Tools (Week 2)

### Priority: HIGH - Essential development tools

#### 2.1 CLI Installation Scripts
**Directory**: `install/linux/cli/`
**Files**: 12 scripts ❌ Need full modernization

**Scripts to Update**:
1. `docker.sh` ✅ Already modernized (good example)
2. `fish.sh` 🔄 Has dependencies but needs modernization
3. `htop.sh` ❌ Basic one-liner
4. `nala.sh` ❌ Basic one-liner  
5. `digital-ocean-cli.sh` ❌ Needs review
6. `fastfetch.sh` ❌ Needs review
7. `heroku.sh` ❌ Needs review
8. `homebrew.sh` ❌ Needs review
9. `mise.sh` ❌ Needs review
10. `ollama.sh` ❌ Needs review
11. `sshd.sh` ❌ Needs review
12. `vim.sh` ❌ Needs review
13. `wavemon.sh` ❌ Needs review
14. `wl-clipboard.sh` ❌ Needs review
15. `xclip.sh` ❌ Needs review

**Migration Pattern for Simple One-Liners**:
```bash
# BEFORE (htop.sh):
sudo apt install -y htop

# AFTER:
#!/usr/bin/env bash
#
# Script Name: htop.sh
# Description: Install htop system monitor
# Platform: linux
# Dependencies: Package manager (apt/snap/flatpak)
#

set -euo pipefail
source "${DOTFILES_DIR}/lib/linux.sh"

# Dependency declarations
SCRIPT_DEPENDS_COMMANDS=("apt")
SCRIPT_DEPENDS_PLATFORM=("linux")
SCRIPT_DEPENDS_ENV=("DOTFILES_DIR")

install_htop() {
    log_banner "Installing htop"
    
    if is_package_installed "htop"; then
        log_warn "htop is already installed"
        return 0
    fi
    
    log_info "Installing htop system monitor"
    if install_package "htop" "auto"; then
        log_success "htop installed successfully"
        log_info "Launch with: htop"
    else
        log_error "Failed to install htop"
        return 1
    fi
}

install_htop
```

#### 2.2 macOS CLI Scripts
**Directory**: `install/macos/`
**Files**: 5 scripts 🔄 Need enhancement

**Scripts to Update**:
1. `brew.sh` 🔄 Has proper header and dependencies
2. `fish.sh` ❌ Needs review
3. `fonts.sh` 🔄 Has dependencies but needs enhanced logging
4. `zsh.sh` ❌ Needs review

## Phase 3: GUI Applications (Week 3)

### Priority: MEDIUM - User applications

#### 3.1 Linux GUI Applications  
**Directory**: `install/linux/apps/`
**Files**: 35+ scripts ❌ Need full modernization

**High Priority Apps** (Development tools):
1. `vscode.sh` ✅ Already well modernized (good example)
2. `chrome.sh` 🔄 Partially modernized but needs enhancement
3. `1password.sh` ❌ Basic installation
4. `brave.sh` ❌ Needs review
5. `jetbrains-toolbox.sh` ❌ Needs review
6. `postman.sh` ❌ Needs review

**Medium Priority Apps** (Productivity):
1. `discord.sh` ❌ Needs review
2. `spotify.sh` ❌ Needs review
3. `telegram.sh` ❌ Needs review
4. `thunderbird.sh` ❌ Needs review
5. `libreoffice.sh` 🔄 Basic but functional
6. `obsidian.sh` ❌ Needs review

**Lower Priority Apps** (Specialized tools):
1. `audacity.sh` ❌ Needs review
2. `handbrake.sh` ❌ Needs review
3. `vlc.sh` ❌ Needs review
4. `transmission.sh` ❌ Needs review
5. And 20+ more...

**Migration Pattern for Basic Installers**:
```bash
# BEFORE (basic snap install):
snap_install app-name

# AFTER:
#!/usr/bin/env bash
#
# Script Name: app-name.sh
# Description: Install Application Name
# Platform: linux
# Dependencies: Package managers, optional manual installation
#

set -euo pipefail
source "${DOTFILES_DIR}/lib/linux.sh"

# Dependency declarations
SCRIPT_DEPENDS_COMMANDS=("snap")
SCRIPT_DEPENDS_PLATFORM=("linux")
SCRIPT_DEPENDS_ENV=("DOTFILES_DIR")
SCRIPT_DEPENDS_CONFLICTS=("apt:app-name")  # If conflicts exist

# Manual installation function (if needed)
install_app_manual() {
    log_info "Installing Application Name via manual method"
    # Custom installation logic here
    return 0
}

install_app() {
    log_banner "Installing Application Name"
    
    if is_package_installed "app-name"; then
        log_warn "Application Name is already installed"
        return 0
    fi
    
    # Check conflicts
    if ! check_package_conflicts "app-name" "${SCRIPT_DEPENDS_CONFLICTS:-}"; then
        log_error "Package conflicts detected"
        return 1
    fi
    
    log_info "Installing Application Name using unified package management"
    if install_package "app-name" "snap" "--classic" "install_app_manual"; then
        log_success "Application Name installed successfully"
        log_info "Launch with: app-name"
    else
        log_error "Failed to install Application Name"
        return 1
    fi
}

install_app
```

#### 3.2 Desktop Entries
**Directory**: `install/linux/desktop-entries/`
**Files**: 3 scripts ❌ Basic implementations

**Migration Tasks**:
- [ ] Add proper headers and dependency declarations
- [ ] Add validation for required icon files
- [ ] Add proper error handling

## Phase 4: Optional Installations (Week 4)

### Priority: LOW - Optional and specialized tools

#### 4.1 Linux Optional Tools
**Directory**: `install/linux/optional/`
**Files**: 25+ scripts ❌ Mixed quality

**High Priority Optional**:
1. `cursor.sh` ❌ Development tool
2. `terraform.sh` 🔄 Has proper header but needs unified package management
3. `slack.sh` ❌ Communication tool
4. `zoom.sh` ❌ Communication tool

**Medium Priority Optional**:
1. `steam.sh` ❌ Gaming
2. `virtualbox.sh` ❌ Virtualization
3. `docker.sh` ❌ If not in main CLI
4. `microsoft-edge.sh` ❌ Browser alternative

**Lower Priority Optional**:
1. `anki.sh` ❌ Study tool
2. `insync.sh` 🔄 Has manual .deb installation
3. `solaar.sh` ❌ Hardware tool
4. And 15+ more...

#### 4.2 Cross-Platform Optional
**Directory**: `install/optional/`
**Files**: Mostly documentation currently

**Migration Tasks**:
- [ ] Review and categorize existing optional scripts
- [ ] Create true cross-platform optional installers
- [ ] Document platform-specific limitations

## Phase 5: System Setup Scripts (Week 5)

### Priority: MEDIUM - System configuration

#### 5.1 Cross-Platform Setup Scripts
**Directory**: `setups/`
**Files**: 3 scripts 🔄 Need modernization

**Scripts to Update**:
1. `stow.sh` 🔄 Has proper header but needs enhanced logging and progress tracking
2. `git.sh` ❌ Very basic, needs full modernization
3. `ssh.sh` 🔄 Has proper header but needs enhanced error handling

**Migration Pattern for Setup Scripts**:
```bash
# BEFORE (git.sh):
git config --global color.ui true
git config --global user.name "${DOTFILES_GIT_USER_NAME}"
git config --global user.email "${DOTFILES_GIT_USER_EMAIL}"
git config --global pull.rebase false
git config --global init.defaultBranch master

# AFTER:
#!/usr/bin/env bash
#
# Script Name: git.sh
# Description: Configure global Git settings
# Platform: cross-platform
# Dependencies: git, environment variables
#

set -euo pipefail
source "${DOTFILES_DIR}/lib/dotfiles.sh"

# Dependency declarations
SCRIPT_DEPENDS_COMMANDS=("git")
SCRIPT_DEPENDS_PLATFORM=("linux" "macos")
SCRIPT_DEPENDS_ENV=("DOTFILES_GIT_USER_NAME" "DOTFILES_GIT_USER_EMAIL")
SCRIPT_DEPENDS_MINIMUM_VERSION=("git:2.0")

configure_git() {
    log_banner "Configuring Git"
    
    progress_start 6 "Git Configuration"
    
    progress_step "Setting color output"
    if git config --global color.ui true; then
        log_debug "✓ Git color output enabled"
    else
        log_error "Failed to set Git color output"
        return 1
    fi
    
    progress_step "Setting user name"
    if git config --global user.name "${DOTFILES_GIT_USER_NAME}"; then
        log_debug "✓ Git user name set to: ${DOTFILES_GIT_USER_NAME}"
    else
        log_error "Failed to set Git user name"
        return 1
    fi
    
    progress_step "Setting user email"
    if git config --global user.email "${DOTFILES_GIT_USER_EMAIL}"; then
        log_debug "✓ Git user email set to: ${DOTFILES_GIT_USER_EMAIL}"
    else
        log_error "Failed to set Git user email"
        return 1
    fi
    
    progress_step "Setting pull strategy"
    if git config --global pull.rebase false; then
        log_debug "✓ Git pull strategy set to merge"
    else
        log_error "Failed to set Git pull strategy"
        return 1
    fi
    
    progress_step "Setting default branch"
    if git config --global init.defaultBranch master; then
        log_debug "✓ Git default branch set to master"
    else
        log_error "Failed to set Git default branch"
        return 1
    fi
    
    progress_step "Validating configuration"
    local current_name current_email
    current_name=$(git config --global user.name)
    current_email=$(git config --global user.email)
    
    log_info "Git configuration summary:"
    log_info "  User: $current_name <$current_email>"
    log_info "  Default branch: $(git config --global init.defaultBranch)"
    log_info "  Pull strategy: merge (no rebase)"
    
    progress_complete
    log_success "Git configuration completed successfully"
}

# Validate required environment variables
validate_required_vars "DOTFILES_GIT_USER_NAME" "DOTFILES_GIT_USER_EMAIL"

configure_git
```

#### 5.2 Platform-Specific Setup Scripts

**Linux Setup Scripts** (`setups/linux/`):
- Files: 6 scripts 🔄 Mixed modernization needs

1. `stow-linux.sh` 🔄 Has proper header, needs enhanced logging
2. `gnome-extensions.sh` ❌ Complex script, needs full modernization
3. `gnome-hotkeys.sh` ❌ Basic script, needs modernization
4. `lofree.sh` 🔄 Has proper sourcing but needs modernization
5. `disable-app-armor.sh` ❌ Simple script, needs modernization

**macOS Setup Scripts** (`setups/macos/`):
- Files: 2 scripts 🔄 Mixed modernization needs

1. `stow-macos.sh` 🔄 Has proper header, minimal content
2. `macos-defaults.sh` ✅ Well-structured but could use enhanced logging

## Phase 6: Fix Scripts (Week 6)

### Priority: LOW - Platform-specific fixes

#### 6.1 Linux Fix Scripts
**Directory**: `fixes/linux/`
**Files**: 3 scripts ❌ Need full modernization

**Scripts to Update**:
1. `chrome-wayland.sh` ❌ Needs review
2. `dns-resolution.sh` ❌ Needs review  
3. `electron-wayland.sh` ❌ Needs review

#### 6.2 macOS Fix Scripts
**Directory**: `fixes/macos/`
**Files**: Currently empty

## Implementation Guidelines

### Standard Migration Checklist

For each script, ensure:

#### ✅ Header and Metadata
- [ ] Standard shebang: `#!/usr/bin/env bash`
- [ ] Complete metadata comment block
- [ ] Platform specification
- [ ] Dependency documentation

#### ✅ Error Handling
- [ ] `set -euo pipefail`
- [ ] Source appropriate library (`lib/linux.sh`, `lib/macos.sh`, or `lib/dotfiles.sh`)
- [ ] Automatic error handling setup

#### ✅ Dependency Declarations
- [ ] `SCRIPT_DEPENDS_COMMANDS` - Required commands
- [ ] `SCRIPT_DEPENDS_PLATFORM` - Platform compatibility
- [ ] `SCRIPT_DEPENDS_PACKAGES` - Required packages (if any)
- [ ] `SCRIPT_DEPENDS_ENV` - Required environment variables
- [ ] `SCRIPT_DEPENDS_CONFLICTS` - Conflicting packages (if any)
- [ ] Other dependency types as needed

#### ✅ Enhanced Functionality
- [ ] Use `log_banner` for operation banners
- [ ] Use `log_info/warn/error/success` for status messages
- [ ] Use `progress_start/step/complete` for multi-step operations
- [ ] Use `install_package` instead of direct package manager calls
- [ ] Use `is_package_installed` for duplicate installation checks
- [ ] Add manual installation functions for complex packages

#### ✅ Validation and Error Handling
- [ ] Validate required environment variables
- [ ] Check for conflicts before installation
- [ ] Provide helpful error messages and troubleshooting suggestions
- [ ] Return appropriate exit codes

### Script Categorization

#### Simple Scripts (One-line installers)
**Effort**: Low (30-60 minutes each)
**Examples**: `htop.sh`, `nala.sh`, `vim.sh`
**Pattern**: Standard header + unified package installation

#### Complex Scripts (Multiple steps/manual installation)  
**Effort**: Medium (2-4 hours each)
**Examples**: `docker.sh`, `vscode.sh`, `terraform.sh`
**Pattern**: Progress tracking + unified package management + manual fallbacks

#### System Configuration Scripts
**Effort**: Medium-High (3-6 hours each)
**Examples**: `gnome-extensions.sh`, `macos-defaults.sh`
**Pattern**: Enhanced logging + validation + progress tracking

### Testing Strategy

#### Phase Testing
After each phase:
1. **Dependency Testing**: `dotfiles test dependencies`
2. **Script Validation**: `dotfiles test script <script>`
3. **Full Installation Testing**: `dotfiles install` on clean system
4. **Resume Testing**: Interrupt and resume installation

#### Integration Testing
1. **Cross-Platform Testing**: Test on both Linux and macOS
2. **Package Manager Testing**: Test with different package managers available
3. **Conflict Testing**: Test conflict detection and resolution
4. **Error Recovery Testing**: Test error handling and recovery

### Documentation Updates

After migration:
1. **Update main README.md** with new capabilities
2. **Update individual script documentation** in `docs/`
3. **Create migration guide** for users upgrading
4. **Update troubleshooting guide** with new error patterns

## Success Metrics

### Completion Criteria
- [ ] All 100+ scripts have standard headers
- [ ] All scripts use unified package management
- [ ] All scripts have proper dependency declarations
- [ ] All scripts use enhanced logging and error handling
- [ ] 100% pass rate on `dotfiles test dependencies`
- [ ] Successful clean installation testing on both platforms
- [ ] Successful resume functionality testing

### Quality Metrics
- [ ] No direct package manager calls (except in unified system)
- [ ] Consistent error handling across all scripts
- [ ] Progress tracking for all multi-step operations
- [ ] Comprehensive conflict detection
- [ ] Informative help text and error messages

### Performance Metrics
- [ ] Faster installation due to unified package management caching
- [ ] Reduced network calls due to package availability caching
- [ ] Improved reliability due to enhanced error handling
- [ ] Better user experience due to progress tracking and clear messaging

## Timeline Summary

- **Week 1**: Phase 1 - Critical Infrastructure (5-7 scripts)
- **Week 2**: Phase 2 - CLI Tools (15+ scripts)  
- **Week 3**: Phase 3 - GUI Applications (35+ scripts)
- **Week 4**: Phase 4 - Optional Installations (25+ scripts)
- **Week 5**: Phase 5 - Setup Scripts (10+ scripts)
- **Week 6**: Phase 6 - Fix Scripts and Final Testing (5+ scripts)

**Total Estimated Effort**: 6 weeks for complete migration of 100+ scripts

This migration will result in a significantly more robust, maintainable, and user-friendly dotfiles installation system with comprehensive error handling, unified package management, dependency validation, and resumable installations.
