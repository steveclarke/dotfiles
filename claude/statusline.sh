#!/bin/bash
# Claude Code status line: folder, git branch and state, model, context bar.
input=$(cat)
dir=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
model=$(echo "$input" | jq -r '.model.display_name // empty')
effort=$(echo "$input" | jq -r '.effort.level // empty')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
week=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

reset=$'\e[0m'; dim=$'\e[2m'; bold=$'\e[1m'
blue=$'\e[34m'; magenta=$'\e[35m'; green=$'\e[32m'; yellow=$'\e[33m'; red=$'\e[31m'; cyan=$'\e[36m'
sep="${dim} │ ${reset}"

out=""
if [ -n "$dir" ]; then
  short="${dir/#$HOME/\~}"
  out="${bold}${blue} ${short}${reset}"

  branch=$(git -C "$dir" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null \
    || git -C "$dir" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    state=""
    if [ -n "$(git -C "$dir" --no-optional-locks status --porcelain 2>/dev/null | head -1)" ]; then
      state=" ${yellow}●${reset}"
    fi
    counts=$(git -C "$dir" --no-optional-locks rev-list --left-right --count '@{upstream}...HEAD' 2>/dev/null)
    if [ -n "$counts" ]; then
      behind=${counts%%[[:space:]]*}; ahead=${counts##*[[:space:]]}
      [ "$ahead" -gt 0 ] 2>/dev/null && state="$state ${green}↑${ahead}${reset}"
      [ "$behind" -gt 0 ] 2>/dev/null && state="$state ${red}↓${behind}${reset}"
    fi
    out="${out}${sep}${magenta} ${branch}${reset}${state}"
  fi
fi

[ -n "$model" ] && out="${out}${sep}${cyan}󰚩 ${model}${reset}"
[ -n "$effort" ] && out="${out} ${dim}·${reset} ${cyan}${effort}${reset}"

if [ -n "$used" ]; then
  pct=$(printf '%.0f' "$used")
  if [ "$pct" -ge 80 ]; then colour=$red; elif [ "$pct" -ge 50 ]; then colour=$yellow; else colour=$green; fi
  filled=$(( (pct + 5) / 10 )); [ "$filled" -gt 10 ] && filled=10
  bar=""
  for ((i = 0; i < 10; i++)); do
    if [ "$i" -lt "$filled" ]; then bar="${bar}━"; else bar="${bar}${dim}─${reset}${colour}"; fi
  done
  out="${out}${sep}${colour}${bar} ${pct}%${reset}"
fi

if [ -n "$week" ]; then
  left=$(( 100 - $(printf '%.0f' "$week") ))
  if [ "$left" -le 20 ]; then colour=$red; elif [ "$left" -le 50 ]; then colour=$yellow; else colour=$green; fi
  out="${out}${sep}${colour}󰃭 week ${left}% left${reset}"
fi

printf '%s' "$out"
