#!/bin/sh
git config --global user.name "Steve Clarke"
git config --global user.email "doctorbh@ninjanizr.com"

git config --global github.user doctorbh
git config --global github.token $GITHUB_TOKEN

git config --global alias.st status
git config --global alias.co checkout
git config --global alias.ci commit

git config -l
