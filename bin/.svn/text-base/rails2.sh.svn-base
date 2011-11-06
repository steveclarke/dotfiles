#!/bin/sh
#
# Distributed in the Public Domain by Francois Beausoleil.
# This script might destroy twenty years worth of work, and I cannot be held
# responsible.  You are your own master.  Read this file in detail before
# you use it.
#
# NO IMPLIED WARRANTY.

# Usage:
# new-rails.sh PROJECT
#
# Creates a Subversion repository in REPOS_ROOT/PROJECT.  Creates a Rails
# application names PROJECT, and checks it in the newly created repository.
#
# REPOS_ROOT defaults to ~/svn.

PROJECT=$1
if [ -z $PROJECT ]; then
  echo "Usage: $0 PROJECT"
  exit 1
fi

if [ -z $REPOS_ROOT ]; then
  REPOS_ROOT=$HOME/svn
fi

if [ -d $REPOS_ROOT/$PROJECT ]; then
  echo "The repository already exists - this script will not overwrite the repository at '$REPOS_ROOT/$PROJECT'"
  exit 1
fi

if [ -d $PROJECT ]; then
  echo "The project already exists - this script will not overwrite the directory at '$PROJECT'"
  exit 1
fi

echo "Creating project '$PROJECT', in new repository '$REPOS_ROOT'"

mkdir $REPOS_ROOT 2>/dev/null
svnadmin create --fs-type=fsfs $REPOS_ROOT/$PROJECT
REPOS=file://$REPOS_ROOT/$PROJECT

svn mkdir --message="Initial project layout" $REPOS/trunk $REPOS/tags $REPOS/branches

rails $PROJECT
cd $PROJECT
svn checkout $REPOS/trunk .
svn add --force .
svn mkdir tmp db/migrate
svn revert log/*
svn propset svn:ignore "*.log" log
svn revert config/database.yml
mv config/database.yml config/database.yml.sample
svn add config/database.yml.sample
svn propset svn:ignore "database.yml" config
cp config/database.yml.sample config/database.yml
svn propset svn:ignore "schema.rb" db
svn propset svn:ignore "*" tmp
svn propset svn:ignore "*doc" doc
svn propset svn:executable "*" `find script -type f | grep -v '.svn'` public/dispatch.*
svn revert public/index.html
svn commit --message="New Rails project"
svn propset svn:externals "rails http://dev.rubyonrails.org/svn/rails/trunk/" vendor
svn update vendor
yes | rails . >/dev/null
rm public/index.html
svn commit --message="Living on the Edge - set svn:externals on vendor/ for Rails"
