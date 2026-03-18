#!/usr/bin/env bash
# readiness.sh — Manage readiness state for the /ship pipeline
#
# Usage:
#   readiness.sh log <project> <branch> <skill> <status> [key=value ...]
#   readiness.sh check <project> <branch> <skill> [--max-age=7200]
#   readiness.sh dashboard <project> <branch> [--required=simplify,code-review,finalize]
#   readiness.sh status <project> <branch>
#   readiness.sh dir <project>
#   readiness.sh file <project> <branch>

set -euo pipefail

READINESS_DIR="$HOME/.config/steveos/readiness"
DEFAULT_MAX_AGE=7200  # 2 hours in seconds
DEFAULT_REQUIRED="simplify,code-review,finalize"

# --- Helpers ---

sanitize_branch() {
  echo "$1" | sed 's|/|--|g'
}

readiness_file() {
  local project="$1"
  local branch
  branch="$(sanitize_branch "$2")"
  echo "$READINESS_DIR/$project/$branch.jsonl"
}

ensure_dir() {
  local project="$1"
  mkdir -p "$READINESS_DIR/$project"
}

now_iso() {
  date -u +"%Y-%m-%dT%H:%M:%SZ"
}

now_epoch() {
  date -u +%s
}

iso_to_epoch() {
  # macOS-compatible ISO 8601 to epoch (UTC)
  local ts="$1"
  # Strip trailing Z for date parsing
  if date -j -u -f "%Y-%m-%dT%H:%M:%S" "${ts%Z}" +%s 2>/dev/null; then
    return
  fi
  # Fallback: GNU date
  date -u -d "$ts" +%s 2>/dev/null || echo 0
}

relative_time() {
  local seconds="$1"
  if [ "$seconds" -lt 60 ]; then
    echo "${seconds}s ago"
  elif [ "$seconds" -lt 3600 ]; then
    echo "$(( seconds / 60 )) min ago"
  elif [ "$seconds" -lt 86400 ]; then
    echo "$(( seconds / 3600 ))h ago"
  else
    echo "$(( seconds / 86400 ))d ago"
  fi
}

build_json_extras() {
  local extras=""
  for kv in "$@"; do
    local key="${kv%%=*}"
    local val="${kv#*=}"
    # Detect booleans and numbers
    if [[ "$val" == "true" || "$val" == "false" ]]; then
      extras="$extras,\"$key\":$val"
    elif [[ "$val" =~ ^[0-9]+$ ]]; then
      extras="$extras,\"$key\":$val"
    else
      extras="$extras,\"$key\":\"$val\""
    fi
  done
  echo "$extras"
}

# --- Commands ---

