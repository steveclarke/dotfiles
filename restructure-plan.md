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
dotfiles backup                 # Backup current configurations
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

### 11. Testing and Validation Framework

**Current State**: No testing framework or validation

**Proposed Structure:**
```
tests/
├── validate-install.sh          # Validate installation completeness
├── check-configs.sh             # Verify configuration files
├── test-scripts/                # Individual script tests
│   ├── test-macos-install.sh
│   └── test-linux-install.sh
└── integration/                 # Full integration tests
    ├── fresh-install-test.sh
    └── update-test.sh
```

### 12. Configuration Template System

**Current Issues:**
- Single `.dotfilesrc.template` file for all platforms
- No easy way to customize installation sets

**Proposed Enhancement:**
```
templates/
├── .dotfilesrc.template         # Base template
├── .dotfilesrc.macos.template   # macOS-specific template
├── .dotfilesrc.linux.template   # Linux-specific template
├── .dotfilesrc.minimal.template # Minimal installation template
└── .dotfilesrc.full.template    # Full installation template
```

### 13. Package Management Unification

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

### 14. Installation Progress and Resumability

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

### 16. Configuration Organization Analysis

**Current Configuration Patterns:**

**Stow Structure**: Each config directory follows GNU Stow convention:
```
configs/app_name/.config/app_name/
configs/app_name/.local/share/app_name/
configs/app_name/.dotfiles_specific_location/
```

**Configuration Categories:**
- **Cross-platform**: bash, fish, tmux, nvim, alacritty, ghostty, ruby, fonts, bin
- **Linux-specific**: i3, picom, polybar, rofi (window management)
- **Developer tools**: idea, just (development-specific configs)
- **Personal**: zellij layouts with project-specific configurations

**Template System**: Some configs use template files (e.g., `secrets.fish.template`) for user-specific customization

**Modular Structure**: Complex configs are well-organized:
- i3: `conf/`, `colors/`, `scripts/` subdirectories
- fish: `functions/`, `themes/`, `completions/`, `conf.d/`
- zellij: `layouts/` for different project workspaces

**Documentation**: Individual config directories include their own README files

**Issues with Current Organization:**

1. **Mixed Infrastructure**: `configs/stow.sh` is infrastructure code mixed with user content
2. **Platform Logic Scattered**: Platform-specific stowing logic in `stow.sh` rather than clear separation
3. **Personal Content**: Project-specific zellij layouts (unio, connon) are personal and shouldn't be in a public repo
4. **Template Management**: No clear system for template files and user customization
5. **Version Confusion**: Both `nvim/` and `nvim.slim/` exist without clear distinction

**Proposed Configuration Improvements:**

#### A. Move Infrastructure Out of Configs
```
.setup/
└── scripts/
    └── stow.sh                   # MOVED from configs/

configs/                          # Pure configuration content
├── bash/
├── fish/
├── nvim/
└── [other configs]
```

#### B. Template System Enhancement
```
configs/
├── fish/
│   └── .config/fish/
│       ├── secrets.fish.template
│       └── .gitignore            # Ignores secrets.fish
└── templates/                    # Centralized template directory
    ├── .dotfilesrc.template
    └── README.md                 # Template documentation
```

#### C. Clear Platform Separation in Stow Logic
```
.setup/scripts/stow.sh:
# Cross-platform configurations (always stowed)
CROSS_PLATFORM_CONFIGS=(bash fish tmux nvim alacritty ghostty ruby fonts bin idea just)

# Linux-specific configurations (conditional)
LINUX_CONFIGS=(i3 picom polybar rofi)

# macOS-specific configurations (conditional)  
MACOS_CONFIGS=()  # Add macOS-specific configs here
```

#### D. Personal Content Isolation
```
configs/
├── zellij/
│   └── .config/zellij/
│       ├── config.kdl
│       ├── layouts/
│       │   └── code.kdl          # Generic layout only
│       └── .gitignore            # Ignore personal layouts
└── .personal/                    # Git-ignored personal customizations
    └── zellij/
        └── layouts/
            ├── unio.kdl
            └── connon.kdl
```

#### E. Clear Version Management
```
configs/
├── nvim/                         # Current/main neovim config
└── .archive/                     # Git-ignored or separate branch
    └── nvim.old/                 # Archived configurations
```

