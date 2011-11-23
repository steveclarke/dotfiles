#!/bin/bash

# Portions borrowed from:
# https://github.com/geetarista/mac-setup/blob/master/mac-setup.sh

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

### Config Postgresql
# If this is your first install, create a database with:
initdb /usr/local/var/postgres
# If this is your first install, automatically load on login with:
mkdir -p ~/Library/LaunchAgents
cp /usr/local/Cellar/postgresql/9.1.1/org.postgresql.postgres.plist ~/Library/LaunchAgents/
launchctl load -w ~/Library/LaunchAgents/org.postgresql.postgres.plist

### Config MySql
# Set up databases to run AS YOUR USER ACCOUNT with:
unset TMPDIR
mysql_install_db --verbose --user=`whoami` --basedir="$(brew --prefix mysql)" --datadir=/usr/local/var/mysql --tmpdir=/tmp
# * if this is your first install:
mkdir -p ~/Library/LaunchAgents
cp /usr/local/Cellar/mysql/5.5.15/com.mysql.mysqld.plist ~/Library/LaunchAgents/
launchctl load -w ~/Library/LaunchAgents/com.mysql.mysqld.plist

