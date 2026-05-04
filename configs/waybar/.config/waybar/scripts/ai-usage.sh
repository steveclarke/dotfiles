#!/usr/bin/env bash
set -u

CACHE_DIR="${XDG_CACHE_HOME:-${HOME}/.cache}/dotfiles/ai-usage"
STATE_FILE="${CACHE_DIR}/state.json"

emit_json() {
  jq -cn --arg text "$1" --arg tooltip "$2" --arg class "$3" '{text: $text, tooltip: $tooltip, class: $class}'
}

if ! command -v jq >/dev/null 2>&1; then
  printf '{"text":"AI --","tooltip":"jq is missing; run dotfiles install","class":"error"}\n'
  exit 0
fi

if [[ ! -f ${STATE_FILE} ]]; then
  emit_json "AI --" "AI usage has not been refreshed yet. Click to refresh." "missing"
  exit 0
fi

jq -c '
  def markup_escape:
    gsub("&"; "&amp;") | gsub("<"; "&lt;") | gsub(">"; "&gt;");

  def provider_label($key):
    if $key == "codex" then "Cx"
    elif $key == "claude" then "Cl"
    else $key
    end;

  def provider_name($key):
    if $key == "codex" then "Codex"
    elif $key == "claude" then "Claude"
    else $key
    end;

  def pct($value):
    if $value == null then "--" else ($value | tostring) end;

  def pct_text($value):
    if $value == null then "n/a" else "\($value)% left" end;

  def days_suffix($epoch; $now):
    if $epoch == null then ""
    else (($epoch - $now) / 86400) as $d
      | if $d <= 0 then ""
        elif $d < 1 then " <1d"
        else " \($d | ceil)d"
        end
    end;

  def provider_color($key):
    if $key == "claude" then "#D97757"
    else null
    end;

  def provider_text($state; $key; $now):
    ($state.providers[$key] // null) as $p
    | (if $p == null then "\(provider_label($key)) --"
       else "\(provider_label($key)) \(pct($p.weekly_left))\(days_suffix($p.weekly_reset_epoch; $now))"
       end) as $raw
    | ($raw | markup_escape) as $escaped
    | provider_color($key) as $color
    | if $color == null then $escaped
      else "<span color=\"\($color)\">\($escaped)</span>"
      end;

  def provider_tooltip($state; $key):
    ($state.providers[$key] // null) as $p
    | if $p == null then
        "\(provider_name($key)): no data"
      else
        "\(provider_name($key))\n  weekly: \(pct_text($p.weekly_left))\n  session: \(pct_text($p.session_left))\n  weekly reset: \($p.weekly_reset // "n/a")\n  session reset: \($p.session_reset // "n/a")\(if ($p.ok == false and ($p.error // "") != "") then "\n  note: showing cached data; latest refresh failed: \($p.error)" else "" end)"
      end;

  . as $state
  | (now | floor) as $now
  | (.updated_at_epoch // 0) as $updated
  | (.stale_after_seconds // 900) as $stale_after
  | (["codex", "claude"] | map(provider_text($state; .; $now)) | join(" · ")) as $text
  | (["codex", "claude"] | map(provider_tooltip($state; .)) | join("\n\n")) as $provider_tooltip
  | (($now - $updated) > $stale_after) as $stale
  | (["codex", "claude"] | map(. as $key | select($state.providers[$key] != null)) | length) as $provider_count
  | (["codex", "claude"] | map(. as $key | select(($state.providers[$key].ok // false) == true)) | length) as $ok_count
  | "Updated: \(($updated | strflocaltime("%a, %d %b at %-I:%M %p")) // "unknown")" as $updated_text
  | {
      text: $text,
      tooltip: (($provider_tooltip + "\n\n" + $updated_text) | markup_escape),
      class: (
        if $provider_count == 0 then "error"
        elif $stale then "stale"
        elif $ok_count < $provider_count then "warning"
        else "ai-usage"
        end
      )
    }
' "${STATE_FILE}" 2>/dev/null || emit_json "AI --" "AI usage cache is invalid. Click to refresh." "error"