**Benefits of Configuration Restructuring:**
- **Cleaner Separation**: Infrastructure completely separated from user content
- **Platform Clarity**: Clear distinction between cross-platform and platform-specific configs
- **Personal Privacy**: Personal project configs aren't exposed in public repo
- **Template System**: Centralized template management
- **Version Control**: Clear distinction between active and archived configurations

## Conceptual Organization Issues

### 15. Infrastructure vs. Dotfiles Content Separation

**The Core Problem:**
The repository currently mixes two fundamentally different types of content:

1. **Setup Infrastructure** (exists only during installation/management):
   - `install/` - Installation scripts
   - `lib/` - Support functions for installation
   - `setups/` - Configuration scripts
   - `fixes/` - System fixes
   - `install.sh`, `bootstrap*.sh` - Entry point scripts
   - Documentation files (`README.md`, `TODO.md`, etc.)

2. **Actual Dotfiles Content** (lives on target machine):
   - `configs/` - Configuration files to be stowed
   - `bin/` - Utility scripts added to user's PATH
   - `Brewfile*` - Package definitions (though these could be argued either way)

**Why This Matters:**
- Creates conceptual confusion about what serves what purpose
- Makes it harder to understand the repository structure
- Potential for setup-only content to accidentally get mixed with user content
- Difficult to separate concerns when maintaining the codebase

**Proposed Solution Options:**

#### Option A: Top-level Separation
```
dotfiles/
├── setup/                        # All installation/management infrastructure
│   ├── install/
│   ├── lib/
│   ├── setups/
│   ├── fixes/
│   ├── docs/
│   ├── install.sh
│   └── README.md
├── dotfiles/                     # Actual dotfiles content
│   ├── configs/
│   ├── bin/
│   ├── Brewfile*
│   └── .dotfilesrc.template
└── [root files like .gitignore, VERSION]
```

#### Option B: Setup Subdirectory
```
dotfiles/
├── .setup/                       # Hidden setup infrastructure
│   ├── install/
│   ├── lib/
│   ├── setups/
│   ├── fixes/
│   ├── docs/
│   └── install.sh
├── configs/                      # Actual dotfiles content
├── bin/
├── Brewfile*
├── .dotfilesrc.template
└── README.md                     # Keep user-facing docs at root
```

#### Option C: Infrastructure Subdirectory
```
dotfiles/
├── _infrastructure/              # Underscore indicates internal
│   ├── install/
│   ├── lib/
│   ├── setups/
│   ├── fixes/
│   ├── docs/
│   └── scripts/
│       ├── install.sh
│       └── bootstrap*.sh
├── configs/
├── bin/
├── Brewfile*
├── .dotfilesrc.template
└── README.md
```

**Recommendation: Option B (.setup/ subdirectory)**

**Advantages:**
- Clear conceptual separation
- Hidden directory (`.setup/`) indicates it's infrastructure
- Keeps user-facing content at root level
- Maintains familiar entry points
- Easy to ignore setup infrastructure when browsing dotfiles content

**Updated Entry Points:**
```bash
# Installation becomes:
cd ~/.local/share/dotfiles
bash .setup/install.sh

# Or create a simple root-level installer:
bash install.sh  # -> sources .setup/install.sh
```

**Implementation Impact:**
- All setup scripts need path updates
- Documentation needs updates
- Installation instructions need minor changes
- Could maintain backward compatibility with root-level install.sh wrapper

## Implementation Priority

**High Priority** (Core structure):
1. **Conceptual separation** - Infrastructure vs. dotfiles content
2. Install directory restructuring
3. Config management separation
4. Script consistency and standards
5. Root directory cleanup

**Medium Priority** (Enhanced functionality):
6. Library structure improvement
7. Enhanced utility script
8. Documentation organization
9. Error handling improvements

**Low Priority** (Advanced features):
10. Testing framework
11. Configuration templates
12. Package management unification
13. Installation progress tracking

**Detailed Analysis of Current Content Types:**

**Infrastructure/Setup Files** (exist only during installation):
- `install/` + all subdirectories - installation scripts that install packages/software
- `lib/dotfiles.sh` - utility functions used by setup scripts
- `setups/` - configuration scripts that modify system settings
- `fixes/` - system-specific fixes and workarounds  
- `install.sh`, `bootstrap*.sh` - entry point scripts
- `configs/stow.sh` - stow configuration script (infrastructure!)
- Documentation: `README.md`, `about.md`, `TODO.md`, `macos-plan.md`

