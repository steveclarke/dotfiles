# Enhanced logging and error handling functions for dotfiles

# Logging Configuration
DOTFILES_LOG_LEVEL="${DOTFILES_LOG_LEVEL:-INFO}"
DOTFILES_LOG_FILE="${DOTFILES_LOG_FILE:-${HOME}/.dotfiles.log}"
DOTFILES_DEBUG="${DOTFILES_DEBUG:-0}"

# ANSI Color Codes
readonly COLOR_RED='\033[0;31m'
readonly COLOR_GREEN='\033[0;32m'
readonly COLOR_YELLOW='\033[1;33m'
readonly COLOR_BLUE='\033[0;34m'
readonly COLOR_PURPLE='\033[0;35m'
readonly COLOR_CYAN='\033[0;36m'
readonly COLOR_WHITE='\033[1;37m'
readonly COLOR_RESET='\033[0m'

# Emoji symbols for better visual feedback
readonly EMOJI_ERROR='❌'
readonly EMOJI_WARNING='⚠️'
readonly EMOJI_INFO='ℹ️'
readonly EMOJI_DEBUG='🔍'
readonly EMOJI_SUCCESS='✅'
readonly EMOJI_ARROW='➡️'

# Log levels (numeric values for comparison)
readonly LOG_LEVEL_DEBUG=10
readonly LOG_LEVEL_INFO=20
readonly LOG_LEVEL_WARN=30
readonly LOG_LEVEL_ERROR=40

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

# Core logging function
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
    
    # Format the message
    local formatted_msg
    if supports_color; then
        formatted_msg="${color}${emoji} [${level}] ${message}${COLOR_RESET}"
    else
        formatted_msg="${emoji} [${level}] ${message}"
    fi
    
    # Output to console
    echo -e "$formatted_msg" >&2
    
    # Log to file if specified
    if [[ -n "$DOTFILES_LOG_FILE" ]]; then
        echo "$timestamp $context [$level] $message" >> "$DOTFILES_LOG_FILE"
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

# Enhanced banner functions with logging
log_banner() {
    local message="$1"
    local border="========================================================================"
    
    if supports_color; then
        echo -e "${COLOR_CYAN}${border}${COLOR_RESET}" >&2
        echo -e "${COLOR_CYAN} $message${COLOR_RESET}" >&2
        echo -e "${COLOR_CYAN}${border}${COLOR_RESET}" >&2
    else
        echo "$border" >&2
        echo " $message" >&2
        echo "$border" >&2
    fi
    
    # Log to file
    if [[ -n "$DOTFILES_LOG_FILE" ]]; then
        echo "$(get_timestamp) $(get_script_context) [BANNER] $message" >> "$DOTFILES_LOG_FILE"
    fi
}

log_step() {
    local step="$1"
    local message="$2"
    
    if supports_color; then
        echo -e "${COLOR_WHITE}${EMOJI_ARROW} Step $step: $message${COLOR_RESET}" >&2
    else
        echo "${EMOJI_ARROW} Step $step: $message" >&2
    fi
    
    # Log to file
    if [[ -n "$DOTFILES_LOG_FILE" ]]; then
        echo "$(get_timestamp) $(get_script_context) [STEP] $step: $message" >> "$DOTFILES_LOG_FILE"
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
        env | grep -E '^(DOTFILES|PATH|HOME|USER)' | while read -r var; do
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

# Progress tracking functions
progress_start() {
    local total_steps="$1"
    local description="$2"
    
    export DOTFILES_PROGRESS_TOTAL="$total_steps"
    export DOTFILES_PROGRESS_CURRENT=0
    export DOTFILES_PROGRESS_DESC="$description"
    
    log_info "Starting: $description (0/$total_steps)"
}

progress_step() {
    local step_description="$1"
    
    ((DOTFILES_PROGRESS_CURRENT++))
    
    local percentage=$((DOTFILES_PROGRESS_CURRENT * 100 / DOTFILES_PROGRESS_TOTAL))
    log_info "Progress: $step_description ($DOTFILES_PROGRESS_CURRENT/$DOTFILES_PROGRESS_TOTAL - $percentage%)"
}

progress_complete() {
    log_success "Completed: $DOTFILES_PROGRESS_DESC ($DOTFILES_PROGRESS_TOTAL/$DOTFILES_PROGRESS_TOTAL - 100%)"
    unset DOTFILES_PROGRESS_TOTAL DOTFILES_PROGRESS_CURRENT DOTFILES_PROGRESS_DESC
}

# Debugging helpers
debug_env() {
    if [[ "$DOTFILES_DEBUG" == "1" ]]; then
        log_debug "=== Environment Debug Information ==="
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
            mv "$DOTFILES_LOG_FILE" "${DOTFILES_LOG_FILE}.old"
            log_info "Log file rotated: ${DOTFILES_LOG_FILE}.old"
        fi
    fi
}

# Initialize logging
init_logging() {
    # Create log directory if it doesn't exist
    local log_dir
    log_dir=$(dirname "$DOTFILES_LOG_FILE")
    mkdir -p "$log_dir" 2>/dev/null || true
    
    # Rotate log if needed
    rotate_log
    
    # Log session start
    if [[ -n "$DOTFILES_LOG_FILE" ]]; then
        echo "$(get_timestamp) [INIT] Logging session started" >> "$DOTFILES_LOG_FILE"
    fi
    
    log_debug "Logging initialized - Level: $DOTFILES_LOG_LEVEL, File: $DOTFILES_LOG_FILE"
}

# Auto-initialize logging when sourced
init_logging 
