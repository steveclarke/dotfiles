#!/bin/bash

# Portions borrowed from:
# https://github.com/geetarista/mac-setup/blob/master/mac-setup.sh

# Configure default settings
curl https://raw.github.com/doctorbh/dotfiles/master/osx/defaults.sh | sh

# Configure SSH keys
curl https://raw.github.com/doctorbh/dotfiles/master/osx/ssh-setup.sh | sh

# Configure GitHub
curl https://raw.github.com/doctorbh/dotfiles/master/git/setup.sh | sh

# Install Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.github.com/gist/323731)"

brew update

# Install packages
brew install ack
brew install bcrypt
brew install ctags
brew install curl
brew install git
brew install markdown
brew install mysql
brew install postgresql
brew install node
brew install wget

# Install and configure Rbenv

# Install npm
curl http://npmjs.org/install.sh | sh

# Node packages
npm -g install coffee-script

mkdir ~/src
cd ~/src

# Dotfiles

git clone git@github.com:doctorbh/dotfiles.git
cd dotfiles
rake install
