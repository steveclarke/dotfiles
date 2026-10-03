source "${HOME}"/.dotfilesrc
source "${DOTFILES_DIR}"/lib/dotfiles.sh

# Trust the home LAN in UFW, the same rule uber-om carries. Omarchy's sshd
# setup adds `ufw limit 22/tcp`, which refuses an address after 6 connections
# in 30 seconds. Agents driven over SSH from another machine (Herdr from the
# MacBook Air) open more than that and get blocked. The limit rule sits ahead
# of any later allow, so it is removed rather than left in front of the LAN
# rule. Everything outside the LAN stays denied by Omarchy's default.

command -v ufw >/dev/null || return 0 2>/dev/null || exit 0

config_banner "Firewall (trust home LAN)"
sudo ufw allow from 192.168.77.0/24 comment "trust home lan" >/dev/null
sudo ufw --force delete limit 22/tcp >/dev/null 2>&1 || true
sudo ufw reload >/dev/null
