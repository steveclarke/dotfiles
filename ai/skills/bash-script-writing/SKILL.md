---
name: bash-script-writing
description: Write clean, modular, production-ready bash scripts with proper error handling and maintainable structure. Use when creating new shell scripts, refactoring existing bash code, or when user asks for bash/shell scripting help with terms like "write a script", "bash script", "shell script", or "automate with bash".
---

# Modular Bash Script Writing

Write bash scripts with clear structure, proper error handling, and modular functions.

## Core Principles

- **Strict mode**: Start with `set -euo pipefail`
- **Functions over monoliths**: One function per logical operation
- **Document at top**: Header with purpose, usage, configuration
- **Fail fast with clarity**: Descriptive errors with fix suggestions

## Script Structure

Place `main()` immediately after variables so workflow is visible at file top.

```bash
#!/usr/bin/env bash
set -euo pipefail

################################################################################
# Script Title
################################################################################
#
# OVERVIEW
# --------
# Brief description of what this script does
#
# USAGE
# -----
#   script-name arg1 arg2
#
# CONFIGURATION
# -------------
# Environment variables or config requirements
#
################################################################################

# Colors
green='\033[0;32m'
blue='\033[0;34m'
yellow='\033[1;33m'
red='\033[0;31m'
nc='\033[0m'

# Configuration
VAR_ONE=${VAR_ONE:-default}
VAR_TWO=${VAR_TWO:?VAR_TWO is required}

################################################################################
# Main Orchestration
################################################################################

main() {
  parse_arguments "$@"
  step_one
  step_two
  log "Complete!"
}

################################################################################
# Helper Functions
################################################################################

log() { echo -e "${green}==>${nc} ${1}"; }
info() { echo -e "${blue}Info:${nc} ${1}"; }
warn() { echo -e "${yellow}Warning:${nc} ${1}"; }
error() { echo -e "${red}Error:${nc} ${1}" >&2; exit 1; }

################################################################################
# Core Functions
################################################################################

function_name() {
  log "What this function does..."
  # Implementation
  log "Complete"
}

################################################################################
# Script Execution
################################################################################

main "$@"
```

## Function Guidelines

- **Name clearly**: Verb-based names (`setup_directory`, `validate_config`)
- **One purpose**: If you need "and" to describe it, split it
- **Log progress**: Start with `log "..."`, end with status
- **Return codes**: `return 0` success, `return 1` failure
- **Keep focused**: 5-20 lines per function

## Error Handling

```bash
# Good: Clear error with context
setup_directory() {
  log "Creating deployment directory..."
  if ! ssh "$HOST" "mkdir -p /app/deploy"; then
    error "Failed to create directory on $HOST"
  fi
  log "Directory ready"
}

# Bad: Silent failure
setup_directory() {
  ssh "$HOST" "mkdir -p /app/deploy"
}
```

## Quality Checklist

- [ ] Strict mode (`set -euo pipefail`)
- [ ] Header with overview and usage
- [ ] Helper functions (log, info, warn, error)
- [ ] Core logic in named functions
- [ ] Main() shows clear flow at top
- [ ] Error messages include context
- [ ] No silent failures
- [ ] Meaningful variable names
- [ ] 2-space indentation
- [ ] Functions grouped with section headers
