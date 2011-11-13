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
if Dir.exists?(DOTFILES_DIR)
  puts "--> OK. Looks like we have a ~/src/dotfiles directory... moving right along."
else
  puts "I'm expecting stuff to be setup inside ~/src/dotfiles."
  puts "Just what do you think you're doing, Dave....er I mean Steve."
  exit
end

## Setup bash
BASH_PROFILE_DOTFILE = File.join(DOTFILES_DIR, 'bash/bash_profile.symlink')
BASH_PROFILE_SYMLINK = File.join(HOME_DIR,     '.bash_profile')
if File.exists?(BASH_PROFILE_SYMLINK)
  puts "### Skipping #{BASH_PROFILE_SYMLINK}. Already exists."
else
  puts "+++ Creating #{BASH_PROFILE_SYMLINK}"
  ln_s(BASH_PROFILE_DOTFILE, BASH_PROFILE_SYMLINK)
end

## Setup personal bin dir
BIN_DIR_DOTFILE = File.join(DOTFILES_DIR, 'bin.symlink')
if Dir.exists?(BIN_DIR)
  puts "### Skipping #{BIN_DIR}. Already exists."
else
  puts "+++ Creating #{BIN_DIR}"
  ln_s(BIN_DIR_DOTFILE, BIN_DIR)
end

## Setup Vim
# symlink .vim dir
VIM_DIR_DOTFILE = File.join(DOTFILES_DIR, 'vim/vim.symlink')
if Dir.exists?(VIM_DIR)
  puts "### Skipping #{VIM_DIR}. Already exists."
else
  puts "+++ Creating #{VIM_DIR}"
  ln_s(VIM_DIR_DOTFILE, VIM_DIR)
end

# configure .vimrc and .gvimrc
VIMRC          = File.join(HOME_DIR, '.vimrc')
VIMRC_DOTFILE  = File.join(DOTFILES_DIR, 'vim/vimrc.symlink')
GVIMRC         = File.join(HOME_DIR, '.gvimrc')
GVIMRC_DOTFILE = File.join(DOTFILES_DIR, 'vim/gvimrc.symlink')

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
if Dir.exists?(VIM_BUNDLES_DIR)
  puts "### Skipping #{VIM_BUNDLES_DIR}. Already exists."
else
  puts "+++ Creating #{VIM_BUNDLES_DIR}/bundles"
  mkdir_p(File.join(VIM_BUNDLES_DIR, 'bundles'))    # also create bundles while we're at it
  # symlink install_bundles.rb inside of ~/vim
  install_bundles_scrpt   = File.join(DOTFILES_DIR, 'vim/install_bundles.rb')
  install_bundles_symlink = File.join(VIM_BUNDLES_DIR, 'install_bundles.rb')
  puts "+++ Creating symlink to install_bundles.rb in ~/src/vim"
  ln_s(install_bundles_scrpt, install_bundles_symlink)
end

puts "--> Done. Now run install_bundles.rb."
