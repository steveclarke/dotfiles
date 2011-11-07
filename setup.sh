#!/bin/sh
# TODO: convert this to rake file

## Setup bash
ln -s ~/dotfiles/bash/bash_profile.symlink ~/.bash_profile

## Setup personal bin dir
if [ -d ~/bin ];
  then
    echo "Skipping ~/bin because directory already exists."
  else
    if [ -L ~/bin ];
      then
        echo "Skipping ~/bin because symlink already exists."
      else
      ln -s ~/dotfiles/bin.symlink ~/bin
      echo "Created symlink for ~/bin"
    fi
fi

## Setup Vim
ln -s ~/dotfiles/vim/vimrc.local.symlink ~/.vimrc.local
ln -s ~/dotfiles/vim/gvimrc.local.symlink ~/.gvimrc.local
ln -s ~/dotfiles/vim/janus.rake.symlink ~/.janus.rake
#ln -s ~/dotfiles/vim/vimrc.symlink ~/.vimrc
#if [ -d ~/.vim ];
  #then
    #echo "Skipping ~/.vim because directory already exists."
  #else
    #if [ -L ~/.vim ];
      #then
        #echo "Skipping ~/.vim because symlink already exists."
      #else
      #ln -s ~/dotfiles/vim/vim.symlink ~/.vim
      #echo "Created symlink for ~/.vim"
    #fi
#fi

