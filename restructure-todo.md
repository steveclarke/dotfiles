# Dotfiles Restructuring Todo List

## Phase 1: Install Directory Restructuring

### 1.1 Create new directory structure
- [ ] Create `install/linux/` directory
- [ ] Create `install/linux/cli/` directory  
- [ ] Create `install/linux/apps/` directory
- [ ] Create `install/linux/prereq/` directory
- [ ] Create `install/linux/desktop-entries/` directory

### 1.2 Move Linux-specific files
- [ ] Move `install/cli.sh` → `install/linux/cli.sh`
- [ ] Move `install/apps.sh` → `install/linux/apps.sh`
- [ ] Move `install/prereq.sh` → `install/linux/prereq.sh`
- [ ] Move `install/desktop-entries.sh` → `install/linux/desktop-entries.sh`
- [ ] Move `install/cli/` → `install/linux/cli/`
- [ ] Move `install/apps/` → `install/linux/apps/`
- [ ] Move `install/prereq/` → `install/linux/prereq/`
- [ ] Move `install/desktop-entries/` → `install/linux/desktop-entries/`

### 1.3 Update path references
- [ ] Update `install.sh` to reference new Linux paths
- [ ] Update any scripts that reference moved install files
- [ ] Update documentation with new paths

## Phase 2: Config Management Separation

### 2.1 Create platform-specific config directories
- [ ] Create `configs/linux/` directory
- [ ] Create `configs/macos/` directory

### 2.2 Split stow configurations
- [ ] Create `configs/linux/stow-linux.sh` for Linux-specific configs (i3, polybar, etc.)
- [ ] Create `configs/macos/stow-macos.sh` for macOS-specific configs (future)
- [ ] Modify `configs/stow.sh` to contain only cross-platform configurations

### 2.3 Update config management workflow
- [ ] Update main scripts to call platform-specific stow scripts
- [ ] Test configuration deployment on both platforms
- [ ] Update documentation for new config structure

## Phase 3: Fixes Directory Organization

### 3.1 Create platform-specific fixes directories
- [ ] Create `fixes/linux/` directory
- [ ] Create `fixes/macos/` directory

### 3.2 Move Linux-specific fixes
- [ ] Move `fixes/chrome-wayland.sh` → `fixes/linux/chrome-wayland.sh`
- [ ] Move `fixes/dns-resolution.sh` → `fixes/linux/dns-resolution.sh`
- [ ] Move `fixes/electron-wayland.sh` → `fixes/linux/electron-wayland.sh`

### 3.3 Update fix references
- [ ] Update any scripts that reference moved fix files
- [ ] Update documentation with new fix locations

## Phase 4: Library Structure Improvement

### 4.1 Split oversized library file
- [ ] Analyze current `lib/dotfiles.sh` (275 lines) functions
- [ ] Create `lib/linux.sh` for Linux-specific functions
- [ ] Create `lib/macos.sh` for macOS-specific functions
- [ ] Create `lib/bootstrap.sh` for bootstrap-specific functions

### 4.2 Refactor library functions
- [ ] Move Linux-specific functions to `lib/linux.sh`
- [ ] Move macOS-specific functions to `lib/macos.sh`
- [ ] Move bootstrap functions to `lib/bootstrap.sh`
- [ ] Keep only core functions and OS detection in `lib/dotfiles.sh`

### 4.3 Update library sourcing
- [ ] Update all scripts to source appropriate library files
- [ ] Test all functionality after library split
- [ ] Update documentation for new library structure

## Phase 5: Documentation Organization

### 5.1 Create docs directory
- [ ] Create `docs/` directory

### 5.2 Move documentation files
- [ ] Move `TODO.md` → `docs/TODO.md`
- [ ] Create `docs/CHANGELOG.md` for tracking changes

### 5.3 Update documentation
- [ ] Update README.md with new structure information
- [ ] Update documentation references in other files
- [ ] Create installation guides for new structure

## Phase 6: Root Directory Cleanup

### 6.1 Remove deprecated files
- [ ] Delete `bootstrap.sh` (deprecated)
- [ ] Delete `bootstrap-macos.sh` (deprecated)
- [ ] Delete `restructure-plan.md` (after restructuring complete)

### 6.2 Clean up temporary files
- [ ] Remove any temporary restructuring files
- [ ] Clean up any orphaned configuration files

