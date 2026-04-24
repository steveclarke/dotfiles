#!/usr/bin/env bash
set -u

PATH="${HOME}/.local/bin:/home/linuxbrew/.linuxbrew/bin:/usr/local/bin:/usr/bin:/bin:${PATH}"
PROVIDER_TIMEOUT_SECONDS="${DOTFILES_AI_USAGE_PROVIDER_TIMEOUT_SECONDS:-12}"
CACHE_DIR="${XDG_CACHE_HOME:-${HOME}/.cache}/dotfiles/ai-usage"
CODEX_MIN_INTERVAL_SECONDS="${DOTFILES_AI_USAGE_CODEX_MIN_INTERVAL_SECONDS:-90}"
CLAUDE_MIN_INTERVAL_SECONDS="${DOTFILES_AI_USAGE_CLAUDE_MIN_INTERVAL_SECONDS:-300}"
LOCK_DIR="${CACHE_DIR}/refresh.lock"
RENDER_CACHE_FILE="${CACHE_DIR}/waybar.json"

main() {
  mkdir -p "${CACHE_DIR}"

  if ! acquire_refresh_lock; then
    if read_render_cache; then
      return 0
    fi

    emit_error "AI usage refresh already running" "Previous CodexBar usage refresh is still in progress"
    return 0
  fi
  trap release_refresh_lock EXIT

  if ! command -v jq >/dev/null 2>&1; then
    emit_static_error "jq is missing; run dotfiles install"
    return 0
  fi

  if ! command -v codexbar >/dev/null 2>&1; then
    emit_error "CodexBar CLI is not installed" "Install with dotfiles or run install/arch/cli/codexbar.sh"
    return 0
  fi

  local codex_payload claude_payload payload
  codex_payload="$(fetch_provider codex)"
  claude_payload="$(fetch_provider claude)"
  payload="$(jq -cn --argjson codex "${codex_payload}" --argjson claude "${claude_payload}" '$codex + $claude')"

  write_render_cache "$(render_waybar_json "${payload}")"
}

fetch_provider() {
  local provider="$1"
  local source payload normalized_payload status err_file error_output message
  source="$(provider_source "${provider}")"

  if should_use_cached_before_fetch "${provider}"; then
    read_provider_cache "${provider}"
    return 0
  fi

  err_file="$(mktemp)"
  payload="$(timeout "${PROVIDER_TIMEOUT_SECONDS}" codexbar usage --provider "${provider}" --source "${source}" --format json --json-only 2>"${err_file}")"
  status=$?
  error_output="$(cat "${err_file}")"
  rm -f "${err_file}"

  normalized_payload="$(normalize_provider_payload "${payload}")"
  if [[ -n ${normalized_payload} ]]; then
    if is_claude_oauth_rate_limited "${provider}" "${source}" "${normalized_payload}"; then
      if read_provider_cache_with_note "${provider}" "showing cached data; Anthropic rate-limited the latest refresh"; then
        return 0
      fi

      make_error_payload "${provider}" "${source}" "$(claude_oauth_rate_limit_message)"
      return 0
    fi

    if provider_payload_has_error "${normalized_payload}"; then
      message="$(provider_payload_error_message "${normalized_payload}")"
    else
      write_provider_cache "${provider}" "${normalized_payload}"
      printf '%s\n' "${normalized_payload}"
      return 0
    fi
  fi

  if [[ -z ${message:-} ]]; then
    if (( status == 124 )); then
      message="codexbar ${provider} ${source} usage timed out after ${PROVIDER_TIMEOUT_SECONDS}s"
    else
      message="$(first_nonempty "${error_output}" "codexbar ${provider} ${source} usage failed")"
    fi
  fi
  message="$(friendly_provider_error "${provider}" "${source}" "${message}")"

  if read_provider_cache_with_note "${provider}" "showing cached data; latest refresh failed: ${message}"; then
    return 0
  fi

  make_error_payload "${provider}" "${source}" "${message}"
}

acquire_refresh_lock() {
  mkdir "${LOCK_DIR}" 2>/dev/null
}

