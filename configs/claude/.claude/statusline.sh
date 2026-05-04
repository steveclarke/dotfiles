#!/bin/bash
set -f

input=$(cat)

if [ -z "$input" ]; then
    printf "Claude"
    exit 0
fi

# ── Colors ──────────────────────────────────────────────
blue='\033[38;2;0;153;255m'
orange='\033[38;2;255;176;85m'
green='\033[38;2;0;175;80m'
cyan='\033[38;2;86;182;194m'
red='\033[38;2;255;85;85m'
yellow='\033[38;2;230;200;0m'
magenta='\033[38;2;180;140;255m'
dim='\033[2m'
reset='\033[0m'

sep=" ${dim}·${reset} "

# ── Helpers ─────────────────────────────────────────────
color_for_pct() {
    local pct=$1
    if [ "$pct" -ge 90 ]; then printf "$red"
    elif [ "$pct" -ge 70 ]; then printf "$yellow"
    elif [ "$pct" -ge 50 ]; then printf "$orange"
    else printf "$green"
    fi
}

iso_to_epoch() {
    local iso_str="$1"
    local epoch
    epoch=$(date -d "${iso_str}" +%s 2>/dev/null)
    [ -n "$epoch" ] && { echo "$epoch"; return 0; }
    return 1
}

format_until() {
    local target_epoch="$1"
    local now=$(date +%s)
    local delta=$(( target_epoch - now ))
    [ "$delta" -lt 0 ] && delta=0
    local days=$(( delta / 86400 ))
    local hours=$(( (delta % 86400) / 3600 ))
    local mins=$(( (delta % 3600) / 60 ))
    if [ "$days" -gt 0 ]; then
        if [ "$hours" -gt 0 ]; then
            printf "%dd%dh" "$days" "$hours"
        else
            printf "%dd" "$days"
        fi
    elif [ "$hours" -gt 0 ]; then
        printf "%dh" "$hours"
    else
        printf "%dm" "$mins"
    fi
}

# "Opus 4.7 (1M context)" -> "O4.7 1M"
# "Sonnet 4.6"            -> "S4.6"
abbreviate_model() {
    local name="$1"
    local family rest letter out size
    if [[ "$name" =~ ^([A-Za-z]+)[[:space:]]+([0-9.]+) ]]; then
        family="${BASH_REMATCH[1]}"
        rest="${BASH_REMATCH[2]}"
        case "$family" in
            Opus|opus)     letter="O" ;;
            Sonnet|sonnet) letter="S" ;;
            Haiku|haiku)   letter="H" ;;
            *)             letter="${family:0:1}" ;;
        esac
        out="${letter}${rest}"
        if [[ "$name" =~ \(([0-9]+[KkMm])[[:space:]]*context\) ]]; then
            size="${BASH_REMATCH[1]}"
            out="${out} ${size}"
        fi
        printf "%s" "$out"
    else
        printf "%s" "$name"
    fi
}

# ── Extract JSON data ───────────────────────────────────
model_name=$(echo "$input" | jq -r '.model.display_name // "Claude"')
model_short=$(abbreviate_model "$model_name")

size=$(echo "$input" | jq -r '.context_window.context_window_size // 200000')
[ "$size" -eq 0 ] 2>/dev/null && size=200000

input_tokens=$(echo "$input" | jq -r '.context_window.current_usage.input_tokens // 0')
cache_create=$(echo "$input" | jq -r '.context_window.current_usage.cache_creation_input_tokens // 0')
cache_read=$(echo "$input" | jq -r '.context_window.current_usage.cache_read_input_tokens // 0')
current=$(( input_tokens + cache_create + cache_read ))

if [ "$size" -gt 0 ]; then
    pct_used=$(( current * 100 / size ))
else
    pct_used=0
fi

thinking_on=false
settings_path="$HOME/.claude/settings.json"
if [ -f "$settings_path" ]; then
    thinking_val=$(jq -r '.alwaysThinkingEnabled // false' "$settings_path" 2>/dev/null)
    [ "$thinking_val" = "true" ] && thinking_on=true
fi

cwd=$(echo "$input" | jq -r '.cwd // ""')
[ -z "$cwd" ] || [ "$cwd" = "null" ] && cwd=$(pwd)
dirname=$(basename "$cwd")

git_branch=""
git_dirty=""
if git -C "$cwd" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    git_branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null)
    if [ -n "$(git --no-optional-locks -C "$cwd" status --porcelain 2>/dev/null)" ]; then
        git_dirty="*"
    fi
fi

