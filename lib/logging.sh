# Enhanced logging and error handling functions for dotfiles

# Logging Configuration
DOTFILES_LOG_LEVEL="${DOTFILES_LOG_LEVEL:-INFO}"
DOTFILES_LOG_FILE="${DOTFILES_LOG_FILE:-${DOTFILES_DIR:-${HOME}/.local/share/dotfiles}/logs/dotfiles.log}"
DOTFILES_DEBUG="${DOTFILES_DEBUG:-0}"

# Dry-run mode configuration
DRY_RUN="${DRY_RUN:-false}"
DRY_RUN_LOG_PREFIX="[DRY-RUN] "

# ANSI Color Codes (define only if not already set)
if [[ -z "${COLOR_RED:-}" ]]; then
    readonly COLOR_RED='\033[0;31m'
    readonly COLOR_GREEN='\033[0;32m'
    readonly COLOR_YELLOW='\033[1;33m'
    readonly COLOR_BLUE='\033[0;34m'
    readonly COLOR_PURPLE='\033[0;35m'
    readonly COLOR_CYAN='\033[0;36m'
    readonly COLOR_WHITE='\033[1;37m'
    readonly COLOR_ORANGE='\033[0;33m'
    readonly COLOR_RESET='\033[0m'
fi

# Emoji symbols for better visual feedback (define only if not already set)
if [[ -z "${EMOJI_ERROR:-}" ]]; then
    readonly EMOJI_ERROR='❌'
    readonly EMOJI_WARNING='⚠️'
    readonly EMOJI_INFO='ℹ️'
    readonly EMOJI_DEBUG='🔍'
    readonly EMOJI_SUCCESS='✅'
    readonly EMOJI_ARROW='➡️'
    readonly EMOJI_DRY_RUN='🧪'
    readonly EMOJI_SIMULATE='🎭'
fi

# Log levels (numeric values for comparison) (define only if not already set)
if [[ -z "${LOG_LEVEL_DEBUG:-}" ]]; then
    readonly LOG_LEVEL_DEBUG=10
    readonly LOG_LEVEL_INFO=20
    readonly LOG_LEVEL_WARN=30
    readonly LOG_LEVEL_ERROR=40
fi

# Parse command line arguments for dry-run and other options
parse_script_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --dry-run|--dryrun|-n)
                export DRY_RUN=true
                log_info "Dry-run mode enabled - no actual changes will be made"
                shift
                ;;
            --debug|-d)
                export DOTFILES_DEBUG=1
                log_info "Debug mode enabled"
                shift
                ;;
            --verbose|-v)
                export DOTFILES_LOG_LEVEL=DEBUG
                log_info "Verbose logging enabled"
                shift
                ;;
            --quiet|-q)
                export DOTFILES_LOG_LEVEL=ERROR
                shift
                ;;
            --help|-h)
                show_script_help
                exit 0
                ;;
            *)
                # Unknown option, pass it through
                shift
                ;;
        esac
    done
}

# Show help for script with dry-run options
show_script_help() {
    local script_name="${0##*/}"
    echo "Usage: $script_name [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --dry-run, -n     Simulate operations without making actual changes"
    echo "  --debug, -d       Enable debug output"
    echo "  --verbose, -v     Enable verbose logging"
    echo "  --quiet, -q       Show only errors"
    echo "  --help, -h        Show this help message"
    echo ""
    echo "Examples:"
    echo "  $script_name --dry-run    # Test what would be done"
    echo "  $script_name --debug      # Run with detailed output"
    echo "  $script_name --verbose    # Show all log messages"
}

# Check if script is running in dry-run mode
is_dry_run() {
    [[ "$DRY_RUN" == "true" ]]
}

# Convert log level name to numeric value
get_log_level_value() {
    case "${1^^}" in
        "DEBUG") echo $LOG_LEVEL_DEBUG ;;
        "INFO") echo $LOG_LEVEL_INFO ;;
        "WARN"|"WARNING") echo $LOG_LEVEL_WARN ;;
        "ERROR") echo $LOG_LEVEL_ERROR ;;
        *) echo $LOG_LEVEL_INFO ;;
    esac
}

# Check if color output is supported
supports_color() {
    if [[ -t 1 ]] && command -v tput >/dev/null 2>&1; then
        local colors
        colors=$(tput colors 2>/dev/null || echo 0)
        [[ $colors -gt 0 ]]
    else
        false
    fi
}

# Get current timestamp
get_timestamp() {
    date '+%Y-%m-%d %H:%M:%S'
}

# Get script name and line number for context
get_script_context() {
    local script_name="${BASH_SOURCE[3]##*/}"
    local line_number="${BASH_LINENO[2]}"
    echo "[${script_name}:${line_number}]"
}

