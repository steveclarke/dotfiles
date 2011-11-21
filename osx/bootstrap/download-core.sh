#!/bin/sh

# These are ones I want downloaded before I get Brew installed and
# have access to wget (where I can do resumes)

cd ~/Downloads

# Google Chrome
echo "Downloading Google Chrome..."
curl -O https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg

# GCC
curl -O https://github.com/downloads/kennethreitz/osx-gcc-installer/GCC-10.7-v2.pkg

echo "To download the rest, install wget and run:"
echo "curl https://raw.github.com/doctorbh/dotfiles/master/osx/download-other.sh | sh"
