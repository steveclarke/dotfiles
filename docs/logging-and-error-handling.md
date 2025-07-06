# Logging and Error Handling System

## Overview

The dotfiles repository now includes a comprehensive logging and error handling system that provides:
- **Structured logging** with multiple log levels (DEBUG, INFO, WARN, ERROR)
- **Enhanced error handling** with detailed context and troubleshooting suggestions
- **Progress tracking** for long-running operations
- **Debug mode** for troubleshooting
- **Log management** with rotation and viewing capabilities

## Architecture

### Core Components

1. **`lib/logging.sh`** - Main logging library with 350+ lines of functionality
2. **`lib/dotfiles.sh`** - Updated to integrate logging throughout the system
3. **`bin/dotfiles`** - Enhanced utility with logging commands
4. **Installation scripts** - Updated to use new logging functions

### Key Features

- **Color-coded output** with emoji indicators for better visibility
- **File and console logging** with timestamps and context
- **Automatic log rotation** when files exceed 10MB
- **Error trapping** with detailed context and suggestions
- **Environment validation** and debugging helpers
- **Progress tracking** for multi-step operations

## Usage Guide

### Basic Logging Functions

```bash
# Source the logging library
source "${DOTFILES_DIR}/lib/logging.sh"

# Use logging functions
log_info "This is an informational message"
log_success "Operation completed successfully"
log_warn "This is a warning message"
log_error "This is an error message"
log_debug "This is a debug message (only shown in debug mode)"
```

### Enhanced Banners and Progress

```bash
# Enhanced banner with logging
log_banner "Installing Docker Engine"

# Progress tracking
progress_start 5 "Docker Installation"
progress_step "Installing prerequisites"
progress_step "Downloading packages"
progress_complete
```

### Error Handling Setup

```bash
# Enable comprehensive error handling
setup_error_handling  # Automatically called when sourcing lib/dotfiles.sh

# Validate requirements
validate_required_vars "DOTFILES_DIR" "HOME" "USER"
validate_commands "git" "curl" "wget"
```

### Debug Mode

```bash
# Enable debug mode for detailed logging
export DOTFILES_DEBUG=1

# Or use the utility
dotfiles debug on
```

## Configuration

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `DOTFILES_LOG_LEVEL` | `INFO` | Minimum log level to display (DEBUG/INFO/WARN/ERROR) |
| `DOTFILES_LOG_FILE` | `~/.dotfiles.log` | Path to log file |
| `DOTFILES_DEBUG` | `0` | Enable debug mode (0/1) |

### Log Levels

- **DEBUG** (10) - Detailed debugging information
- **INFO** (20) - General informational messages
- **WARN** (30) - Warning messages
- **ERROR** (40) - Error messages

## Command Line Interface

### Logging Commands

```bash
# View recent log entries
dotfiles logs

# Follow log file in real-time
dotfiles logs tail

# Clear log file
dotfiles logs clear

# Enable/disable debug mode
dotfiles debug on
dotfiles debug off
dotfiles debug status

# Set log level
dotfiles log-level DEBUG
dotfiles log-level INFO
dotfiles log-level WARN
dotfiles log-level ERROR
```

### Examples

```bash
# Basic usage
dotfiles install linux

# With debug mode
DOTFILES_DEBUG=1 dotfiles install linux

# With custom log level
DOTFILES_LOG_LEVEL=DEBUG dotfiles config

# View logs after installation
dotfiles logs
```

## Advanced Features

### Error Context

When errors occur, the system provides:
- **Exit code** and failed command
- **Script name**, function, and line number
- **Working directory** and user context
- **Environment information** (in debug mode)
- **Troubleshooting suggestions**

### Log File Management

- **Automatic rotation** when files exceed 10MB
- **Timestamped entries** with script context
- **Structured format** for easy parsing
- **Session tracking** with start/end markers

### Validation Helpers

```bash
# Validate environment variables
validate_required_vars "VAR1" "VAR2" "VAR3"

# Validate commands exist
validate_commands "git" "curl" "wget"

# Show debug environment info
debug_env
```

## Integration Guide

### Updating Existing Scripts

1. **Add library sourcing:**
```bash
#!/usr/bin/env bash
set -euo pipefail
source "${DOTFILES_DIR}/lib/linux.sh"  # or appropriate platform lib
```

2. **Replace basic functions:**
```bash
# Old
echo "Installing package"

# New
log_info "Installing package"
```

3. **Add progress tracking:**
```bash
progress_start 3 "Package Installation"
progress_step "Downloading package"
progress_step "Installing package"
progress_step "Configuring package"
progress_complete
```

4. **Add error handling:**
```bash
# Automatic with setup_error_handling (called by lib/dotfiles.sh)
# Or manual validation
validate_commands "required_command"
```

### Best Practices

1. **Use appropriate log levels**
   - `log_debug` for detailed debugging info
   - `log_info` for general progress messages
   - `log_success` for successful operations
   - `log_warn` for warnings that don't stop execution
   - `log_error` for errors that require attention

