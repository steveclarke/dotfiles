source "${HOME}"/.dotfilesrc
source "${DOTFILES_DIR}"/lib/dotfiles.sh

# Make `ssh host <command>` see mise's tools first and a UTF-8 locale. Arch's
# bash reads no startup file for such a command (no ~/.bashrc, no login), so its
# environment comes only from /etc/security/pam_env.conf. Omarchy writes PATH
# there with the mise shims AFTER /usr/bin, so system Ruby 3.4 shadows mise's
# Ruby and `bundler/setup` fails; and the C locale makes Ruby read UTF-8 files as
# US-ASCII. Shims go first and LANG is copied from /etc/locale.conf, beside the
# TMPDIR line from tmpdir.sh. Interactive shells are unchanged: their rc files
# already put mise first.

conf=/etc/security/pam_env.conf
shims='@{HOME}/.local/share/mise/shims'
[[ -f $conf ]] || return 0 2>/dev/null || exit 0

if grep -qE "^PATH[[:space:]]+DEFAULT=${shims}:" "$conf" && grep -qE '^LANG[[:space:]]' "$conf"; then
  return 0 2>/dev/null || exit 0
fi

config_banner "mise-first PATH and UTF-8 locale for ssh commands"
lang=$(sed -n 's/^LANG=//p' /etc/locale.conf 2>/dev/null)
sudo cp "$conf" "${conf}.bak-ssh-env"
if ! grep -qE "^PATH[[:space:]]+DEFAULT=${shims}:" "$conf"; then
  sudo sed -i -E "s#^PATH[[:space:]]+DEFAULT=.*#PATH            DEFAULT=${shims}:/usr/local/sbin:/usr/local/bin:/usr/bin:@{HOME}/.local/bin#" "$conf"
fi
if ! grep -qE '^LANG[[:space:]]' "$conf"; then
  echo "LANG            DEFAULT=${lang:-C.UTF-8}" | sudo tee -a "$conf" >/dev/null
fi