# Core logging function with dry-run support
_log() {
    local level="$1"
    local message="$2"
    local emoji="$3"
    local color="$4"
    
    # Check if we should log this level
    local current_level_value
    current_level_value=$(get_log_level_value "$DOTFILES_LOG_LEVEL")
    local msg_level_value
    msg_level_value=$(get_log_level_value "$level")
    
    if [[ $msg_level_value -lt $current_level_value ]]; then
        return 0
    fi
    
    local timestamp
    timestamp=$(get_timestamp)
    local context
    context=$(get_script_context)
    
    # Add dry-run prefix if in dry-run mode
    local prefix=""
    if is_dry_run; then
        prefix="$DRY_RUN_LOG_PREFIX"
    fi
    
    # Format the message
    local formatted_msg
    if supports_color; then
        formatted_msg="${color}${emoji} [${level}] ${prefix}${message}${COLOR_RESET}"
    else
        formatted_msg="${emoji} [${level}] ${prefix}${message}"
    fi
    
    # Output to console
    echo -e "$formatted_msg" >&2
    
    # Log to file if specified
    if [[ -n "$DOTFILES_LOG_FILE" ]]; then
        echo "$timestamp $context [$level] ${prefix}$message" >> "$DOTFILES_LOG_FILE"
    fi
}

# Individual logging functions
log_debug() {
    if [[ "$DOTFILES_DEBUG" == "1" ]]; then
        _log "DEBUG" "$1" "$EMOJI_DEBUG" "$COLOR_PURPLE"
    fi
}

log_info() {
    _log "INFO" "$1" "$EMOJI_INFO" "$COLOR_BLUE"
}

log_success() {
    _log "INFO" "$1" "$EMOJI_SUCCESS" "$COLOR_GREEN"
}

log_warn() {
    _log "WARN" "$1" "$EMOJI_WARNING" "$COLOR_YELLOW"
}

log_error() {
    _log "ERROR" "$1" "$EMOJI_ERROR" "$COLOR_RED"
}

# Dry-run specific logging functions
log_dry_run() {
    local action="$1"
    if is_dry_run; then
        _log "INFO" "Would $action" "$EMOJI_DRY_RUN" "$COLOR_ORANGE"
    fi
}

log_simulate() {
    local operation="$1"
    _log "INFO" "Simulating: $operation" "$EMOJI_SIMULATE" "$COLOR_ORANGE"
}

# Enhanced banner functions with dry-run indication
log_banner() {
    local message="$1"
    local border="========================================================================"
    
    # Add dry-run indicator to banner
    if is_dry_run; then
        message="$message (DRY-RUN MODE)"
    fi
    
    if supports_color; then
        local banner_color="$COLOR_CYAN"
        if is_dry_run; then
            banner_color="$COLOR_ORANGE"
        fi
        echo -e "${banner_color}${border}${COLOR_RESET}" >&2
        echo -e "${banner_color} $message${COLOR_RESET}" >&2
        echo -e "${banner_color}${border}${COLOR_RESET}" >&2
    else
        echo "$border" >&2
        echo " $message" >&2
        echo "$border" >&2
    fi
    
    # Log to file
    if [[ -n "$DOTFILES_LOG_FILE" ]]; then
        local prefix=""
        if is_dry_run; then
            prefix="$DRY_RUN_LOG_PREFIX"
        fi
        echo "$(get_timestamp) $(get_script_context) [BANNER] ${prefix}$message" >> "$DOTFILES_LOG_FILE"
    fi
}

log_step() {
    local step="$1"
    local message="$2"
    
    # Add dry-run indication to step
    local step_message="Step $step: $message"
    if is_dry_run; then
        step_message="Step $step: $message (simulated)"
    fi
    
    if supports_color; then
        local step_color="$COLOR_WHITE"
        if is_dry_run; then
            step_color="$COLOR_ORANGE"
        fi
        echo -e "${step_color}${EMOJI_ARROW} $step_message${COLOR_RESET}" >&2
    else
        echo "${EMOJI_ARROW} $step_message" >&2
    fi
    
    # Log to file
    if [[ -n "$DOTFILES_LOG_FILE" ]]; then
        local prefix=""
        if is_dry_run; then
            prefix="$DRY_RUN_LOG_PREFIX"
        fi
        echo "$(get_timestamp) $(get_script_context) [STEP] ${prefix}$step: $message" >> "$DOTFILES_LOG_FILE"
    fi
}

