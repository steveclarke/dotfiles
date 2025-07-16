#!/usr/bin/env bash
#
# Script Name: installation-state.sh
# Description: Installation state tracking system for resumable installations
# Platform: cross-platform
# Dependencies: logging.sh, dotfiles.sh
#

# Exit on error, undefined variables, and pipe failures
set -euo pipefail

# Installation state configuration
INSTALL_STATE_FILE="${DOTFILES_DIR}/.install-state"
INSTALL_LOCK_FILE="${DOTFILES_DIR}/.install-lock"
INSTALL_SESSION_ID="${INSTALL_SESSION_ID:-$(date +%s)}"

# Initialize state tracking
init_installation_state() {
    local operation="${1:-install}"
    
    # Check for existing lock file
    if [[ -f "$INSTALL_LOCK_FILE" ]]; then
        local lock_pid
        lock_pid=$(cat "$INSTALL_LOCK_FILE" 2>/dev/null || echo "")
        
        if [[ -n "$lock_pid" ]] && kill -0 "$lock_pid" 2>/dev/null; then
            log_error "Installation already in progress (PID: $lock_pid)"
            log_info "If you're sure no installation is running, remove: $INSTALL_LOCK_FILE"
            exit 1
        else
            log_warn "Stale lock file found, removing it"
            rm -f "$INSTALL_LOCK_FILE"
        fi
    fi
    
    # Create lock file
    echo "$$" > "$INSTALL_LOCK_FILE"
    
    # Initialize state file if it doesn't exist
    if [[ ! -f "$INSTALL_STATE_FILE" ]]; then
        log_info "Initializing installation state tracking"
        cat > "$INSTALL_STATE_FILE" << EOF
# Installation State Tracking
# Format: step_id:status:timestamp:session_id
# Status: pending|in_progress|completed|failed|skipped
EOF
    fi
    
    # Log session start
    log_info "Starting installation session: $INSTALL_SESSION_ID"
    echo "session_start:$operation:$(date '+%Y-%m-%d %H:%M:%S'):$INSTALL_SESSION_ID" >> "$INSTALL_STATE_FILE"
    
    # Set up cleanup on exit
    trap 'cleanup_installation_state' EXIT
    
    log_debug "Installation state tracking initialized"
}

# Clean up installation state
cleanup_installation_state() {
    if [[ -f "$INSTALL_LOCK_FILE" ]]; then
        rm -f "$INSTALL_LOCK_FILE"
        log_debug "Installation lock file removed"
    fi
    
    # Log session end
    echo "session_end:$(date '+%Y-%m-%d %H:%M:%S'):$INSTALL_SESSION_ID" >> "$INSTALL_STATE_FILE"
    log_debug "Installation session ended: $INSTALL_SESSION_ID"
}

# Mark a step as complete
mark_step_complete() {
    local step_id="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Remove any existing entries for this step
    if [[ -f "$INSTALL_STATE_FILE" ]]; then
        sed -i "/^$step_id:/d" "$INSTALL_STATE_FILE"
    fi
    
    # Add completion entry
    echo "$step_id:completed:$timestamp:$INSTALL_SESSION_ID" >> "$INSTALL_STATE_FILE"
    log_debug "Marked step complete: $step_id"
}

# Mark a step as failed
mark_step_failed() {
    local step_id="$1"
    local error_message="${2:-Unknown error}"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Remove any existing entries for this step
    if [[ -f "$INSTALL_STATE_FILE" ]]; then
        sed -i "/^$step_id:/d" "$INSTALL_STATE_FILE"
    fi
    
    # Add failure entry
    echo "$step_id:failed:$timestamp:$INSTALL_SESSION_ID:$error_message" >> "$INSTALL_STATE_FILE"
    log_error "Marked step failed: $step_id - $error_message"
}

# Mark a step as skipped
mark_step_skipped() {
    local step_id="$1"
    local reason="${2:-Already completed}"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Remove any existing entries for this step
    if [[ -f "$INSTALL_STATE_FILE" ]]; then
        sed -i "/^$step_id:/d" "$INSTALL_STATE_FILE"
    fi
    
    # Add skipped entry
    echo "$step_id:skipped:$timestamp:$INSTALL_SESSION_ID:$reason" >> "$INSTALL_STATE_FILE"
    log_debug "Marked step skipped: $step_id - $reason"
}

# Check if a step is complete
is_step_complete() {
    local step_id="$1"
    
    if [[ ! -f "$INSTALL_STATE_FILE" ]]; then
        return 1
    fi
    
    # Check if step is marked as completed
    grep -q "^$step_id:completed:" "$INSTALL_STATE_FILE" 2>/dev/null
}

# Get step status
get_step_status() {
    local step_id="$1"
    
    if [[ ! -f "$INSTALL_STATE_FILE" ]]; then
        echo "unknown"
        return 1
    fi
    
    # Get the most recent status for this step
    local status
    status=$(grep "^$step_id:" "$INSTALL_STATE_FILE" 2>/dev/null | tail -1 | cut -d: -f2)
    
    if [[ -n "$status" ]]; then
        echo "$status"
    else
        echo "pending"
    fi
}

