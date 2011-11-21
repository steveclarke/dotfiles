#!/bin/bash

# Portions borrowed from:
# https://github.com/geetarista/mac-setup/blob/master/mac-setup.sh

# TODO: Check for presence of SSH_KEY_HOST and GITHUB_TOKEN
# TODO: Check for presence of GCC

# Configure SSH keys
curl https://raw.github.com/doctorbh/dotfiles/master/osx/bootstrap/ssh-setup.sh | sh

# Configure GitHub
curl https://raw.github.com/doctorbh/dotfiles/master/git/setup.sh | sh

# Install Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.github.com/gist/323731)"
brew update

# Install core Brew packages
brew install wget

# Install and configure Rbenv
brew install rbenv
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile && . ~/.bash_profile
brew install ruby-build
rbenv install 1.9.2-p290
rbenv rehash
rbenv global 1.9.2-p290

# Install Dotfiles
mkdir ~/src
cd ~/src
git clone git@github.com:doctorbh/dotfiles.git

echo "Bootstrapped and ready to install your dotfiles."
echo "Restart your shell, then head on over to ~/src/dotfiles."