release_refresh_lock() {
  rmdir "${LOCK_DIR}" 2>/dev/null || true
}

read_render_cache() {
  [[ -f ${RENDER_CACHE_FILE} ]] || return 1
  jq -c 'select(type == "object" and (.text // "") != "")' "${RENDER_CACHE_FILE}" 2>/dev/null
}

write_render_cache() {
  local output="$1"
  local tmp_file

  tmp_file="${RENDER_CACHE_FILE}.$$"
  printf '%s\n' "${output}" >"${tmp_file}"
  mv "${tmp_file}" "${RENDER_CACHE_FILE}"
  printf '%s\n' "${output}"
}

provider_source() {
  case "$1" in
    codex) printf '%s\n' "${DOTFILES_AI_USAGE_CODEX_SOURCE:-cli}" ;;
    claude) printf '%s\n' "${DOTFILES_AI_USAGE_CLAUDE_SOURCE:-oauth}" ;;
    *) printf '%s\n' "cli" ;;
  esac
}

normalize_provider_payload() {
  local payload="$1"

  [[ -n ${payload} ]] || return 0
  printf '%s' "${payload}" | jq -c -s '
    if length > 0 and (.[0] | type) == "array" then .[0] else empty end
  ' 2>/dev/null
}

provider_cache_file() {
  printf '%s/%s.json\n' "${CACHE_DIR}" "$1"
}

should_use_cached_before_fetch() {
  local provider="$1"
  local cache_file age now modified min_interval

  case "${provider}" in
    codex) min_interval="${CODEX_MIN_INTERVAL_SECONDS}" ;;
    claude) min_interval="${CLAUDE_MIN_INTERVAL_SECONDS}" ;;
    *) return 1 ;;
  esac

  cache_file="$(provider_cache_file "${provider}")"
  [[ -f ${cache_file} ]] || return 1

  now="$(date +%s)"
  modified="$(stat -c %Y "${cache_file}" 2>/dev/null || printf '0')"
  age=$((now - modified))
  (( age < min_interval )) || return 1

  jq -e 'type == "array" and length > 0' "${cache_file}" >/dev/null 2>&1
}

read_provider_cache() {
  local provider="$1"
  local cache_file

  cache_file="$(provider_cache_file "${provider}")"
  jq -c '.' "${cache_file}"
}

read_provider_cache_with_note() {
  local provider="$1"
  local note="$2"
  local cache_file

  cache_file="$(provider_cache_file "${provider}")"
  [[ -f ${cache_file} ]] || return 1
  jq -c --arg note "${note}" '
    if type == "array" and length > 0 then
      map(. + {dotfilesNote: $note})
    else
      empty
    end
  ' "${cache_file}" 2>/dev/null
}

write_provider_cache() {
  local provider="$1"
  local payload="$2"
  local cache_file tmp_file

  mkdir -p "${CACHE_DIR}"
  cache_file="$(provider_cache_file "${provider}")"
  tmp_file="${cache_file}.$$"
  printf '%s\n' "${payload}" >"${tmp_file}"
  mv "${tmp_file}" "${cache_file}"
}

provider_payload_has_error() {
  local payload="$1"

  printf '%s' "${payload}" | jq -e 'map(select(.error != null)) | length > 0' >/dev/null 2>&1
}

provider_payload_error_message() {
  local payload="$1"

  printf '%s' "${payload}" | jq -r 'map(.error.message? // empty) | first // "provider usage failed"' 2>/dev/null
}

is_claude_oauth_rate_limited() {
  local provider="$1"
  local source="$2"
  local payload="$3"

  [[ ${provider} == "claude" && ${source} == "oauth" ]] || return 1
  [[ ${payload} =~ HTTP[[:space:]]429 || ${payload} =~ Rate[[:space:]]limited ]]
}

friendly_provider_error() {
  local provider="$1"
  local source="$2"
  local message="$3"

  if [[ ${provider} == "claude" && ${source} == "oauth" && ${message} =~ (HTTP[[:space:]]429|Rate[[:space:]]limited) ]]; then
    claude_oauth_rate_limit_message
  else
    printf '%s\n' "${message}"
  fi
}

