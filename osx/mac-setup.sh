#!/bin/bash

# Portions borrowed from:
# https://github.com/geetarista/mac-setup/blob/master/mac-setup.sh

# Configure default settings
curl https://raw.github.com/doctorbh/dotfiles/master/osx/defaults.sh | sh

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

# install Vim with python compiled in for some plugins to work
brew install mercurial
brew install https://raw.github.com/AndrewVos/homebrew-alt/master/duplicates/vim.rb

# Install Node / npm
brew install node
curl http://npmjs.org/install.sh | sh
# Node packages
npm -g install coffee-script
