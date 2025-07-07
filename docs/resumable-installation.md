# Resumable Installation System

## Overview

The resumable installation system provides the ability to pause and resume dotfiles installation at any point. This is particularly useful for long installations that may be interrupted due to network issues, system shutdowns, or other interruptions.

## Features

- **State Tracking**: Automatic tracking of installation progress and completion status
- **Step-by-Step Resumption**: Resume from exactly where the installation was interrupted
- **Progress Monitoring**: Real-time progress tracking and status reporting
- **Error Handling**: Graceful handling of failed steps with detailed error reporting
- **Lock Management**: Prevent concurrent installations with process-level locking
- **Session Management**: Track installation sessions across multiple runs

## Installation State File

The installation state is tracked in `.install-state` file in the dotfiles directory. This file contains:

- Installation session information
- Step completion status and timestamps
- Error information for failed steps
- Progress tracking data

### State File Format

```
# Installation State Tracking
# Format: step_id:status:timestamp:session_id[:error_message]
# Status: pending|in_progress|completed|failed|skipped

session_start:install:2025-07-06 19:44:08:1751840048
linux_prereq:completed:2025-07-06 19:45:12:1751840048
linux_stow:completed:2025-07-06 19:45:45:1751840048
linux_cli:in_progress:2025-07-06 19:46:02:1751840048
```

## Commands

### Installation State Commands

#### `dotfiles install status`

Shows the current installation progress and status:

```bash
dotfiles install status
```

**Example Output:**
```
📊 Installation Status

ℹ️ [INFO] Installation Progress Summary:
ℹ️ [INFO]   Total steps: 7
ℹ️ [INFO]   Completed: 3 (43%)
ℹ️ [INFO]   Failed: 1
ℹ️ [INFO]   Skipped: 0
ℹ️ [INFO]   Pending: 3

Recent Installation Sessions:
  session_start: install at 2025-07-06 19:44:08 (session: 1751840048)

⚠️ [WARN] Failed steps:
  - linux_cli
```

#### `dotfiles install steps`

Shows detailed information about each installation step:

```bash
dotfiles install steps
```

**Example Output:**
```
📋 Installation Steps

Installation steps and their status:
  ✅ linux_prereq - completed (2025-07-06 19:45:12)
  ✅ linux_stow - completed (2025-07-06 19:45:45)
  ❌ linux_cli - failed (2025-07-06 19:46:02)
  ⏸️ linux_apps - pending
  ⏸️ linux_desktop_entries - pending
  ⏸️ cross_platform_setups - pending
  ⏸️ linux_setups - pending
```

#### `dotfiles install resume`

Resumes the installation from the last checkpoint:

```bash
dotfiles install resume
```

This command will:
1. Initialize the installation state tracking
2. Show current progress
3. Resume installation from where it left off
4. Skip already completed steps
5. Continue with pending steps

#### `dotfiles install reset`

Resets the installation state to start fresh:

```bash
dotfiles install reset
```

**Interactive Mode:**
```bash
dotfiles install reset
# Prompts for confirmation

Are you sure you want to reset installation state? (y/N): y
```

**Non-Interactive Mode:**
```bash
dotfiles install reset confirm
# Resets immediately without prompting
```

## Installation Flow

### Normal Installation

When you run `dotfiles install`, the system:

1. **Initializes State Tracking**: Creates `.install-state` file and session tracking
2. **Detects Platform**: Determines if running on Linux or macOS
3. **Executes Steps**: Runs each installation step with state tracking
4. **Tracks Progress**: Records completion status and timestamps
5. **Handles Errors**: Logs detailed error information for failed steps
6. **Shows Summary**: Displays final installation progress

### Resumable Installation

Each installation step is wrapped with the `run_step` function that:

1. **Checks Completion**: Verifies if step was already completed
2. **Skips if Done**: Automatically skips completed steps
3. **Executes Step**: Runs the step function if not completed
4. **Records Status**: Updates state file with completion or failure
5. **Error Handling**: Logs detailed error information if step fails

### Platform-Specific Steps

#### Linux Installation Steps

1. `linux_prereq` - Install Linux prerequisites
2. `linux_stow` - Configure dotfiles with stow
3. `linux_cli` - Install CLI tools
4. `linux_apps` - Install GUI applications (if enabled)
5. `linux_desktop_entries` - Install desktop entries (if enabled)
6. `cross_platform_setups` - Run cross-platform setups
7. `linux_setups` - Run Linux-specific setups

#### macOS Installation Steps

1. `macos_prereq` - Install macOS prerequisites
2. `macos_stow` - Configure dotfiles with stow
3. `macos_brew` - Install packages via Homebrew
4. `macos_fonts` - Install fonts
5. `macos_fish` - Configure fish shell
6. `macos_setups` - Run macOS-specific setups
7. `cross_platform_setups` - Run cross-platform setups

## Usage Examples