# Enhanced error handling
handle_error() {
    local exit_code=$?
    local command="$1"
    local script_name="${BASH_SOURCE[1]##*/}"
    local line_number="${BASH_LINENO[0]}"
    local function_name="${FUNCNAME[1]}"
    
    # Create detailed error message
    local error_msg="Command failed with exit code $exit_code"
    error_msg+="\n  Script: $script_name"
    error_msg+="\n  Function: $function_name"
    error_msg+="\n  Line: $line_number"
    error_msg+="\n  Command: $command"
    
    # Add dry-run context
    if is_dry_run; then
        error_msg+="\n  Mode: DRY-RUN (error during simulation)"
    fi
    
    # Add environment information
    error_msg+="\n  Working Directory: $(pwd)"
    error_msg+="\n  User: $(whoami)"
    error_msg+="\n  OS: $OSTYPE"
    
    # Log the error
    log_error "$error_msg"
    
    # Show error context if debug mode is enabled
    if [[ "$DOTFILES_DEBUG" == "1" ]]; then
        log_debug "Recent command history:"
        if command -v history >/dev/null 2>&1; then
            history | tail -5 | while read -r line; do
                log_debug "  $line"
            done
        fi
        
        log_debug "Environment variables:"
        env | grep -E '^(DOTFILES|PATH|HOME|USER|DRY_RUN)' | while read -r var; do
            log_debug "  $var"
        done
    fi
    
    # Offer helpful suggestions
    log_info "Troubleshooting suggestions:"
    log_info "  1. Check the command syntax and arguments"
    log_info "  2. Verify required dependencies are installed"
    log_info "  3. Check file permissions and paths"
    log_info "  4. Run with DOTFILES_DEBUG=1 for more details"
    log_info "  5. Check the log file: $DOTFILES_LOG_FILE"
    if is_dry_run; then
        log_info "  6. Try running without --dry-run to see actual behavior"
    fi
    
    # Exit with the original error code
    exit $exit_code
}

# Set up error trapping
setup_error_handling() {
    # Enable strict error handling
    set -euo pipefail
    
    # Set up error trap
    trap 'handle_error "$BASH_COMMAND"' ERR
    
    # Set up exit trap for cleanup
    trap 'log_debug "Script exiting with code $?"' EXIT
    
    log_debug "Error handling initialized for ${BASH_SOURCE[1]##*/}"
}

# Progress tracking functions with dry-run support
progress_start() {
    local total_steps="$1"
    local description="$2"
    
    export DOTFILES_PROGRESS_TOTAL="$total_steps"
    export DOTFILES_PROGRESS_CURRENT=0
    export DOTFILES_PROGRESS_DESC="$description"
    
    local mode_desc="$description"
    if is_dry_run; then
        mode_desc="$description (simulation)"
    fi
    
    log_info "Starting: $mode_desc (0/$total_steps)"
}

progress_step() {
    local step_description="$1"
    
    ((DOTFILES_PROGRESS_CURRENT++))
    
    local percentage=$((DOTFILES_PROGRESS_CURRENT * 100 / DOTFILES_PROGRESS_TOTAL))
    
    local mode_desc="$step_description"
    if is_dry_run; then
        mode_desc="$step_description (simulated)"
    fi
    
    log_info "Progress: $mode_desc ($DOTFILES_PROGRESS_CURRENT/$DOTFILES_PROGRESS_TOTAL - $percentage%)"
}

progress_complete() {
    local mode_desc="$DOTFILES_PROGRESS_DESC"
    if is_dry_run; then
        mode_desc="$DOTFILES_PROGRESS_DESC (simulation completed)"
    fi
    
    log_success "Completed: $mode_desc ($DOTFILES_PROGRESS_TOTAL/$DOTFILES_PROGRESS_TOTAL - 100%)"
    unset DOTFILES_PROGRESS_TOTAL DOTFILES_PROGRESS_CURRENT DOTFILES_PROGRESS_DESC
}

# Show dry-run mode information
show_dry_run_info() {
    if is_dry_run; then
        log_banner "DRY-RUN MODE ACTIVE"
        log_warn "This is a simulation - no actual changes will be made"
        log_info "Dry-run mode will:"
        log_info "  • Show what operations would be performed"
        log_info "  • Validate dependencies and prerequisites"
        log_info "  • Check file and directory existence"
        log_info "  • Simulate package installations"
        log_info "  • Display configuration changes that would be made"
        log_info ""
        log_info "To perform actual changes, run the script without --dry-run"
        echo ""
    fi
}

