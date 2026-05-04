#!/usr/bin/env bash
set -u

PATH="${HOME}/.local/bin:/home/linuxbrew/.linuxbrew/bin:/usr/local/bin:/usr/bin:/bin:${PATH}"
CACHE_DIR="${XDG_CACHE_HOME:-${HOME}/.cache}/dotfiles/ai-usage"
STATE_FILE="${CACHE_DIR}/state.json"
LOCK_FILE="${CACHE_DIR}/refresh.lock"
PROVIDER_TIMEOUT_SECONDS="${DOTFILES_AI_USAGE_PROVIDER_TIMEOUT_SECONDS:-25}"
STALE_AFTER_SECONDS="${DOTFILES_AI_USAGE_STALE_AFTER_SECONDS:-900}"
WAYBAR_SIGNAL="${DOTFILES_AI_USAGE_WAYBAR_SIGNAL:-11}"

main() {
  case "${1:---refresh}" in
    --start)
      start_refresh_service
      ;;
    --refresh)
      refresh_state
      ;;
    *)
      echo "usage: $0 [--start|--refresh]" >&2
      return 2
      ;;
  esac
}

start_refresh_service() {
  if command -v systemctl >/dev/null 2>&1; then
    systemctl --user start dotfiles-ai-usage-refresh.service >/dev/null 2>&1 || refresh_state
  else
    refresh_state
  fi

  pkill -RTMIN+"${WAYBAR_SIGNAL}" waybar 2>/dev/null || true
}

refresh_state() {
  mkdir -p "${CACHE_DIR}"

  exec 9>"${LOCK_FILE}"
  if ! flock -n 9; then
    return 0
  fi

  if ! command -v jq >/dev/null 2>&1; then
    echo "jq is required" >&2
    return 1
  fi

  local now codex_state claude_state state tmp_file
  now="$(date +%s)"

  codex_state="$(fetch_provider_state codex cli "${now}")"
  claude_state="$(fetch_provider_state claude oauth "${now}")"

  state="$(jq -cn \
    --argjson now "${now}" \
    --argjson stale_after "${STALE_AFTER_SECONDS}" \
    --argjson codex "${codex_state}" \
    --argjson claude "${claude_state}" \
    '{
      schema: 1,
      updated_at_epoch: $now,
      stale_after_seconds: $stale_after,
      providers: {
        codex: $codex,
        claude: $claude
      }
    }')"

  tmp_file="${STATE_FILE}.$$"
  printf '%s\n' "${state}" >"${tmp_file}"
  jq -e 'type == "object" and .schema == 1' "${tmp_file}" >/dev/null
  mv "${tmp_file}" "${STATE_FILE}"
}

fetch_provider_state() {
  local provider="$1"
  local source="$2"
  local now="$3"
  local payload status normalized message previous err_file error_output

  err_file="$(mktemp)"
  payload="$(timeout "${PROVIDER_TIMEOUT_SECONDS}" codexbar usage --provider "${provider}" --source "${source}" --format json --json-only 2>"${err_file}")"
  status=$?
  error_output="$(tr '\n' ' ' <"${err_file}")"
  rm -f "${err_file}"

  normalized="$(normalize_payload "${payload}")"
  if [[ -n ${normalized} ]] && ! payload_has_error "${normalized}"; then
    provider_state_from_payload "${provider}" "${source}" "${normalized}" "${now}"
    return 0
  fi

  if [[ -n ${normalized} ]]; then
    message="$(payload_error_message "${normalized}")"
  elif (( status == 124 )); then
    message="codexbar ${provider} ${source} usage timed out after ${PROVIDER_TIMEOUT_SECONDS}s"
  else
    message="$(first_nonempty "${error_output}" "codexbar ${provider} ${source} usage failed")"
  fi

  previous="$(previous_provider_state "${provider}")"
  if [[ -n ${previous} ]]; then
    jq -c --arg error "${message}" '. + {ok: false, error: $error}' <<<"${previous}"
  else
    empty_provider_state "${provider}" "${source}" "${now}" "${message}"
  fi
}

normalize_payload() {
  local payload="$1"

  [[ -n ${payload} ]] || return 0
  jq -c -s 'if length > 0 and (.[0] | type) == "array" then .[0] else empty end' <<<"${payload}" 2>/dev/null
}

payload_has_error() {
  local payload="$1"

  jq -e 'map(select(.error != null)) | length > 0' <<<"${payload}" >/dev/null 2>&1
}

payload_error_message() {
  local payload="$1"

  jq -r 'map(.error.message? // empty) | first // "provider usage failed"' <<<"${payload}" 2>/dev/null
}

previous_provider_state() {
  local provider="$1"

  [[ -f ${STATE_FILE} ]] || return 0
  jq -c --arg provider "${provider}" '.providers[$provider] // empty' "${STATE_FILE}" 2>/dev/null
}

provider_state_from_payload() {
  local provider="$1"
  local source="$2"
  local payload="$3"
  local now="$4"

  jq -c \
    --arg provider "${provider}" \
    --arg source "${source}" \
    --argjson now "${now}" '
    def clamp:
      if . < 0 then 0 elif . > 100 then 100 else . end;

    def remaining($window):
      if $window == null then null
      else ((100 - ($window.usedPercent // 100)) | clamp | round)
      end;

    def reset_text($window):
      if $window == null then null
      elif $window.resetsAt != null then ($window.resetsAt | fromdateiso8601 | strflocaltime("%a, %d %b at %-I:%M %p"))
      else ($window.resetDescription // null)
      end;

    def reset_epoch($window):
      if $window == null then null
      elif $window.resetsAt != null then ($window.resetsAt | fromdateiso8601)
      else null
      end;

    .[0] as $item
    | {
        ok: true,
        source: ($item.source // $source),
        fetched_at_epoch: $now,
        weekly_left: remaining($item.usage.secondary),
        session_left: remaining($item.usage.primary),
        weekly_reset: reset_text($item.usage.secondary),
        session_reset: reset_text($item.usage.primary),
        weekly_reset_epoch: reset_epoch($item.usage.secondary),
        session_reset_epoch: reset_epoch($item.usage.primary),
        error: null
      }
  ' <<<"${payload}"
}

empty_provider_state() {
  local provider="$1"
  local source="$2"
  local now="$3"
  local message="$4"

  jq -cn \
    --arg source "${source}" \
    --arg error "${message}" \
    --argjson now "${now}" \
    '{
      ok: false,
      source: $source,
      fetched_at_epoch: $now,
      weekly_left: null,
      session_left: null,
      weekly_reset: null,
      session_reset: null,
      weekly_reset_epoch: null,
      session_reset_epoch: null,
      error: $error
    }'
}

first_nonempty() {
  local primary="$1"
  local fallback="$2"
  primary="${primary#"${primary%%[![:space:]]*}"}"
  primary="${primary%"${primary##*[![:space:]]}"}"

  if [[ -n ${primary} ]]; then
    printf '%s\n' "${primary}"
  else
    printf '%s\n' "${fallback}"
  fi
}

main "$@"