cmd_log() {
  local project="$1"; shift
  local branch="$1"; shift
  local skill="$1"; shift
  local status="$1"; shift

  ensure_dir "$project"
  local file
  file="$(readiness_file "$project" "$branch")"

  local extras=""
  if [ $# -gt 0 ]; then
    extras="$(build_json_extras "$@")"
  fi

  local timestamp
  timestamp="$(now_iso)"

  printf '{"skill":"%s","timestamp":"%s","status":"%s","branch":"%s"%s}\n' \
    "$skill" "$timestamp" "$status" "$branch" "$extras" >> "$file"

  echo "Logged: $skill=$status for $branch"
}

cmd_check() {
  local project="$1"; shift
  local branch="$1"; shift
  local skill="$1"; shift

  local max_age="$DEFAULT_MAX_AGE"
  for arg in "$@"; do
    case "$arg" in
      --max-age=*) max_age="${arg#--max-age=}" ;;
    esac
  done

  local file
  file="$(readiness_file "$project" "$branch")"

  if [ ! -f "$file" ]; then
    exit 1
  fi

  # Find the latest entry for this skill
  local latest
  latest="$(grep "\"skill\":\"$skill\"" "$file" | tail -1)" || true

  if [ -z "$latest" ]; then
    exit 1
  fi

  # Check status
  local status
  status="$(echo "$latest" | sed -n 's/.*"status":"\([^"]*\)".*/\1/p')"
  if [ "$status" != "clean" ]; then
    exit 1
  fi

  # Check staleness
  local timestamp
  timestamp="$(echo "$latest" | sed -n 's/.*"timestamp":"\([^"]*\)".*/\1/p')"
  local entry_epoch
  entry_epoch="$(iso_to_epoch "$timestamp")"
  local current_epoch
  current_epoch="$(now_epoch)"
  local age=$(( current_epoch - entry_epoch ))

  if [ "$age" -gt "$max_age" ]; then
    exit 1
  fi

  # Return relative time for display
  echo "$(relative_time "$age")"
  exit 0
}

cmd_dashboard() {
  local project="$1"; shift
  local branch="$1"; shift

  local required="$DEFAULT_REQUIRED"
  for arg in "$@"; do
    case "$arg" in
      --required=*) required="${arg#--required=}" ;;
    esac
  done

  local file
  file="$(readiness_file "$project" "$branch")"

  # All known steps
  local all_steps="simplify code-review adversarial-review finalize update-docs"

  local verdict="CLEARED"
  local width=66

  printf '+%s+\n' "$(printf '=%.0s' $(seq 1 $width))"
  printf '| %-*s|\n' "$((width - 1))" "SHIP READINESS — $branch"
  printf '+%s+\n' "$(printf '=%.0s' $(seq 1 $width))"
  printf '| %-19s| %-9s| %-14s| %-15s|\n' "Step" "Status" "Time" "Required"
  printf '|%s|%s|%s|%s|\n' \
    "$(printf -- '-%.0s' $(seq 1 20))" \
    "$(printf -- '-%.0s' $(seq 1 10))" \
    "$(printf -- '-%.0s' $(seq 1 15))" \
    "$(printf -- '-%.0s' $(seq 1 16))"

  for step in $all_steps; do
    local is_required="no"
    if echo ",$required," | grep -q ",$step,"; then
      is_required="yes"
    fi

    local status="NOT RUN"
    local time_str="—"

    if [ -f "$file" ]; then
      local latest
      latest="$(grep "\"skill\":\"$step\"" "$file" | tail -1)" || true

      if [ -n "$latest" ]; then
        local entry_status
        entry_status="$(echo "$latest" | sed -n 's/.*"status":"\([^"]*\)".*/\1/p')"
        local timestamp
        timestamp="$(echo "$latest" | sed -n 's/.*"timestamp":"\([^"]*\)".*/\1/p')"
        local entry_epoch
        entry_epoch="$(iso_to_epoch "$timestamp")"
        local current_epoch
        current_epoch="$(now_epoch)"
        local age=$(( current_epoch - entry_epoch ))

        if [ "$age" -gt "$DEFAULT_MAX_AGE" ]; then
          status="STALE"
          time_str="$(relative_time "$age")"
        elif [ "$entry_status" = "clean" ]; then
          status="DONE"
          time_str="$(relative_time "$age")"
        elif [ "$entry_status" = "failed" ]; then
          status="FAILED"
          time_str="$(relative_time "$age")"
        else
          status="$entry_status"
          time_str="$(relative_time "$age")"
        fi
      fi
    fi

    # Check if this blocks the verdict
    if [ "$is_required" = "yes" ] && [ "$status" != "DONE" ]; then
      verdict="NOT CLEARED"
    fi

    # Format required column
    local req_display="$is_required"
    if [ "$step" = "adversarial-review" ] && [ "$status" = "NOT RUN" ]; then
      req_display="no"
    fi
    if [ "$step" = "update-docs" ] && [ "$status" = "NOT RUN" ]; then
      req_display="no"
    fi

    # Pretty-print step name
    local step_display
    case "$step" in
      simplify) step_display="Simplify" ;;
      code-review) step_display="Code Review" ;;
      adversarial-review) step_display="Adversarial Review" ;;
      finalize) step_display="Finalize" ;;
      update-docs) step_display="Update Docs" ;;
      *) step_display="$step" ;;
    esac

    printf '| %-19s| %-9s| %-14s| %-15s|\n' \
      "$step_display" "$status" "$time_str" "$req_display"
  done

  # Tests/coverage row from finalize entry
  if [ -f "$file" ]; then
    local finalize_entry
    finalize_entry="$(grep '"skill":"finalize"' "$file" | tail -1)" || true
    if [ -n "$finalize_entry" ]; then
      printf '|%s|\n' "$(printf -- '-%.0s' $(seq 1 $width))"
      local tests_passed
      tests_passed="$(echo "$finalize_entry" | sed -n 's/.*"tests_passed":\([a-z]*\).*/\1/p')" || true
      local coverage_ok
      coverage_ok="$(echo "$finalize_entry" | sed -n 's/.*"coverage_ok":\([a-z]*\).*/\1/p')" || true

      if [ -n "$tests_passed" ]; then
        local test_status="PASSED"
        [ "$tests_passed" = "false" ] && test_status="FAILED"
        printf '| %-19s| %-9s| %-14s| %-15s|\n' "Tests" "$test_status" "via finalize" ""
      fi
      if [ -n "$coverage_ok" ]; then
        local cov_status="OK"
        [ "$coverage_ok" = "false" ] && cov_status="GAPS"
        printf '| %-19s| %-9s| %-14s| %-15s|\n' "Test Coverage" "$cov_status" "" ""
      fi
    fi
  fi

  printf '+%s+\n' "$(printf -- '-%.0s' $(seq 1 $width))"
  printf '| %-*s|\n' "$((width - 1))" "VERDICT: $verdict"
  printf '+%s+\n' "$(printf '=%.0s' $(seq 1 $width))"
}

cmd_status() {
  local project="$1"
  local branch="$2"
  local file
  file="$(readiness_file "$project" "$branch")"

  if [ ! -f "$file" ]; then
    echo "No readiness data for $project/$branch"
    exit 0
  fi

  cat "$file"
}

cmd_dir() {
  local project="$1"
  ensure_dir "$project"
  echo "$READINESS_DIR/$project"
}

cmd_file() {
  local project="$1"
  local branch="$2"
  readiness_file "$project" "$branch"
}

# --- Main ---

main() {
  if [ $# -lt 1 ]; then
    echo "Usage: readiness.sh <command> [args...]"
    echo "Commands: log, check, dashboard, status, dir, file"
    exit 1
  fi

  local cmd="$1"; shift

  case "$cmd" in
    log)       cmd_log "$@" ;;
    check)     cmd_check "$@" ;;
    dashboard) cmd_dashboard "$@" ;;
    status)    cmd_status "$@" ;;
    dir)       cmd_dir "$@" ;;
    file)      cmd_file "$@" ;;
    *)
      echo "Unknown command: $cmd"
      exit 1
      ;;
  esac
}

main "$@"
