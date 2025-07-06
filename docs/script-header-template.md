# Standard Script Header Template

Use this template for all bash scripts in the dotfiles repository to ensure consistency and reliability.

## Standard Header Template

```bash
#!/usr/bin/env bash
#
# Script Name: [SCRIPT_NAME]
# Description: [BRIEF_DESCRIPTION]
# Platform: [linux|macos|cross-platform]
# Dependencies: [LIST_KEY_DEPENDENCIES]
#

# Exit on error, undefined variables, and pipe failures
set -euo pipefail

# Source required libraries
source "${DOTFILES_DIR}/lib/dotfiles.sh"  # Always source core functions first
# source "${DOTFILES_DIR}/lib/linux.sh"   # Linux-specific functions (if needed)
# source "${DOTFILES_DIR}/lib/macos.sh"   # macOS-specific functions (if needed)  
# source "${DOTFILES_DIR}/lib/bootstrap.sh" # Bootstrap functions (if needed)

# Detect OS if needed for platform-specific logic
detect_os

# Main script logic starts here
```

## Header Components Explained

### Shebang and Comments
- `#!/usr/bin/env bash` - Standard portable shebang
- Script metadata comments for documentation

### Set Options
- `set -e` - Exit immediately if any command exits with non-zero status
- `set -u` - Exit if attempting to use undefined variable
- `set -o pipefail` - Exit if any command in a pipeline fails

### Library Sourcing
- Always source core `lib/dotfiles.sh` first
- Source platform-specific libraries only when needed
- Comment out unused library sources

### OS Detection
- Call `detect_os` if script needs platform-specific logic
- Sets `$DOTFILES_OS` variable for use with `is_linux()` and `is_macos()`

## Example Usage

### Cross-platform Script
```bash
#!/usr/bin/env bash
#
# Script Name: stow.sh
# Description: Stow configuration files across platforms
# Platform: cross-platform
# Dependencies: stow, DOTFILES_DIR
#

set -euo pipefail

source "${DOTFILES_DIR}/lib/dotfiles.sh"

detect_os

# Script logic here...
```

### Linux-specific Script
```bash
#!/usr/bin/env bash
#
# Script Name: install-i3.sh
# Description: Install i3 window manager prerequisites
# Platform: linux
# Dependencies: apt, DOTFILES_CONFIG_I3
#

set -euo pipefail

source "${DOTFILES_DIR}/lib/linux.sh"

# Script logic here...
```

### macOS-specific Script
```bash
#!/usr/bin/env bash
#
# Script Name: brew.sh
# Description: Install Homebrew packages
# Platform: macos
# Dependencies: brew, Brewfile
#

set -euo pipefail

source "${DOTFILES_DIR}/lib/macos.sh"

# Script logic here...
```

## Guidelines

1. **Always use the standard header** for new scripts
2. **Update existing scripts** to match this template gradually
3. **Choose minimal library sourcing** - only source what you need
4. **Document dependencies** clearly in the header
5. **Use consistent error handling** with the `set` options 
