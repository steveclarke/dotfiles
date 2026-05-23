#!/usr/bin/env bash
# Install Google Chrome and apply the session-restore fix.
#
# On Linux, Chrome frequently shows "Restore pages? / Chrome didn't shut
# down correctly" on launch because session managers SIGKILL it before
# it can mark the exit as clean. The wrapper below rewrites the profile
# Preferences file to mark the prior exit as Normal right before Chrome
# starts, suppressing the prompt.

installing_banner "google-chrome"
omarchy-pkg-aur-add google-chrome

# --- Wrapper: ~/.local/bin shadows /usr/bin in PATH for shell launches.
mkdir -p "${HOME}/.local/bin"
cat > "${HOME}/.local/bin/google-chrome-stable" <<'WRAPPER'
#!/usr/bin/env bash
# Suppress Chrome's bogus "Restore pages?" prompt on Linux by marking
# the prior session as cleanly exited before launch. Managed by
# dotfiles/install/arch/apps/chrome.sh — edit there, not here.
config_dir="${HOME}/.config/google-chrome"
if [ -d "${config_dir}" ]; then
  while IFS= read -r pref; do
    sed -i \
      -e 's/"exit_type":"Crashed"/"exit_type":"Normal"/g' \
      -e 's/"exited_cleanly":false/"exited_cleanly":true/g' \
      "${pref}"
  done < <(find "${config_dir}" -maxdepth 2 -name Preferences -type f 2>/dev/null)
fi
exec /usr/bin/google-chrome-stable "$@"
WRAPPER
chmod +x "${HOME}/.local/bin/google-chrome-stable"

# --- .desktop override: walker/rofi launchers use absolute paths from
# the system entry, so PATH shadowing isn't enough. A user-level
# google-chrome.desktop always wins over /usr/share/applications/ per
# the XDG spec, so we copy it and repoint Exec= at the wrapper.
desktop_src="/usr/share/applications/google-chrome.desktop"
desktop_dst="${HOME}/.local/share/applications/google-chrome.desktop"
if [ -f "${desktop_src}" ]; then
  mkdir -p "${HOME}/.local/share/applications"
  sed 's|/usr/bin/google-chrome-stable|'"${HOME}"'/.local/bin/google-chrome-stable|g' \
    "${desktop_src}" > "${desktop_dst}"
  update-desktop-database "${HOME}/.local/share/applications" 2>/dev/null || true
fi
