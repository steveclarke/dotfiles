#!/bin/sh
echo "############################################################"
echo "please make sure you set your Github token in \$GITHUB_TOKEN"
echo "############################################################"

git config --global user.name "Steve Clarke"
git config --global user.email "doctorbh@ninjanizr.com"

git config --global github.user doctorbh
git config --global github.token $GITHUB_TOKEN

git config -l