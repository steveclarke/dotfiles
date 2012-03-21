#!/usr/bin/zsh

echo "What is the name of the new PHP app? (e.g. my_app, no spaces allowed)"
read inputline
app=$app

mkdir $app
cd $app

git init # Make it a git repo...

mkdir errorpage
mkdir resources
mkdir tests
mkdir public
touch .htaccess
touch README.md
touch LICENSE.md
# Create all files and directorys

cd errorpage
touch 404.html

cd ..

cd public
touch index.php
mkdir css
mkdir js

cd ..

cd .. # Brings you to the directory you created it in.