2. **Add context to messages**
   ```bash
   log_info "Installing package: $package_name"
   log_debug "Running command: $command"
   ```

3. **Use progress tracking for long operations**
   ```bash
   progress_start 5 "Complex Installation"
   # ... steps ...
   progress_complete
   ```

4. **Validate dependencies early**
   ```bash
   validate_commands "git" "curl"
   validate_required_vars "DOTFILES_DIR"
   ```

## Troubleshooting

### Common Issues

1. **Logging not working**
   - Check `DOTFILES_DIR` is set
   - Ensure `lib/logging.sh` is sourced
   - Verify log file permissions

2. **Debug messages not showing**
   - Set `DOTFILES_DEBUG=1`
   - Check log level with `dotfiles debug status`

3. **Log file growing too large**
   - Automatic rotation at 10MB
   - Clear manually with `dotfiles logs clear`

### Debug Commands

```bash
# Show debug status
dotfiles debug status

# Enable debug mode
dotfiles debug on

# View environment variables
DOTFILES_DEBUG=1 dotfiles doctor

# Follow logs in real-time
dotfiles logs tail
```

## Migration Notes

### From Previous Version

- **Old banner functions** still work but use enhanced logging
- **New error handling** provides better context and suggestions
- **Log files** are automatically created and managed
- **Existing scripts** benefit from enhanced error handling when sourcing updated libraries

### Breaking Changes

- **Error handling** is now more strict with `set -euo pipefail`
- **Some functions** now require `DOTFILES_DIR` to be set
- **Debug output** is now controlled by `DOTFILES_DEBUG` environment variable

## Performance Impact

- **Minimal overhead** for normal operations
- **Debug mode** has higher overhead but provides detailed information
- **Log file I/O** is optimized for append operations
- **Color detection** is cached for better performance

## Future Enhancements

Planned improvements:
- **Structured logging** with JSON format option
- **Remote logging** support
- **Log aggregation** across multiple installations
- **Performance metrics** and timing information
- **Log parsing tools** for analysis

## Examples

### Simple Installation Script

```bash
#!/usr/bin/env bash
set -euo pipefail
source "${DOTFILES_DIR}/lib/linux.sh"

install_my_package() {
    log_banner "Installing My Package"
    
    progress_start 3 "My Package Installation"
    
    progress_step "Validating dependencies"
    validate_commands "curl" "apt"
    
    progress_step "Installing package"
    if apt_install "my-package"; then
        log_success "Package installed successfully"
    else
        log_error "Failed to install package"
        return 1
    fi
    
    progress_step "Configuring package"
    # Configuration steps...
    
    progress_complete
}

# Main execution
if ! is_installed "my-package"; then
    install_my_package
else
    log_warn "Package already installed"
fi
```

### Complex Installation with Error Handling

```bash
#!/usr/bin/env bash
set -euo pipefail
source "${DOTFILES_DIR}/lib/linux.sh"

install_complex_package() {
    log_banner "Installing Complex Package"
    
    # Validate environment
    validate_required_vars "USER" "HOME"
    validate_commands "wget" "gpg" "apt"
    
    # Progress tracking
    progress_start 6 "Complex Package Installation"
    
    # Step 1: Download GPG key
    progress_step "Downloading GPG key"
    local gpg_key_url="https://example.com/gpg-key"
    if wget -qO- "$gpg_key_url" | gpg --dearmor | sudo tee /usr/share/keyrings/package.gpg > /dev/null; then
        log_success "GPG key downloaded and added"
    else
        log_error "Failed to download GPG key from $gpg_key_url"
        return 1
    fi
    
    # Step 2: Add repository
    progress_step "Adding repository"
    local repo_line="deb [signed-by=/usr/share/keyrings/package.gpg] https://example.com/repo stable main"
    if echo "$repo_line" | sudo tee /etc/apt/sources.list.d/package.list > /dev/null; then
        log_success "Repository added successfully"
    else
        log_error "Failed to add repository"
        return 1
    fi
    
    # Step 3: Update package lists
    progress_step "Updating package lists"
    if sudo apt update; then
        log_debug "Package lists updated"
    else
        log_error "Failed to update package lists"
        return 1
    fi
    
    # Step 4-6: Install packages
    local packages=("package1" "package2" "package3")
    local step=4
    for package in "${packages[@]}"; do
        progress_step "Installing $package"
        if apt_install "$package"; then
            log_debug "✓ $package installed"
        else
            log_error "✗ Failed to install $package"
            return 1
        fi
        ((step++))
    done
    
    progress_complete
    log_success "Complex package installation completed"
}

# Main execution with error handling
if ! is_installed "complex-package"; then
    install_complex_package
else
    log_warn "Complex package already installed"
    log_info "Use 'dotfiles logs' to view installation history"
fi
```

This enhanced logging and error handling system provides a solid foundation for reliable and maintainable dotfiles installation scripts. 