**Actual Dotfiles Content** (deployed to target machine):
- `bin/dotfiles` - utility script added to user's PATH
- `configs/*/` - configuration files stowed to `~/.config/` and other locations
- `Brewfile*` - package definitions (referenced by deployed `dotfiles` script)
- `.dotfilesrc.template` - template for user configuration

**Edge Cases to Consider:**
- `Brewfile*` - Used by both setup (installation) AND runtime (`dotfiles` script)
- `.dotfilesrc.template` - Setup file that becomes user content after customization
- `configs/stow.sh` - This is setup infrastructure, NOT dotfiles content (despite being in configs/)

**Implementation Considerations:**

1. **Stow Configuration Separation**: `configs/stow.sh` is actually infrastructure - it orchestrates the stowing process but isn't stowed itself
2. **Brewfile Accessibility**: The deployed `dotfiles` script needs access to Brewfiles for updates
3. **Cross-references**: Setup scripts reference files that will later be user content
4. **Backup/Migration**: Clear separation would make it easier to backup just user content vs. full repo

**Proposed Solution Refinement:**

```
dotfiles/
├── .setup/                       # Hidden infrastructure directory
│   ├── install/
│   ├── lib/
│   ├── setups/
│   ├── fixes/
│   ├── scripts/
│   │   ├── stow.sh               # MOVED from configs/
│   │   └── install.sh
│   └── docs/
│       ├── README.md
│       ├── about.md
│       └── TODO.md
├── configs/                      # Pure dotfiles content
│   ├── bash/
│   ├── fish/
│   ├── nvim/
│   └── [other config dirs]
├── bin/                          # User utilities
│   └── dotfiles
├── Brewfile*                     # Package definitions (accessible to both)
├── .dotfilesrc.template          # User configuration template
├── README.md                     # Keep user-facing README at root
└── [git files: .gitignore, etc.]
```

**Key Benefits of This Separation:**
- **Mental Clarity**: Immediately obvious what's infrastructure vs. user content
- **Easier Maintenance**: Setup code isolated from user configurations
- **Backup Strategy**: Users can easily backup just their customizations
- **Repository Browsing**: Users primarily interested in configurations won't see setup clutter
- **Development**: Setup infrastructure can be modified without affecting user content structure

**Implementation Impact:**
- All setup scripts need path updates (`.setup/lib/dotfiles.sh`)
- Documentation needs updates  
- `configs/stow.sh` needs to be moved to `.setup/scripts/stow.sh`
- Entry point could be a thin wrapper: `bash .setup/scripts/install.sh`

### 17. Documentation and Entry Point Organization

**Current Documentation Structure:**
- **README.md** - Main documentation, well-structured but long
- **about.md** - Repository overview and deprecated script warnings
- **TODO.md** - Basic task list (only 4 lines)
- **macos-plan.md** - Large macOS-specific planning document
- **VERSION** - Simple version file
- **Individual config READMEs** - Each complex config has its own README

**Current Entry Points:**
- **install.sh** - Main unified installation script
- **bootstrap.sh** - Deprecated Linux bootstrap (kept for compatibility)
- **bootstrap-macos.sh** - Deprecated macOS bootstrap (kept for compatibility)
- **bin/dotfiles** - User utility script (simple but useful)

**Root-Level Organization Issues:**

1. **Mixed Content Types**: Documentation mixed with scripts, templates, and package definitions
2. **Planning Documents**: `macos-plan.md` is development planning, not user documentation
3. **Deprecated Scripts**: Bootstrap scripts taking up root-level space
4. **Package Definitions**: Brewfiles at root level creating clutter
5. **Template Files**: Configuration templates mixed with operational files

**Comprehensive Repository Restructuring:**

#### Root Directory - Clean Entry Points Only
```
dotfiles/
├── install.sh                    # Main installation script
├── README.md                     # Brief overview, points to docs/
├── .dotfilesrc.template          # Main configuration template
├── .gitignore                    # Git ignore rules
├── VERSION                       # Version information
├── Brewfile                      # Core CLI packages
├── Brewfile.macos                # macOS-specific packages
└── [directories below]
```

