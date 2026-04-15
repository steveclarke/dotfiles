source "${HOME}"/.dotfilesrc
source "${DOTFILES_DIR}"/lib/dotfiles.sh
detect_os

# Skip on Omarchy — it manages git config via ~/.config/git/config
if is_omarchy; then
  return 0 2>/dev/null || exit 0
fi

git config --global color.ui true
git config --global user.name "${DOTFILES_GIT_USER_NAME}"
git config --global user.email "${DOTFILES_GIT_USER_EMAIL}"
git config --global pull.rebase false
git config --global init.defaultBranch master

# Delta pager settings
git config --global core.pager delta
git config --global interactive.diffFilter 'delta --color-only'
git config --global delta.navigate true
git config --global merge.conflictStyle zdiff3
