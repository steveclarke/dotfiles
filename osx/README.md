## Setting up My Mac from Scratch

* Install and patch system

* Install [GCC](https://github.com/kennethreitz/osx-gcc-installer)

`curl https://raw.github.com/doctorbh/dotfiles/master/osx/bootstrap/download-core.sh | sh`

* Setup ENV vars we'll need for SSH keys and GitHub config

`export SSH_KEY_HOST=`

`export GITHUB_TOKEN=`

* Run mac-bootstrap.sh

`curl https://raw.github.com/doctorbh/dotfiles/master/osx/bootstrap/mac-bootstrap.sh | sh`

* Download other standard stuff after `wget` is installed:

`curl https://raw.github.com/doctorbh/dotfiles/master/osx/download-apps.sh | sh`

* Configure Dotfiles

* Install dev tools, etc.