## Phase 7: Script Consistency and Standards

### 7.1 Standardize script headers
- [ ] Create standard script header template with `set -euo pipefail`
- [ ] Update all scripts to use consistent headers
- [ ] Ensure all scripts properly source common functions

### 7.2 Standardize error handling
- [ ] Review all scripts for consistent error handling patterns
- [ ] Standardize dependency checking (use `is_installed` consistently)
- [ ] Add consistent script documentation

### 7.3 Unify package installation approaches
- [ ] Create consistent package installation error handling
- [ ] Standardize package manager detection and usage

## Phase 8: Enhanced Utility Script

### 8.1 Add new dotfiles commands
- [ ] Add `dotfiles install [platform]` command
- [ ] Add `dotfiles config` command to re-run configuration/stow
- [ ] Add `dotfiles update` command to update everything
- [ ] Add `dotfiles doctor` command to check system health
- [ ] Add `dotfiles clean` command to clean up temporary files

### 8.2 Improve existing utility
- [ ] Enhance help documentation
- [ ] Add better error messages
- [ ] Add debug/verbose mode support

## Phase 9: Dependency Management Improvements

### 9.1 Create dependency declaration system
- [ ] Design dependency declaration format
- [ ] Add dependency declarations to all scripts
- [ ] Create dependency validation functions

### 9.2 Implement dependency checking
- [ ] Add dependency validation before script execution
- [ ] Add platform compatibility checks
- [ ] Add conflict detection for packages

### 9.3 Create system requirements validation
- [ ] Add system requirement checks before installation
- [ ] Create pre-installation validation script
- [ ] Add platform-specific requirement validation

## Phase 10: Enhanced Error Handling and Logging

### 10.1 Create standardized logging functions
- [ ] Create `log_info()`, `log_warn()`, `log_error()`, `log_debug()` functions
- [ ] Add centralized logging configuration
- [ ] Implement log levels and debugging capabilities

### 10.2 Implement enhanced error handling
- [ ] Create `handle_error()` function with detailed error context
- [ ] Add error trapping with `trap 'handle_error "$BASH_COMMAND"' ERR`
- [ ] Standardize error messages across all scripts

### 10.3 Add debugging capabilities
- [ ] Add DEBUG environment variable support
- [ ] Create verbose mode for troubleshooting
- [ ] Add error context reporting (script, line number)

## Phase 11: Package Management Unification

### 11.1 Create unified package management
- [ ] Create `install_package()` function with auto-detection
- [ ] Implement package manager detection (`apt`, `snap`, `brew`, `manual`)
- [ ] Add package conflict handling

### 11.2 Standardize package installation
- [ ] Create platform-specific package installation functions
- [ ] Add package availability checking
- [ ] Implement fallback installation methods

### 11.3 Test package management
- [ ] Test unified package installation on Linux
- [ ] Test unified package installation on macOS
- [ ] Validate package conflict detection

## Phase 12: Installation Progress and Resumability

### 12.1 Create installation state tracking
- [ ] Implement `.install-state` file for tracking completed steps
- [ ] Create `mark_step_complete()` function
- [ ] Create `is_step_complete()` function

### 12.2 Add progress tracking
- [ ] Create `run_step()` function for resumable installations
- [ ] Add progress indicators during installation
- [ ] Implement skip functionality for completed steps

### 12.3 Test resumability
- [ ] Test installation interruption and resumption
- [ ] Validate step completion tracking
- [ ] Test installation progress reporting

## Post-Implementation Tasks

### Documentation Updates
- [ ] Update main README.md with new structure
- [ ] Create migration guide for existing users
- [ ] Update all inline documentation
- [ ] Create troubleshooting guide

### Testing and Validation
- [ ] Test complete installation on fresh Linux system
- [ ] Test complete installation on fresh macOS system
- [ ] Test upgrade path from old structure
- [ ] Validate all moved files work correctly

### Final Cleanup
- [ ] Remove all temporary restructuring files
- [ ] Clean up any remaining deprecated code
- [ ] Update VERSION file if needed
- [ ] Create final commit with restructuring complete

## Notes

- Each phase should be completed and tested before moving to the next
- Update path references immediately after moving files
- Keep backups of original structure until fully validated
- Test on both Linux and macOS when applicable
- Document any issues encountered during implementation
