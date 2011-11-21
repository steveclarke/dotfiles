#!/bin/sh

# Download core programs that I want on every Mac

cd ~/Downloads

# GCC
curl -O https://github.com/downloads/kennethreitz/osx-gcc-installer/GCC-10.7-v2.pkg

# Google Chrome
echo "Downloading Google Chrome..."
curl -O https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg

# f.lux
echo "Downloading f.lux..."
curl -O https://secure.herf.org/flux/Flux.zip
