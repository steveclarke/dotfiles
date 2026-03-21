#!/usr/bin/env bash
# architect.sh — Config/state management for the /architect skill
#
# Usage:
#   architect.sh init <slug> <json> [--force]
#   architect.sh config <slug>
#   architect.sh state <slug>
#   architect.sh update-state <slug> [key=value ...]
#   architect.sh sweep-log <slug> <json-line>
#   architect.sh last-sweep <slug>
#   architect.sh projects
#   architect.sh parse-artifact <slug>
#   architect.sh detect

set -euo pipefail

ARCHITECT_DIR="$HOME/.config/steveos/architect"

# --- Helpers ---

slugify() {
  echo "$1" | tr '[:upper:]' '[:lower:]' | sed 's/[_ ]/-/g'
}

project_slug() {
  local root
  root="$(git rev-parse --show-toplevel 2>/dev/null)" || {
    echo "Not in a git repository" >&2
    return 1
  }
  slugify "$(basename "$root")"
}

project_dir() {
  local slug="$1"
  echo "$ARCHITECT_DIR/$slug"
}

now_iso() {
  date -u +"%Y-%m-%dT%H:%M:%SZ"
}

ensure_dir() {
  local slug="$1"
  mkdir -p "$ARCHITECT_DIR/$slug"
}

# --- Commands ---

cmd_init() {
  local slug="$1"; shift
  local json="$1"; shift
  local force=false
  for arg in "$@"; do
    case "$arg" in --force) force=true ;; esac
  done

  ensure_dir "$slug"
  local config_file="$ARCHITECT_DIR/$slug/config.json"

  if [ -f "$config_file" ] && [ "$force" != "true" ]; then
    echo "Config already exists for $slug. Use --force to overwrite." >&2
    exit 1
  fi

  echo "$json" > "$config_file"
  echo "Initialized config for $slug"
}

cmd_config() {
  local slug="$1"
  local config_file="$ARCHITECT_DIR/$slug/config.json"

  if [ ! -f "$config_file" ]; then
    echo "No config found for $slug" >&2
    exit 1
  fi

  cat "$config_file"
}

cmd_state() {
  local slug="$1"
  local state_file="$ARCHITECT_DIR/$slug/state.json"

  if [ ! -f "$state_file" ]; then
    echo "{}"
    return
  fi

  cat "$state_file"
}

cmd_update_state() {
  local slug="$1"; shift
  ensure_dir "$slug"
  local state_file="$ARCHITECT_DIR/$slug/state.json"

  # Start with existing state or empty object
  local current="{}"
  if [ -f "$state_file" ]; then
    current="$(cat "$state_file")"
  fi

  # Build jq expression from key=value pairs
  local jq_expr="."
  for kv in "$@"; do
    local key="${kv%%=*}"
    local val="${kv#*=}"
    # Numbers stay as numbers, everything else is a string
    if [[ "$val" =~ ^[0-9]+$ ]]; then
      jq_expr="$jq_expr | .$key = $val"
    else
      jq_expr="$jq_expr | .$key = \"$val\""
    fi
  done

  echo "$current" | jq "$jq_expr" > "$state_file"
  echo "Updated state for $slug"
}

cmd_sweep_log() {
  local slug="$1"
  local json_line="$2"
  ensure_dir "$slug"
  echo "$json_line" >> "$ARCHITECT_DIR/$slug/sweep-cache.jsonl"
  echo "Sweep logged for $slug"
}

cmd_last_sweep() {
  local slug="$1"
  local cache_file="$ARCHITECT_DIR/$slug/sweep-cache.jsonl"

  if [ ! -f "$cache_file" ]; then
    echo "No sweep cache for $slug" >&2
    exit 1
  fi

  tail -1 "$cache_file"
}

cmd_projects() {
  local found=false
  if [ -d "$ARCHITECT_DIR" ]; then
    for dir in "$ARCHITECT_DIR"/*/; do
      [ -d "$dir" ] || continue
      if [ -f "$dir/config.json" ]; then
        basename "$dir"
        found=true
      fi
    done
  fi

  if [ "$found" = "false" ]; then
    echo "No configured projects" >&2
  fi
}

cmd_parse_artifact() {
  local slug="$1"
  local config_file="$ARCHITECT_DIR/$slug/config.json"

  if [ ! -f "$config_file" ]; then
    echo "No config found for $slug" >&2
    exit 1
  fi

  local project_root artifact_path
  project_root="$(jq -r '.project_root' "$config_file")"
  artifact_path="$(jq -r '.artifact_path' "$config_file")"
  local artifact_file="$project_root/$artifact_path"

  if [ ! -f "$artifact_file" ]; then
    echo '{"findings_total":0,"findings_resolved":0,"action_plan_phases":0,"action_plan_completed":0}'
    return
  fi

  local findings_total
  findings_total=$(grep -c '^#### Finding:' "$artifact_file" 2>/dev/null || echo 0)

  local findings_resolved
  findings_resolved=$(grep -c '^#### Finding:.*\[RESOLVED\]' "$artifact_file" 2>/dev/null || echo 0)

  local action_plan_phases
  action_plan_phases=$(sed -n '/^## Action Plan/,$ p' "$artifact_file" | grep -c '^### Phase' 2>/dev/null || echo 0)

  local action_plan_completed
  action_plan_completed=$(sed -n '/^## Action Plan/,$ p' "$artifact_file" | grep -c '^### Phase.*\[COMPLETE\]' 2>/dev/null || echo 0)

  printf '{"findings_total":%d,"findings_resolved":%d,"action_plan_phases":%d,"action_plan_completed":%d}\n' \
    "$findings_total" "$findings_resolved" "$action_plan_phases" "$action_plan_completed"
}

cmd_detect() {
  local root
  root="$(git rev-parse --show-toplevel 2>/dev/null)" || {
    echo '{"slug":"","root":"","configured":false}'
    return
  }

  local slug
  slug="$(slugify "$(basename "$root")")"

  local configured=false
  if [ -f "$ARCHITECT_DIR/$slug/config.json" ]; then
    configured=true
  fi

  printf '{"slug":"%s","root":"%s","configured":%s}\n' "$slug" "$root" "$configured"
}

# --- Main ---

main() {
  if [ $# -lt 1 ]; then
    echo "Usage: architect.sh <command> [args...]"
    echo "Commands: init, config, state, update-state, sweep-log, last-sweep, projects, parse-artifact, detect"
    exit 1
  fi

  local cmd="$1"; shift
  case "$cmd" in
    init)            cmd_init "$@" ;;
    config)          cmd_config "$@" ;;
    state)           cmd_state "$@" ;;
    update-state)    cmd_update_state "$@" ;;
    sweep-log)       cmd_sweep_log "$@" ;;
    last-sweep)      cmd_last_sweep "$@" ;;
    projects)        cmd_projects "$@" ;;
    parse-artifact)  cmd_parse_artifact "$@" ;;
    detect)          cmd_detect "$@" ;;
    *)
      echo "Unknown command: $cmd" >&2
      exit 1
      ;;
  esac
}

main "$@"
