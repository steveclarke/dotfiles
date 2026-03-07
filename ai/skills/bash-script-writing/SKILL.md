---
name: bash-script-writing
description: Write clean, modular, production-ready bash scripts with proper error handling and maintainable structure. Use when creating new shell scripts, refactoring existing bash code, or when user asks for bash/shell scripting help with terms like "write a script", "bash script", "shell script", or "automate with bash".
---

# Modular Bash Script Writing

Follow this structure when writing bash scripts.

## Script Template

Place `main()` immediately after variables so the workflow is visible at file top.

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
- **Keep focused**: 5-20 lines per function
- **Group with section headers**: Use `####` dividers between logical groups
