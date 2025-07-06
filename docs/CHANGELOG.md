# Changelog

All notable changes to this dotfiles repository will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Phase 4: Library Structure Improvement
  - Created `lib/linux.sh` for Linux-specific functions
  - Created `lib/macos.sh` for macOS-specific functions  
  - Created `lib/bootstrap.sh` for bootstrap-specific functions
- Phase 5: Documentation Organization
  - Created `docs/` directory for centralized documentation
  - Added comprehensive `docs/CHANGELOG.md` for tracking changes
  - Moved `TODO.md` to `docs/TODO.md`
  - Updated `README.md` with new structure information and migration notes
- Phase 6: Root Directory Cleanup
  - Moved temporary restructuring files to `docs/` directory for archival
  - Verified no deprecated bootstrap files exist
  - Cleaned up root directory for better organization

### Changed
- Phase 1: Install Directory Restructuring
  - Moved all Linux install files to `install/linux/` directory structure
  - Updated `install.sh` to use new Linux-specific paths
  - Reorganized CLI, apps, prereq, and desktop-entries under platform-specific directories

- Phase 2: Config Management Separation
  - Created `configs/linux/` and `configs/macos/` directories
  - Split stow configurations into platform-specific scripts
  - Modified `configs/stow.sh` to contain only cross-platform configurations

- Phase 3: Fixes Directory Organization
  - Created `fixes/linux/` and `fixes/macos/` directories
  - Moved Linux-specific fixes to `fixes/linux/` subdirectory

- Phase 4: Library Structure Improvement
  - **MAJOR REFACTORING**: Split oversized `lib/dotfiles.sh` (275 lines) into focused modules
  - Reduced core `lib/dotfiles.sh` from 275 lines to 35 lines
  - Updated 10+ scripts to use appropriate platform-specific libraries
  - Improved code organization and maintainability significantly

### Removed
- Deprecated bootstrap files (`bootstrap.sh`, `bootstrap-macos.sh`)
- Moved functions from monolithic `lib/dotfiles.sh` to specialized modules

### Fixed
- Resolved library dependency issues with proper sourcing chain
- Improved cross-platform compatibility in configuration management

## [Previous Versions]

### Historical Structure
- Originally had monolithic install scripts in root directory
- Single large `lib/dotfiles.sh` containing all functions
- Mixed platform-specific and cross-platform configurations

---

## Migration Guide

### For Users Updating from Previous Structure

1. **Library Functions**: If you've customized any functions in `lib/dotfiles.sh`, check the new library modules:
   - Linux-specific functions → `lib/linux.sh`
   - macOS-specific functions → `lib/macos.sh`
   - Bootstrap functions → `lib/bootstrap.sh`
   - Core functions remain in `lib/dotfiles.sh`

2. **Script Sourcing**: Scripts now source platform-specific libraries:
   - Scripts using Linux functions should source `lib/linux.sh`
   - Scripts using macOS functions should source `lib/macos.sh`
   - Scripts using bootstrap functions should source `lib/bootstrap.sh`

3. **Directory Structure**: Install scripts moved to platform-specific directories:
   - Linux install scripts → `install/linux/`
   - macOS install scripts → `install/macos/`
   - Configs split between cross-platform and platform-specific

### Testing Your Setup

After updating, verify your setup works correctly:

```bash
# Test library loading
source lib/dotfiles.sh && echo "Core: OK"
source lib/linux.sh && echo "Linux: OK"
source lib/macos.sh && echo "macOS: OK"
source lib/bootstrap.sh && echo "Bootstrap: OK"

# Test main scripts
bash -n install.sh
bash -n bin/dotfiles
bash -n configs/stow.sh
```

---

## Development Notes

### Restructuring Principles

1. **Platform Separation**: Clear separation between Linux, macOS, and cross-platform code
2. **Modular Libraries**: Split large monolithic files into focused, single-purpose modules
3. **Dependency Management**: Proper sourcing chain to avoid circular dependencies
4. **Documentation**: Comprehensive documentation for all changes

### Impact Assessment

- **Code Maintainability**: ⬆️ Significantly improved
- **Platform Support**: ⬆️ Enhanced cross-platform compatibility
- **Development Speed**: ⬆️ Faster due to focused modules
- **User Experience**: ⬆️ Better organization and clarity

