#!/usr/bin/env zsh
cd ~/src/vim/bundles
for directory (*) cd $directory && git pull && cd ..
echo 'done.'