claude_oauth_rate_limit_message() {
  printf '%s\n' "Claude OAuth is rate limited by Anthropic. Run: claude logout; claude login, then click this module."
}

make_error_payload() {
  local provider="$1"
  local source="$2"
  local message="$3"

  jq -cn --arg provider "${provider}" --arg source "${source}" --arg message "${message}" '[{
    provider: $provider,
    source: $source,
    usage: null,
    credits: null,
    error: {
      code: 1,
      message: $message,
      kind: "provider"
    }
  }]'
}

first_nonempty() {
  local primary="$1"
  local fallback="$2"
  primary="${primary//$'\n'/ }"
  primary="${primary#"${primary%%[![:space:]]*}"}"
  primary="${primary%"${primary##*[![:space:]]}"}"

  if [[ -n ${primary} ]]; then
    printf '%s\n' "${primary}"
  else
    printf '%s\n' "${fallback}"
  fi
}

emit_static_error() {
  printf '{"text":"AI --","tooltip":"%s","class":"error"}\n' "$1"
}

emit_error() {
  jq -cn --arg text "$1" --arg tooltip "$2" '{text: $text, tooltip: $tooltip, class: "error"}'
}

render_waybar_json() {
  local payload="$1"

  printf '%s' "${payload}" | jq -c '
    def markup_escape:
      gsub("&"; "&amp;") | gsub("<"; "&lt;") | gsub(">"; "&gt;");

    def clamp:
      if . < 0 then 0 elif . > 100 then 100 else . end;

    def remaining($window):
      if $window == null then null
      else ((100 - ($window.usedPercent // 100)) | clamp | round)
      end;

    def provider_label:
      if .provider == "codex" then "Cx"
      elif .provider == "claude" then "Cl"
      else .provider
      end;

    def provider_name:
      if .provider == "codex" then "Codex"
      elif .provider == "claude" then "Claude"
      else .provider
      end;

    def pct_text($value):
      if $value == null then "n/a" else "\($value)% left" end;

    def reset_text($window):
      if $window == null then "n/a"
      elif $window.resetsAt != null then ($window.resetsAt | fromdateiso8601 | strflocaltime("%a, %d %b at %-I:%M %p"))
      else ($window.resetDescription // "n/a")
      end;

    def display_percent:
      remaining(.usage.secondary) // remaining(.usage.primary);

    def provider_text:
      if .error != null then "\(provider_label) !"
      else (display_percent as $pct | "\(provider_label) \(if $pct == null then "--" else ($pct | tostring) end)")
      end;

    def provider_tooltip:
      if .error != null then
        "\(provider_name): \(.error.message // "failed")"
      else
        "\(provider_name)\n  weekly: \(pct_text(remaining(.usage.secondary)))\n  session: \(pct_text(remaining(.usage.primary)))\n  weekly reset: \(reset_text(.usage.secondary))\n  session reset: \(reset_text(.usage.primary))\(if .dotfilesNote then "\n  note: \(.dotfilesNote)" else "" end)"
      end;

    . as $items
    | ($items | map(provider_text) | join(" · ")) as $text
    | ($items | map(provider_tooltip) | join("\n\n")) as $tooltip
    | ($items | map(select(.error != null)) | length) as $errors
    | ($items | map(select(.dotfilesNote != null)) | length) as $notes
    | ($items | map(display_percent) | map(select(. != null)) | min) as $min
    | {
        text: ((if $text == "" then "AI --" else $text end) | markup_escape),
        tooltip: ((if $tooltip == "" then "No CodexBar usage data" else $tooltip end) | markup_escape),
        class: (
          if (($items | length) == 0) or ($errors == ($items | length)) then "error"
          elif $errors > 0 then "warning"
          elif $notes > 0 then "warning"
          elif $min != null and $min <= 15 then "critical"
          elif $min != null and $min <= 30 then "warning"
          else "ai-usage"
          end
        )
      }
  '
}

main "$@"