### Future Improvements

- Enhanced error handling and logging (Phase 10)
- Unified package management (Phase 11)
- Installation progress tracking (Phase 12)
- Enhanced utility commands (Phase 8) 

## Phase 7: Script Consistency and Standards (In Progress)

### 7.1 Script Header Standardization ✅ COMPLETED
- **Created**: `docs/script-header-template.md` - Standard template for all bash scripts
- **Standardized headers** for key scripts with:
  - Consistent shebang (`#!/usr/bin/env bash`)
  - Script metadata (name, description, platform, dependencies)
  - Error handling (`set -euo pipefail`)
  - Proper library sourcing
  - Clear documentation

### 7.2 Updated Scripts (11 scripts standardized) ✅ COMPLETED
- **Main Scripts**:
  - `install.sh` - Main installation script with cross-platform support
  - `bin/dotfiles` - Utility script for managing dotfiles
  - `configs/stow.sh` - Cross-platform configuration stowing
  - `configs/linux/stow-linux.sh` - Linux-specific configs
  - `configs/macos/stow-macos.sh` - macOS-specific configs

- **Installation Scripts**:
  - `install/linux/prereq.sh` - Linux prerequisites aggregator
  - `install/linux/cli.sh` - Linux CLI tools aggregator
  - `install/linux/apps.sh` - Linux GUI apps aggregator
  - `install/macos/prereq.sh` - macOS prerequisites
  - `install/macos/brew.sh` - Homebrew package installation
  - `install/macos/fish.sh` - Fish shell configuration

- **Setup Scripts**:
  - `setups/ssh.sh` - SSH key and configuration setup

### 7.3 Dependency Function Standardization ✅ COMPLETED
- **Updated prerequisite scripts** to use `apt_install` function:
  - `install/linux/prereq/stow.sh` - Now uses `apt_install stow`
  - `install/linux/prereq/1-libs.sh` - Organized by categories with `apt_install`
  - `install/linux/prereq/i3.sh` - Now uses `apt_install` for i3 tools
  - `install/linux/cli/fish.sh` - Added proper dependency checking with `is_installed`

- **Standardized individual installation scripts**:
  - `install/linux/apps/vscode.sh` - VS Code with repository setup and Wayland notes
  - `install/linux/apps/chrome.sh` - Google Chrome with proper temp directory handling
  - `install/linux/cli/docker.sh` - Docker Engine with complete configuration

### 7.4 Error Handling Improvements ✅ COMPLETED
- **Added `set -euo pipefail`** to all main scripts:
  - Exit on error (`-e`)
  - Exit on undefined variables (`-u`) 
  - Exit on pipe failures (`-o pipefail`)
- **Improved safety** for script sourcing with file existence checks
- **Consistent error messaging** for missing dependencies

### 7.5 Library Sourcing Optimization ✅ COMPLETED
- **Platform-specific sourcing**:
  - Linux scripts source `lib/linux.sh`
  - macOS scripts source `lib/macos.sh`
  - Cross-platform scripts source `lib/dotfiles.sh` and `lib/bootstrap.sh` as needed
- **Removed duplicate function definitions** (config_banner, do_stow now in libraries)

### 7.6 Installation Script Patterns ✅ COMPLETED
- **Consistent pattern** for all installation scripts:
  - Check if already installed with `is_installed`
  - Display progress with `installing_banner` or `skipping`
  - Use standardized `apt_install` function
  - Proper error handling and cleanup
  - Clear success messages and user guidance
- **Enhanced documentation** with reference links and clear comments
- **Improved user experience** with emoji indicators and helpful tips

### Testing ✅ COMPLETED
- ✅ All updated scripts pass syntax validation (`bash -n`)
- ✅ Scripts follow consistent patterns and use library functions
- ✅ Error handling works correctly with `set -euo pipefail`
- 🔄 Ready for integration testing (Phase 7.7)

### Phase 7 Summary
**Total scripts standardized**: 15+ scripts across main installation, configuration, and individual app installers
**Key improvements**:
- Consistent headers and documentation
- Reliable error handling
- Standardized library usage
- Better user feedback and guidance
- Safer temporary file handling
- Platform-specific optimizations
