# Dotfiles Agent Guidelines

## Build/Test Commands
- **Main install**: `bash install.sh` (from dotfiles root)
- **Stow configs**: `bash configs/stow.sh` or `dotfiles stow`
- **Update packages**: `dotfiles update` (runs stow + brew)
- **Just commands**: `just up` (upgrade all packages via fish)
- No formal test suite - scripts are self-testing via command checks

## Code Style Guidelines
- Use `#!/usr/bin/env bash` shebang for all shell scripts
- Source shared functions from `lib/dotfiles.sh` at script start
- Use `installing_banner "Package Name"` for install progress
- Check if commands exist with `is_installed command_name` before use
- Platform detection: use `is_macos` and `is_linux` functions
- Variable naming: use `DOTFILES_*` prefix for environment vars
- Quote all file paths with spaces: `"${HOME}/.config/app"`
- Use `mkdir -p` for directory creation, `rm -f` for safe removal
- Cache sudo credentials with `cache_sudo_credentials` for long installs
- Error handling: exit with code 1-2, show clear error messages

## Repository Structure
- `configs/` - stow packages for dotfile configs
- `install/` - installation scripts by category (cli, apps, optional)
- `lib/dotfiles.sh` - shared utility functions for all scripts
- `setups/` - post-install configuration scripts
- Platform-specific paths: `install/macos/` and `setups/linux/`