#### Setup Infrastructure Directory
```
.setup/                           # All setup-related infrastructure
├── scripts/
│   ├── stow.sh                   # MOVED from configs/
│   ├── platform-detection.sh    # Common platform detection
│   └── common-functions.sh      # Shared utility functions
├── install/                      # MOVED from install/
│   ├── linux/
│   │   ├── prereq/
│   │   ├── cli/
│   │   ├── apps/
│   │   └── desktop-entries/
│   ├── macos/
│   │   ├── prereq/
│   │   ├── cli/
│   │   └── apps/
│   ├── common/                   # Cross-platform installs
│   │   ├── cli/
│   │   └── apps/
│   └── optional/                 # Optional installs
├── setups/                       # MOVED from setups/
│   ├── linux/
│   ├── macos/
│   └── common/
├── fixes/                        # MOVED from fixes/
│   ├── linux/
│   └── macos/
└── templates/                    # Configuration templates
    ├── .dotfilesrc.template
    └── README.md
```

#### User Content Directory
```
configs/                          # Pure user configuration content
├── bash/
├── fish/
├── nvim/
├── tmux/
├── alacritty/
├── ghostty/
├── zellij/
├── ruby/
├── fonts/
├── bin/                          # User utility scripts
├── linux/                       # Linux-specific configs
│   ├── i3/
│   ├── picom/
│   ├── polybar/
│   └── rofi/
└── .personal/                    # Git-ignored personal configs
    └── zellij/
        └── layouts/
```

#### Documentation Directory
```
docs/                            # All documentation
├── README.md                    # Comprehensive user guide
├── installation/
│   ├── linux.md
│   ├── macos.md
│   └── troubleshooting.md
├── configuration/
│   ├── overview.md
│   ├── customization.md
│   └── app-specific/
│       ├── fish.md
│       ├── nvim.md
│       └── zellij.md
├── development/
│   ├── contributing.md
│   ├── architecture.md
│   └── macos-plan.md          # MOVED from root
└── CHANGELOG.md
```

#### Library Directory (Enhanced)
```
lib/                             # Support libraries
├── dotfiles.sh                  # ENHANCED main library
├── platform.sh                 # Platform detection utilities
├── packages.sh                  # Package management utilities
├── config.sh                    # Configuration management utilities
└── logging.sh                   # Logging and output utilities
```

#### Archive Directory
```
.archive/                        # Historical/deprecated content
├── bootstrap.sh                 # MOVED from root
├── bootstrap-macos.sh           # MOVED from root
├── configs/
│   └── nvim.old/               # MOVED from configs/
└── docs/
    └── old-planning/
        └── legacy-notes.md
```

**Enhanced Entry Points:**

#### Improved bin/dotfiles Script
```bash
#!/usr/bin/env bash
# Enhanced functionality:
dotfiles install [linux|macos]   # Run installation
dotfiles stow                     # Update configurations
dotfiles brew                     # Update packages
dotfiles update                   # Full update (stow + brew)
dotfiles config [edit|validate]  # Configuration management
dotfiles doctor                   # Health check
dotfiles backup                   # Backup configurations
dotfiles restore                  # Restore from backup
dotfiles version                  # Show version info
dotfiles help                     # Show detailed help
```

#### Simplified install.sh
```bash
#!/usr/bin/env bash
# Main installation script - simplified and cleaner
# Delegates to .setup/scripts/ for actual work
# Focuses on user experience and clear progress indication
```

**Benefits of Complete Restructuring:**

1. **Crystal Clear Separation**: Infrastructure completely separated from user content
2. **Improved User Experience**: Clean root directory, comprehensive documentation
3. **Better Maintainability**: Logical grouping of related functionality
4. **Enhanced Discoverability**: Clear documentation structure
5. **Development Friendly**: Planning docs separate from user docs
6. **Clean History**: Deprecated content archived but preserved
7. **Extensible Architecture**: Easy to add new platforms or configurations

**Migration Path:**
1. Create new directory structure
2. Move files maintaining git history (`git mv`)
3. Update all path references in scripts
4. Update documentation links
5. Add deprecation warnings to old paths
6. Test thoroughly on both platforms
7. Update CI/CD if applicable

This comprehensive restructuring addresses all the conceptual issues you identified and creates a truly maintainable, extensible dotfiles repository structure.