# Get step completion time
get_step_completion_time() {
    local step_id="$1"
    
    if [[ ! -f "$INSTALL_STATE_FILE" ]]; then
        return 1
    fi
    
    local entry
    entry=$(grep "^$step_id:completed:" "$INSTALL_STATE_FILE" 2>/dev/null | tail -1)
    
    if [[ -n "$entry" ]]; then
        echo "$entry" | cut -d: -f3
    else
        return 1
    fi
}

# Get installation progress statistics
get_installation_progress() {
    if [[ ! -f "$INSTALL_STATE_FILE" ]]; then
        echo "0 0 0 0 0"
        return
    fi
    
    local total=0
    local completed=0
    local failed=0
    local skipped=0
    local pending=0
    
    # Count steps by status (excluding session entries and comment lines)
    while IFS=: read -r step_id status timestamp session_id rest; do
        if [[ "$step_id" != "session_start" && "$step_id" != "session_end" && ! "$step_id" =~ ^#.* ]]; then
            ((total++))
            case "$status" in
                completed) ((completed++)) ;;
                failed) ((failed++)) ;;
                skipped) ((skipped++)) ;;
                *) ((pending++)) ;;
            esac
        fi
    done < "$INSTALL_STATE_FILE"
    
    echo "$total $completed $failed $skipped $pending"
}

# Show installation progress
show_installation_progress() {
    local progress
    progress=$(get_installation_progress)
    read -r total completed failed skipped pending <<< "$progress"
    
    if [[ $total -eq 0 ]]; then
        log_info "No installation steps recorded yet"
        return
    fi
    
    local percentage=$((completed * 100 / total))
    
    log_info "Installation Progress Summary:"
    log_info "  Total steps: $total"
    log_info "  Completed: $completed ($percentage%)"
    log_info "  Failed: $failed"
    log_info "  Skipped: $skipped"
    log_info "  Pending: $pending"
    
    if [[ $failed -gt 0 ]]; then
        log_warn "Some steps have failed. Check the log for details."
    fi
}

# List failed steps
list_failed_steps() {
    if [[ ! -f "$INSTALL_STATE_FILE" ]]; then
        log_info "No installation state file found"
        return
    fi
    
    local failed_steps=()
    while IFS=: read -r step_id status timestamp session_id error_message; do
        if [[ "$status" == "failed" ]]; then
            failed_steps+=("$step_id")
        fi
    done < "$INSTALL_STATE_FILE"
    
    if [[ ${#failed_steps[@]} -eq 0 ]]; then
        log_info "No failed steps found"
    else
        log_warn "Failed steps:"
        for step in "${failed_steps[@]}"; do
            log_warn "  - $step"
        done
    fi
}

# Reset installation state
reset_installation_state() {
    local confirmation="${1:-}"
    
    if [[ "$confirmation" != "confirm" ]]; then
        log_warn "This will reset all installation progress"
        echo -n "Are you sure you want to reset installation state? (y/N): "
        read -r answer
        
        if [[ "$answer" != "y" && "$answer" != "Y" ]]; then
            log_info "Installation state reset cancelled"
            return
        fi
    fi
    
    # Remove state files
    rm -f "$INSTALL_STATE_FILE" "$INSTALL_LOCK_FILE"
    log_info "Installation state reset successfully"
}

# Resumable step runner
run_step() {
    local step_id="$1"
    local step_description="$2"
    local step_function="$3"
    shift 3
    local step_args=("$@")
    
    # Check if step is already complete
    if is_step_complete "$step_id"; then
        log_info "Skipping $step_description (already completed)"
        mark_step_skipped "$step_id" "Already completed"
        return 0
    fi
    
    # Mark step as in progress
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "$step_id:in_progress:$timestamp:$INSTALL_SESSION_ID" >> "$INSTALL_STATE_FILE"
    
    log_info "Running: $step_description"
    log_debug "Executing step: $step_id"
    
    # Execute the step function
    if "$step_function" "${step_args[@]}"; then
        mark_step_complete "$step_id"
        log_success "Completed: $step_description"
        return 0
    else
        local exit_code=$?
        mark_step_failed "$step_id" "Function returned exit code $exit_code"
        log_error "Failed: $step_description"
        return $exit_code
    fi
}

# Batch step runner for multiple steps
run_steps() {
    local steps=("$@")
    local failed_count=0
    
    for step_definition in "${steps[@]}"; do
        # Parse step definition (format: step_id:description:function:args...)
        IFS=':' read -ra step_parts <<< "$step_definition"
        local step_id="${step_parts[0]}"
        local step_description="${step_parts[1]}"
        local step_function="${step_parts[2]}"
        local step_args=("${step_parts[@]:3}")
        
        if ! run_step "$step_id" "$step_description" "$step_function" "${step_args[@]}"; then
            ((failed_count++))
            log_error "Step failed: $step_id"
        fi
    done
    
    if [[ $failed_count -gt 0 ]]; then
        log_error "$failed_count step(s) failed"
        return 1
    fi
    
    log_success "All steps completed successfully"
    return 0
}

# Export functions for use in other scripts
export -f init_installation_state cleanup_installation_state
export -f mark_step_complete mark_step_failed mark_step_skipped
export -f is_step_complete get_step_status get_step_completion_time
export -f get_installation_progress show_installation_progress
export -f list_failed_steps reset_installation_state
export -f run_step run_steps 
