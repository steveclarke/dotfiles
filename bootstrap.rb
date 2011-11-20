#!/usr/bin/env ruby
require 'fileutils'

#include FileUtils::DryRun
include FileUtils

HOME_DIR     = File.expand_path('~')
SRC_DIR      = File.join(HOME_DIR, 'src')
DOTFILES_DIR = File.join(SRC_DIR, 'dotfiles')
BIN_DIR      = File.join(HOME_DIR, 'bin')
VIM_DIR      = File.join(HOME_DIR, '.vim')

# -------------------------------------------------------------------------
#                              Sanity Check                               |
# -------------------------------------------------------------------------
# complain and exit if ~/src/dotfiles (and by extension ~/src) doesn't exist
if File.directory?(DOTFILES_DIR)
  puts "--> Looks like we have a ~/src/dotfiles directory... moving right along...\n\n"
else
  puts "I'm expecting stuff to be setup inside ~/src/dotfiles."
  puts "Just what do you think you're doing, Dave....er I mean Steve."
  exit
end

def create_symlink(source, target)
  if File.directory?(target) || File.exists?(target)
    puts "### Skipping #{target}. Already exists."
  else
    puts "+++ Creating #{target}"
    ln_s(source, target)
  end
end

# -------------------------------------------------------------------------
#                                   Vim                                   |
# -------------------------------------------------------------------------
puts "--- VIM"
# symlink .vim dir
VIM_DIR_DOTFILE = File.join(DOTFILES_DIR, 'vim/vim')
create_symlink(VIM_DIR_DOTFILE, VIM_DIR)

# configure .vimrc and .gvimrc
VIMRC          = File.join(HOME_DIR, '.vimrc')
VIMRC_DOTFILE  = File.join(DOTFILES_DIR, 'vim/vimrc')
GVIMRC         = File.join(HOME_DIR, '.gvimrc')
GVIMRC_DOTFILE = File.join(DOTFILES_DIR, 'vim/gvimrc')
create_symlink(VIMRC_DOTFILE, VIMRC)
create_symlink(GVIMRC_DOTFILE, GVIMRC)

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

# -------------------------------------------------------------------------
#                                  Done                                   |
# -------------------------------------------------------------------------
puts ""
puts "--> Done. Now run vim/install_bundles.rb to finish Vim config.\n\n"
puts "--> Make ZSH your shell with: chsh -s `which zsh`\n\n"
puts "--> Add GITHUB_TOKEN to your .bash_profile_local and/or .zshrc_local"
puts "    then run git/setup.sh"

