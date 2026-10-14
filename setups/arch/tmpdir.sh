source "${HOME}"/.dotfilesrc
source "${DOTFILES_DIR}"/lib/dotfiles.sh

# Point TMPDIR at ~/.cache/tmp on the disk for every session, including commands
# run over SSH. /tmp is a RAM-backed tmpfs with a per-user quota; agent test runs
# and `unio ci` (which builds a whole checkout under TMPDIR) fill it and then fail
# with "Disk quota exceeded". Shell startup files cannot fix this for SSH: Arch's
# bash reads no startup file for `ssh host <command>`, which gets its PATH from
# /etc/security/pam_env.conf. TMPDIR goes there beside it. The hugo migration
# 202610051130-tmpdir-on-disk creates the directory and its 2-day cleanup.

conf=/etc/security/pam_env.conf
[[ -f $conf ]] || return 0 2>/dev/null || exit 0
grep -q '^TMPDIR' "$conf" && { return 0 2>/dev/null || exit 0; }

config_banner "TMPDIR on disk for all sessions"
mkdir -p "${HOME}/.cache/tmp"
chmod 700 "${HOME}/.cache/tmp"
echo 'TMPDIR          DEFAULT=@{HOME}/.cache/tmp' | sudo tee -a "$conf" >/dev/null