# Debugging helpers
debug_env() {
    if [[ "$DOTFILES_DEBUG" == "1" ]]; then
        log_debug "=== Environment Debug Information ==="
        log_debug "DRY_RUN: $DRY_RUN"
        log_debug "DOTFILES_DIR: ${DOTFILES_DIR:-'Not set'}"
        log_debug "DOTFILES_OS: ${DOTFILES_OS:-'Not set'}"
        log_debug "DOTFILES_LOG_LEVEL: $DOTFILES_LOG_LEVEL"
        log_debug "DOTFILES_LOG_FILE: $DOTFILES_LOG_FILE"
        log_debug "DOTFILES_DEBUG: $DOTFILES_DEBUG"
        log_debug "PWD: $(pwd)"
        log_debug "USER: $(whoami)"
        log_debug "SHELL: ${SHELL:-'Not set'}"
        log_debug "PATH: ${PATH:0:100}..."
        log_debug "=== End Environment Debug ==="
    fi
}

# Validation helpers
validate_required_vars() {
    local vars=("$@")
    local missing=()
    
    for var in "${vars[@]}"; do
        if [[ -z "${!var:-}" ]]; then
            missing+=("$var")
        fi
    done
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        log_error "Missing required environment variables: ${missing[*]}"
        log_info "Please set the following variables and try again:"
        for var in "${missing[@]}"; do
            log_info "  export $var=<value>"
        done
        exit 1
    fi
}

validate_commands() {
    local commands=("$@")
    local missing=()
    
    for cmd in "${commands[@]}"; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            missing+=("$cmd")
        fi
    done
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        log_error "Missing required commands: ${missing[*]}"
        log_info "Please install the following commands and try again:"
        for cmd in "${missing[@]}"; do
            log_info "  $cmd"
        done
        if is_dry_run; then
            log_warn "In dry-run mode - continuing simulation despite missing commands"
            return 0
        fi
        exit 1
    fi
}

# Log file management
rotate_log() {
    if [[ -f "$DOTFILES_LOG_FILE" ]]; then
        local log_size
        log_size=$(stat -f%z "$DOTFILES_LOG_FILE" 2>/dev/null || stat -c%s "$DOTFILES_LOG_FILE" 2>/dev/null || echo 0)
        
        # Rotate if larger than 10MB
        if [[ $log_size -gt 10485760 ]]; then
            if is_dry_run; then
                log_dry_run "rotate log file: ${DOTFILES_LOG_FILE} -> ${DOTFILES_LOG_FILE}.old"
            else
                mv "$DOTFILES_LOG_FILE" "${DOTFILES_LOG_FILE}.old"
                log_info "Log file rotated: ${DOTFILES_LOG_FILE}.old"
            fi
        fi
    fi
}

# Enhanced installation progress logging (enhanced with state tracking)
log_installation_step() {
    local step_id="$1"
    local step_description="$2"
    
    # Show progress with state tracking integration
    if command -v get_installation_progress >/dev/null 2>&1; then
        local progress
        progress=$(get_installation_progress)
        read -r total completed failed skipped pending <<< "$progress"
        
        if [[ $total -gt 0 ]]; then
            local percentage=$((completed * 100 / total))
            local mode_desc="$step_description"
            if is_dry_run; then
                mode_desc="$step_description (simulated)"
            fi
            log_info "Step ($((completed + 1))/$total - $percentage%): $mode_desc"
        else
            log_info "Step: $step_description"
        fi
    else
        log_info "Step: $step_description"
    fi
}

# Enhanced installation banner with progress
log_installation_banner() {
    local message="$1"
    local show_progress="${2:-true}"
    
    log_banner "$message"
    
    # Show progress if state tracking is available
    if [[ "$show_progress" == "true" ]] && command -v show_installation_progress >/dev/null 2>&1; then
        show_installation_progress
    fi
}

# Initialize logging
init_logging() {
    # Create log directory if it doesn't exist
    local log_dir
    log_dir=$(dirname "$DOTFILES_LOG_FILE")
    
    if is_dry_run; then
        log_dry_run "create log directory: $log_dir"
    else
        mkdir -p "$log_dir" 2>/dev/null || true
    fi
    
    # Rotate log if needed
    rotate_log
    
    # Log session start
    if [[ -n "$DOTFILES_LOG_FILE" ]]; then
        local prefix=""
        if is_dry_run; then
            prefix="$DRY_RUN_LOG_PREFIX"
        fi
        
        if is_dry_run; then
            log_dry_run "write to log file: $DOTFILES_LOG_FILE"
        else
            echo "$(get_timestamp) [INIT] ${prefix}Logging session started" >> "$DOTFILES_LOG_FILE"
        fi
    fi
    
    log_debug "Logging initialized - Level: $DOTFILES_LOG_LEVEL, File: $DOTFILES_LOG_FILE, Dry-run: $DRY_RUN"
}

# Auto-initialize logging when sourced
init_logging 
