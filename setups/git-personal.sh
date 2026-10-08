#!/usr/bin/env bash
#
# Personal repos commit under the personal email; everything else keeps
# DOTFILES_GIT_USER_EMAIL (the work address). A conditional include in the
# global git config points repos under DOTFILES_GIT_PERSONAL_DIR at
# ~/.config/git/personal.gitconfig. Both addresses belong to the same GitHub
# account, so commits are credited to it either way.
#
# Runs on Omarchy too: `git config --global` writes to whichever global file
# exists, and the include is appended after the [user] section so it wins.
# Safe to re-run.

source "${HOME}"/.dotfilesrc
source "${DOTFILES_DIR}"/lib/dotfiles.sh

personal_email="${DOTFILES_GIT_PERSONAL_EMAIL:-sclarke77@gmail.com}"
personal_dir="${DOTFILES_GIT_PERSONAL_DIR:-~/src/onethreefive/}"
personal_config="${HOME}/.config/git/personal.gitconfig"

mkdir -p "$(dirname "$personal_config")"
git config --file "$personal_config" user.email "$personal_email"
git config --global "includeIf.gitdir:${personal_dir}.path" "~/.config/git/personal.gitconfig"