# ── OAuth token resolution ──────────────────────────────
get_oauth_token() {
    local token=""

    if [ -n "$CLAUDE_CODE_OAUTH_TOKEN" ]; then
        echo "$CLAUDE_CODE_OAUTH_TOKEN"
        return 0
    fi

    if command -v security >/dev/null 2>&1; then
        local blob
        blob=$(security find-generic-password -s "Claude Code-credentials" -w 2>/dev/null)
        if [ -n "$blob" ]; then
            token=$(echo "$blob" | jq -r '.claudeAiOauth.accessToken // empty' 2>/dev/null)
            if [ -n "$token" ] && [ "$token" != "null" ]; then
                echo "$token"
                return 0
            fi
        fi
    fi

    local creds_file="${HOME}/.claude/.credentials.json"
    if [ -f "$creds_file" ]; then
        token=$(jq -r '.claudeAiOauth.accessToken // empty' "$creds_file" 2>/dev/null)
        if [ -n "$token" ] && [ "$token" != "null" ]; then
            echo "$token"
            return 0
        fi
    fi

    if command -v secret-tool >/dev/null 2>&1; then
        local blob
        blob=$(timeout 2 secret-tool lookup service "Claude Code-credentials" 2>/dev/null)
        if [ -n "$blob" ]; then
            token=$(echo "$blob" | jq -r '.claudeAiOauth.accessToken // empty' 2>/dev/null)
            if [ -n "$token" ] && [ "$token" != "null" ]; then
                echo "$token"
                return 0
            fi
        fi
    fi

    echo ""
}

# ── Fetch usage data (cached) ──────────────────────────
cache_file="/tmp/claude/statusline-usage-cache.json"
cache_max_age=60
mkdir -p /tmp/claude

needs_refresh=true
usage_data=""

if [ -f "$cache_file" ]; then
    cache_mtime=$(stat -c %Y "$cache_file" 2>/dev/null || stat -f %m "$cache_file" 2>/dev/null)
    now=$(date +%s)
    cache_age=$(( now - cache_mtime ))
    if [ "$cache_age" -lt "$cache_max_age" ]; then
        needs_refresh=false
        usage_data=$(cat "$cache_file" 2>/dev/null)
    fi
fi

if $needs_refresh; then
    token=$(get_oauth_token)
    if [ -n "$token" ] && [ "$token" != "null" ]; then
        response=$(curl -s --max-time 5 \
            -H "Accept: application/json" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer $token" \
            -H "anthropic-beta: oauth-2025-04-20" \
            -H "User-Agent: claude-code/2.1.34" \
            "https://api.anthropic.com/api/oauth/usage" 2>/dev/null)
        if [ -n "$response" ] && echo "$response" | jq -e '.five_hour' >/dev/null 2>&1; then
            usage_data="$response"
            echo "$response" > "$cache_file"
        fi
    fi
    if [ -z "$usage_data" ] && [ -f "$cache_file" ]; then
        usage_data=$(cat "$cache_file" 2>/dev/null)
    fi
fi

five_hour_pct=""
seven_day_pct=""
seven_day_until=""
if [ -n "$usage_data" ] && echo "$usage_data" | jq -e . >/dev/null 2>&1; then
    five_hour_pct=$(echo "$usage_data" | jq -r '.five_hour.utilization // 0' | awk '{printf "%.0f", $1}')
    seven_day_pct=$(echo "$usage_data" | jq -r '.seven_day.utilization // 0' | awk '{printf "%.0f", $1}')
    seven_day_reset_iso=$(echo "$usage_data" | jq -r '.seven_day.resets_at // empty')
    if [ -n "$seven_day_reset_iso" ] && [ "$seven_day_reset_iso" != "null" ]; then
        reset_epoch=$(iso_to_epoch "$seven_day_reset_iso")
        [ -n "$reset_epoch" ] && seven_day_until=$(format_until "$reset_epoch")
    fi
fi

# ── Build single line ───────────────────────────────────
ctx_color=$(color_for_pct "$pct_used")

line="${blue}${model_short}${reset}"
line+="${sep}${ctx_color}${pct_used}%${reset}"
line+="${sep}${cyan}${dirname}${reset}"
if [ -n "$git_branch" ]; then
    line+=" ${green}(${git_branch}${red}${git_dirty}${green})${reset}"
fi

if [ -n "$five_hour_pct" ]; then
    fh_color=$(color_for_pct "$five_hour_pct")
    fh_remaining=$(( 100 - five_hour_pct ))
    line+="${sep}${dim}5h${reset} ${fh_color}${fh_remaining}%${reset}"
fi
if [ -n "$seven_day_pct" ]; then
    wk_color=$(color_for_pct "$seven_day_pct")
    wk_remaining=$(( 100 - seven_day_pct ))
    line+="${sep}${dim}wk${reset} ${wk_color}${wk_remaining}%${reset}"
    [ -n "$seven_day_until" ] && line+=" ${dim}${seven_day_until}${reset}"
fi

if $thinking_on; then
    line+="${sep}${magenta}thinking${reset}"
fi

printf "%b" "$line"
exit 0