### Basic Installation

```bash
# Start fresh installation
dotfiles install

# If interrupted, resume from last checkpoint
dotfiles install resume

# Check progress
dotfiles install status

# See detailed step information
dotfiles install steps
```

### Handling Interruptions

If your installation is interrupted:

1. **Check Status**: `dotfiles install status`
2. **Review Failed Steps**: Look for any failed steps in the output
3. **Fix Issues**: Address any problems that caused failures
4. **Resume**: `dotfiles install resume`

### Troubleshooting Failed Steps

If a step fails:

1. **Check Logs**: `dotfiles logs` to see detailed error information
2. **Enable Debug Mode**: `dotfiles debug on` for more verbose output
3. **Fix Root Cause**: Address the underlying issue (missing dependencies, network problems, etc.)
4. **Reset if Needed**: `dotfiles install reset` to start fresh if step cannot be recovered
5. **Resume**: `dotfiles install resume` after fixing issues

## Advanced Usage

### Manual Step Control

You can manually control installation steps by editing the `.install-state` file:

```bash
# Remove a step to force it to re-run
sed -i '/^problematic_step:/d' .install-state

# Resume installation
dotfiles install resume
```

### Session Management

Each installation creates a unique session ID for tracking:

```bash
# Check recent sessions
dotfiles install status | grep "session"

# View session details in state file
cat .install-state | grep session
```

### Lock File Management

The system uses a lock file to prevent concurrent installations:

```bash
# If you get a "installation already in progress" error
# but no installation is running, remove the lock file:
rm .install-lock

# Then resume
dotfiles install resume
```

## Integration with Logging System

The resumable installation system integrates with the enhanced logging system:

- **Progress Logging**: Real-time progress updates with step completion percentages
- **Error Context**: Detailed error information with troubleshooting suggestions
- **Debug Mode**: Verbose output for troubleshooting installation issues
- **Log Files**: Complete installation history in log files

```bash
# Enable debug mode for detailed output
dotfiles debug on

# View installation logs
dotfiles logs

# Follow logs in real-time
dotfiles logs tail
```

## Best Practices

### Before Installation

1. **Check System Requirements**: `dotfiles doctor`
2. **Validate Dependencies**: `dotfiles validate`
3. **Enable Debug Mode**: `dotfiles debug on` for troubleshooting
4. **Check Disk Space**: Ensure sufficient space for installation

### During Installation

1. **Monitor Progress**: Use `dotfiles install status` in another terminal
2. **Check for Errors**: Watch for error messages and warnings
3. **Don't Interrupt**: Allow steps to complete naturally when possible

### After Interruption

1. **Don't Panic**: The system is designed to handle interruptions
2. **Check Status**: `dotfiles install status` to see what was completed
3. **Fix Issues**: Address any failed steps before resuming
4. **Resume Safely**: `dotfiles install resume` will pick up where you left off

### Troubleshooting

1. **Check Logs**: `dotfiles logs` for detailed error information
2. **Enable Debug**: `dotfiles debug on` for verbose output
3. **Validate System**: `dotfiles validate` to check system requirements
4. **Reset if Needed**: `dotfiles install reset` for a fresh start

## Error Recovery

### Common Issues and Solutions

#### Network Interruptions

```bash
# Check status
dotfiles install status

# Resume (will retry failed network operations)
dotfiles install resume
```

#### Permission Errors

```bash
# Fix permissions
sudo chown -R $USER:$USER $DOTFILES_DIR

# Resume installation
dotfiles install resume
```

#### Disk Space Issues

```bash
# Clean up space
dotfiles clean

# Check available space
df -h

# Resume installation
dotfiles install resume
```

#### Dependency Conflicts

```bash
# Check for conflicts
dotfiles doctor

# Fix dependency issues
# (follow suggestions from doctor output)

# Resume installation
dotfiles install resume
```

## Files and Directories

### State Files

- `.install-state` - Installation progress tracking
- `.install-lock` - Process lock file (temporary)

### Log Files

- `logs/dotfiles.log` - Installation and error logs (within dotfiles directory)
- Debug information available via `dotfiles logs`

### Configuration

- `~/.dotfilesrc` - Configuration file with installation settings
- Environment variables for customization

## Environment Variables

- `DOTFILES_DEBUG` - Enable debug mode (0/1)
- `DOTFILES_LOG_LEVEL` - Set logging level (DEBUG/INFO/WARN/ERROR)
- `DOTFILES_LOG_FILE` - Set log file path (default: `${DOTFILES_DIR}/logs/dotfiles.log`)

## Conclusion

The resumable installation system provides a robust, reliable way to install dotfiles with full recovery capabilities. It handles interruptions gracefully, provides detailed progress tracking, and integrates seamlessly with the existing logging and package management systems.

For additional help or troubleshooting, use `dotfiles help` or check the main documentation in the `docs/` directory. 
