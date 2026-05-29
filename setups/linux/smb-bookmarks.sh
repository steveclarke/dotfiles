#!/usr/bin/env bash
#
# Add SMB shares from storage.home (Unraid server) to the GTK bookmarks file
# so they appear in the Nautilus sidebar. Idempotent: missing entries are
# appended, existing entries are left alone. No-op if Nautilus isn't installed.
#

source "${HOME}"/.dotfilesrc
source "${DOTFILES_DIR}"/lib/dotfiles.sh

if ! is_installed nautilus; then
  return 0 2>/dev/null || exit 0
fi

bookmarks_file="${HOME}/.config/gtk-3.0/bookmarks"
mkdir -p "$(dirname "${bookmarks_file}")"
touch "${bookmarks_file}"

shares=(
  storage
  Music
  Pictures
  Video
  Books
  sevenview
  backups
  isos
)

added=0
for share in "${shares[@]}"; do
  line="smb://storage.home/${share} ${share} (storage.home)"
  if ! grep -Fxq "${line}" "${bookmarks_file}"; then
    echo "${line}" >> "${bookmarks_file}"
    added=$((added + 1))
  fi
done

if (( added > 0 )); then
  banner "Added ${added} storage.home SMB bookmark(s) to Nautilus"
fi
