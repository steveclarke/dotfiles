# Dotfiles Restructuring Todo List

## 📊 Current Status Summary

**✅ COMPLETED:**
- Phase 1: Install Directory Restructuring - All Linux install files have been moved to `install/linux/` and `install.sh` has been updated to use the new paths.
- Phase 2: Config Management Separation - Created platform-specific config directories and separated stow scripts for cross-platform vs Linux-specific configurations.
- Phase 3: Fixes Directory Organization - Moved Linux-specific fixes to `fixes/linux/` and created platform-specific fixes structure.
- Phase 4: Library Structure Improvement - Split the oversized `lib/dotfiles.sh` (275 lines) into platform-specific modules (`lib/linux.sh`, `lib/macos.sh`, `lib/bootstrap.sh`) and refactored core library to 35 lines.

**🔄 RECOMMENDED NEXT:**
- Phase 6: Root Directory Cleanup - Remove deprecated bootstrap files and clean up temporary files

**📋 REMAINING:**
- Phases 5-12: Documentation, cleanup, and enhanced features

---

## Phase 1: Install Directory Restructuring ✅ COMPLETED

### 1.1 Create new directory structure
- [x] Create `install/linux/` directory
- [x] Create `install/linux/cli/` directory  
- [x] Create `install/linux/apps/` directory
- [x] Create `install/linux/prereq/` directory
- [x] Create `install/linux/desktop-entries/` directory

### 1.2 Move Linux-specific files
- [x] Move `install/cli.sh` → `install/linux/cli.sh`
- [x] Move `install/apps.sh` → `install/linux/apps.sh`
- [x] Move `install/prereq.sh` → `install/linux/prereq.sh`
- [x] Move `install/desktop-entries.sh` → `install/linux/desktop-entries.sh`
- [x] Move `install/cli/` → `install/linux/cli/`
- [x] Move `install/apps/` → `install/linux/apps/`
- [x] Move `install/prereq/` → `install/linux/prereq/`
- [x] Move `install/desktop-entries/` → `install/linux/desktop-entries/`

### 1.3 Update path references
- [x] Update `install.sh` to reference new Linux paths
- [x] Update any scripts that reference moved install files
- [x] Update documentation with new paths

## Phase 2: Config Management Separation ✅ COMPLETED

### 2.1 Create platform-specific config directories
- [x] Create `configs/linux/` directory
- [x] Create `configs/macos/` directory

### 2.2 Split stow configurations
- [x] Create `configs/linux/stow-linux.sh` for Linux-specific configs (i3, polybar, etc.)
- [x] Create `configs/macos/stow-macos.sh` for macOS-specific configs (future)
- [x] Modify `configs/stow.sh` to contain only cross-platform configurations

### 2.3 Update config management workflow
- [x] Update main scripts to call platform-specific stow scripts
- [x] Test configuration deployment on both platforms (syntax validation completed)
- [ ] Update documentation for new config structure

## Phase 3: Fixes Directory Organization ✅ COMPLETED

### 3.1 Create platform-specific fixes directories
- [x] Create `fixes/linux/` directory
- [x] Create `fixes/macos/` directory

### 3.2 Move Linux-specific fixes
- [x] Move `fixes/chrome-wayland.sh` → `fixes/linux/chrome-wayland.sh`
- [x] Move `fixes/dns-resolution.sh` → `fixes/linux/dns-resolution.sh`
- [x] Move `fixes/electron-wayland.sh` → `fixes/linux/electron-wayland.sh`

### 3.3 Update fix references
- [x] Update any scripts that reference moved fix files (none found)
- [ ] Update documentation with new fix locations

## Phase 4: Library Structure Improvement ✅ COMPLETED

### 4.1 Split oversized library file
- [x] Analyze current `lib/dotfiles.sh` (275 lines) functions
- [x] Create `lib/linux.sh` for Linux-specific functions
- [x] Create `lib/macos.sh` for macOS-specific functions
- [x] Create `lib/bootstrap.sh` for bootstrap-specific functions

### 4.2 Refactor library functions
- [x] Move Linux-specific functions to `lib/linux.sh`
- [x] Move macOS-specific functions to `lib/macos.sh`
- [x] Move bootstrap functions to `lib/bootstrap.sh`
- [x] Keep only core functions and OS detection in `lib/dotfiles.sh`

### 4.3 Update library sourcing
- [x] Update all scripts to source appropriate library files
- [x] Test all functionality after library split
- [ ] Update documentation for new library structure

### 4.4 Phase 4 Summary
**✅ COMPLETED SUCCESSFULLY**
- **Result:** Reduced `lib/dotfiles.sh` from 275 lines to 35 lines
- **Created:** 3 new focused library modules (`lib/linux.sh`, `lib/macos.sh`, `lib/bootstrap.sh`)
- **Updated:** 10+ scripts to use appropriate platform-specific libraries
- **Tested:** All libraries source correctly with proper dependency resolution
- **Impact:** Significantly improved code organization and maintainability

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

## Phase 6: Root Directory Cleanup 🔄 RECOMMENDED NEXT

### 6.1 Remove deprecated files
- [ ] Delete `bootstrap.sh` (deprecated)
- [ ] Delete `bootstrap-macos.sh` (deprecated)

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

## 🎯 Next Steps Recommendation

**IMMEDIATE ACTION: Phase 6 - Root Directory Cleanup**

### Phase 6 - Root Directory Cleanup (Recommended Next)
**Why:** Clean up deprecated files and temporary restructuring files to reduce clutter after the successful library restructuring.

**Quick Start:**
1. Check for and remove deprecated bootstrap files (`bootstrap.sh`, `bootstrap-macos.sh`)
2. Remove temporary restructuring files (`restructure-spec.md`, `restructure-todo.md`)
3. Clean up any orphaned configuration files

**Impact:** Medium - reduces clutter and confusion, provides clean foundation for future phases
**Complexity:** Low - straightforward file cleanup

### Alternative: Phase 5 - Documentation Organization
**Why:** Update documentation to reflect the new structure and help users understand the changes.

**Quick Start:**
1. Create `docs/` directory
2. Update README.md with new structure information
3. Document the new library structure

**Impact:** High - improves user experience and project clarity
**Complexity:** Medium - requires comprehensive documentation updates

### Recommended Choice: **Phase 6** (Quick Win)
Root directory cleanup will provide a clean foundation and reduce confusion before tackling more complex phases.

---

## Notes

- Each phase should be completed and tested before moving to the next
- Update path references immediately after moving files
- Keep backups of original structure until fully validated
- Test on both Linux and macOS when applicable
- Document any issues encountered during implementation
