#!/usr/bin/env bash
installing_banner "google-chrome"

if is_installed google-chrome-stable; then
  skipping "google-chrome"
else
  omarchy install browser chrome
fi

# Chrome shows "Restore pages? / Chrome didn't shut down correctly" on Linux
# because session managers SIGKILL it before it can mark the exit clean. Chrome
# has its own switch for this, which replaces the wrapper this script used to
# write. Omarchy's browser installer does `cp -f` over chrome-flags.conf, so the
# flag is appended after it runs rather than kept in the file.
flags="${HOME}/.config/chrome-flags.conf"
if [[ -f "$flags" ]] && ! grep -qxF -- "--hide-crash-restore-bubble" "$flags"; then
  echo "--hide-crash-restore-bubble" >> "$flags"
  echo "  added --hide-crash-restore-bubble to chrome-flags.conf"
fi
