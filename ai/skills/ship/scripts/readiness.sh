#!/usr/bin/env bash
# readiness.sh — Manage readiness state for the /ship pipeline
#
# Usage:
#   readiness.sh log <project> <branch> <skill> <status> [key=value ...]   (e.g. head=<sha>)
#   readiness.sh check <project> <branch> <skill> [--head=<sha>] [--max-age=7200]
#   readiness.sh dashboard <project> <branch> [--head=<sha>] [--required=simplify,code-review,finalize]
#   readiness.sh status <project> <branch>
#   readiness.sh dir <project>
#   readiness.sh file <project> <branch>
#
# HEAD keying: when --head is passed, an entry is only valid if its logged
# "head" field matches, and matching entries never go stale by age. Without
# --head, the legacy time-based (max-age) behavior applies.

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
      # Escape backslashes and double-quotes so string values (e.g. a note=...)
      # can't produce invalid JSON that later breaks field extraction.
      local esc="${val//\\/\\\\}"
      esc="${esc//\"/\\\"}"
      extras="$extras,\"$key\":\"$esc\""
    fi
  done
  echo "$extras"
}

# Extract a string field's value from a JSONL entry, e.g. json_field "$line" head
json_field() {
  echo "$1" | sed -n "s/.*\"$2\":\"\([^\"]*\)\".*/\1/p"
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
  local want_head=""
  for arg in "$@"; do
    case "$arg" in
      --max-age=*) max_age="${arg#--max-age=}" ;;
      --head=*)    want_head="${arg#--head=}" ;;
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

  # Status must be a pass. "skipped" means "checked, nothing to do" — a valid
  # pass, so a skipped gate doesn't force a re-run.
  local status
  status="$(json_field "$latest" status)"
  if [ "$status" != "clean" ] && [ "$status" != "skipped" ]; then
    exit 1
  fi

  local timestamp
  timestamp="$(json_field "$latest" timestamp)"
  local entry_epoch
  entry_epoch="$(iso_to_epoch "$timestamp")"
  local current_epoch
  current_epoch="$(now_epoch)"
  local age=$(( current_epoch - entry_epoch ))

  if [ -n "$want_head" ]; then
    # HEAD-keyed: valid only if the logged head matches. Matching entries never
    # go stale by age — the diff is what matters, not the clock.
    local entry_head
    entry_head="$(json_field "$latest" head)"
    if [ -z "$entry_head" ] || [ "$entry_head" != "$want_head" ]; then
      exit 1
    fi
  else
    # Legacy time-based staleness.
    if [ "$age" -gt "$max_age" ]; then
      exit 1
    fi
  fi

  # Return relative time for display
  relative_time "$age"
  exit 0
}

cmd_dashboard() {
  local project="$1"; shift
  local branch="$1"; shift

  local required="$DEFAULT_REQUIRED"
  local want_head=""
  for arg in "$@"; do
    case "$arg" in
      --required=*) required="${arg#--required=}" ;;
      --head=*)     want_head="${arg#--head=}" ;;
    esac
  done

  local file
  file="$(readiness_file "$project" "$branch")"

  # All known steps (docs is covered inside finalize, not a separate gate)
  local all_steps="simplify code-review adversarial-review finalize"

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
        entry_status="$(json_field "$latest" status)"
        local timestamp
        timestamp="$(json_field "$latest" timestamp)"
        local entry_epoch
        entry_epoch="$(iso_to_epoch "$timestamp")"
        local current_epoch
        current_epoch="$(now_epoch)"
        local age=$(( current_epoch - entry_epoch ))
        time_str="$(relative_time "$age")"

        # Staleness: HEAD-keyed when --head given (entry's head must match),
        # else legacy time-based.
        local is_stale="no"
        if [ -n "$want_head" ]; then
          local entry_head
          entry_head="$(json_field "$latest" head)"
          [ "$entry_head" != "$want_head" ] && is_stale="yes"
        else
          [ "$age" -gt "$DEFAULT_MAX_AGE" ] && is_stale="yes"
        fi

        if [ "$is_stale" = "yes" ]; then
          status="STALE"
        elif [ "$entry_status" = "clean" ]; then
          status="DONE"
        elif [ "$entry_status" = "skipped" ]; then
          status="SKIPPED"
        elif [ "$entry_status" = "failed" ]; then
          status="FAILED"
        else
          status="$entry_status"
        fi
      fi
    fi

    # A required gate clears on DONE or SKIPPED (skipped = checked, nothing
    # affected). Anything else on a required gate blocks the verdict.
    if [ "$is_required" = "yes" ] && [ "$status" != "DONE" ] && [ "$status" != "SKIPPED" ]; then
      verdict="NOT CLEARED"
    fi

    # A FAILED gate always blocks, even an optional one. If you opted into
    # adversarial (not required) and it failed, the dashboard must not clear.
    if [ "$status" = "FAILED" ]; then
      verdict="NOT CLEARED"
    fi

    # Format required column. Adversarial is opt-in, never required.
    local req_display="$is_required"
    if [ "$step" = "adversarial-review" ]; then
      req_display="no"
    fi

    # Pretty-print step name
    local step_display
    case "$step" in
      simplify) step_display="Simplify" ;;
      code-review) step_display="Code Review" ;;
      adversarial-review) step_display="Adversarial Review" ;;
      finalize) step_display="Finalize" ;;
      *) step_display="$step" ;;
    esac

    printf '| %-19s| %-9s| %-14s| %-15s|\n' \
      "$step_display" "$status" "$time_str" "$req_display"
  done

  # Tests/coverage row from finalize entry — only when it applies to the diff
  # under review (matching --head), so stale numbers don't get shown as current.
  if [ -f "$file" ]; then
    local finalize_entry
    finalize_entry="$(grep '"skill":"finalize"' "$file" | tail -1)" || true
    if [ -n "$want_head" ] && [ -n "$finalize_entry" ]; then
      [ "$(json_field "$finalize_entry" head)" != "$want_head" ] && finalize_entry=""
    fi
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
