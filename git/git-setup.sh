#!/bin/sh

# User Info
git config --global user.name "Steve Clarke"
git config --global user.email "doctorbh@ninjanizr.com"

# Github
git config --global github.user doctorbh
git config --global github.token $GITHUB_TOKEN

# Aliases
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.ci commit
git config --global alias.br branch
git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
git config --global alias.head log
git config --global alias.ls ls-files

# Colors
git config --global color.ui auto
git config --global color.branch.current "yellow reverse"
git config --global color.branch.local yellow
git config --global color.branch.remote green
git config --global color.diff.meta "yellow bold"
git config --global color.diff.frag "magenta bold"
git config --global color.diff.old "red bold"
git config --global color.diff.new "green bold"
git config --global color.status.added yellow
git config --global color.status.changed green
git config --global color.status.untracked cyan

# Misc
git config --global core.excludesfile ~/.gitignore

git config -l
