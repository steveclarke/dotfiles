#!/usr/bin/env ruby
require 'fileutils'

#include FileUtils::DryRun
include FileUtils

HOME_DIR     = File.expand_path('~')
SRC_DIR      = File.join(HOME_DIR, 'src')
DOTFILES_DIR = File.join(SRC_DIR, 'dotfiles')
BIN_DIR      = File.join(HOME_DIR, 'bin')
VIM_DIR      = File.join(HOME_DIR, '.vim')

## Sanity check
# complain and exit if ~/src/dotfiles (and by extension ~/src) doesn't exist
if File.directory?(DOTFILES_DIR)
  puts "--> Looks like we have a ~/src/dotfiles directory... moving right along...\n\n"
else
  puts "I'm expecting stuff to be setup inside ~/src/dotfiles."
  puts "Just what do you think you're doing, Dave....er I mean Steve."
  exit
end

## Setup .dotfiles
puts "--- .DOTFILES"
DOTFILES_DIR_SYMLINK = File.join(HOME_DIR, '.dotfiles')
if File.directory?(DOTFILES_DIR_SYMLINK)
  puts "### Skipping #{DOTFILES_DIR_SYMLINK}. Already exists."
else
  puts "+++ Creating #{DOTFILES_DIR_SYMLINK}"
  ln_s(DOTFILES_DIR, DOTFILES_DIR_SYMLINK)
end

## Setup bash
puts "--- BASH"
BASH_PROFILE_DOTFILE = File.join(DOTFILES_DIR, 'bash/bash_profile')
BASH_PROFILE_SYMLINK = File.join(HOME_DIR,     '.bash_profile')
if File.exists?(BASH_PROFILE_SYMLINK)
  puts "### Skipping #{BASH_PROFILE_SYMLINK}. Already exists."
else
  puts "+++ Creating #{BASH_PROFILE_SYMLINK}"
  ln_s(BASH_PROFILE_DOTFILE, BASH_PROFILE_SYMLINK)
end

## Setup ZSH
puts "--- ZSH"
ZSHRC_DOTFILE = File.join(DOTFILES_DIR, 'zsh/zshrc')
ZSHRC_SYMLINK = File.join(HOME_DIR,     '.zshrc')
if File.exists?(ZSHRC_SYMLINK)
  puts "### Skipping #{ZSHRC_SYMLINK}. Already exists."
else
  puts "+++ Creating #{ZSHRC_SYMLINK}"
  ln_s(ZSHRC_DOTFILE, ZSHRC_SYMLINK)
end

## Setup personal bin dir
puts "--- PERSONAL BIN DIR"
BIN_DIR_DOTFILE = File.join(DOTFILES_DIR, 'bin')
if File.directory?(BIN_DIR)
  puts "### Skipping #{BIN_DIR}. Already exists."
else
  puts "+++ Creating #{BIN_DIR}"
  ln_s(BIN_DIR_DOTFILE, BIN_DIR)
end

## Setup Ruby stuff
puts "--- RUBY"
GEMRC         = File.join(HOME_DIR, '.gemrc')
GEMRC_DOTFILE = File.join(DOTFILES_DIR, 'ruby/gemrc')
if File.exists?(GEMRC)
  puts "### Skipping #{GEMRC}. Already exists."
else
  puts "+++ Creating #{GEMRC}"
  ln_s(GEMRC_DOTFILE, GEMRC)
end

## Setup Vim
puts "--- VIM"
# symlink .vim dir
VIM_DIR_DOTFILE = File.join(DOTFILES_DIR, 'vim/vim')
if File.directory?(VIM_DIR)
  puts "### Skipping #{VIM_DIR}. Already exists."
else
  puts "+++ Creating #{VIM_DIR}"
  ln_s(VIM_DIR_DOTFILE, VIM_DIR)
end

# configure .vimrc and .gvimrc
VIMRC          = File.join(HOME_DIR, '.vimrc')
VIMRC_DOTFILE  = File.join(DOTFILES_DIR, 'vim/vimrc')
GVIMRC         = File.join(HOME_DIR, '.gvimrc')
GVIMRC_DOTFILE = File.join(DOTFILES_DIR, 'vim/gvimrc')

if File.exists?(VIMRC)
  puts "### Skipping #{VIMRC}. Already exists."
else
  puts "+++ Creating #{VIMRC}"
  ln_s(VIMRC_DOTFILE, VIMRC)
end

if File.exists?(GVIMRC)
  puts "### Skipping #{GVIMRC}. Already exists."
else
  puts "+++ Creating #{GVIMRC}"
  ln_s(GVIMRC_DOTFILE, GVIMRC)
end

## Configure Pathogen with bundles
# create ~/src/vim if it doesn't exist
VIM_BUNDLES_DIR = File.join(SRC_DIR, 'vim')
if File.directory?(VIM_BUNDLES_DIR)
  puts "### Skipping #{VIM_BUNDLES_DIR}. Already exists."
else
  puts "+++ Creating #{VIM_BUNDLES_DIR}/bundles"
  mkdir_p(File.join(VIM_BUNDLES_DIR, 'bundles'))    # also create bundles while we're at it
  # symlink install_bundles.rb inside of ~/vim
  install_bundles_script  = File.join(DOTFILES_DIR,    'vim/install_bundles')
  update_bundles_script   = File.join(DOTFILES_DIR,    'vim/update_bundles')
  install_bundles_symlink = File.join(VIM_BUNDLES_DIR, 'install_bundles')
  update_bundles_symlink  = File.join(VIM_BUNDLES_DIR, 'update_bundles')
  puts "+++ Creating symlink to install_bundles and update_bundles in ~/src/vim"
  ln_s(install_bundles_script, install_bundles_symlink)
  ln_s(update_bundles_script,  update_bundles_symlink)
end

puts ""
puts "--> Done. Now run vim/install_bundles.rb to finish Vim config.\n\n"
puts "--> Make ZSH your shell with: chsh -s `which zsh`\n\n"
puts "--> Add GITHUB_TOKEN to your .bash_profile_local and/or .zshrc_local"
puts "    then run git/setup.sh"
