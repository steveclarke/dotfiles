#!/bin/bash

if [[ "$OSTYPE" == "darwin"* ]]; then
  osascript -e 'display notification "Claude Code is waiting for input" with title "Claude Code"'
elif command -v notify-send &>/dev/null; then
  notify-send "Claude Code" "Claude Code is waiting for input"
fi

exit 0
