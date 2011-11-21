## Setting up My Mac from Scratch

* Install and patch system

* Install [GCC](https://github.com/kennethreitz/osx-gcc-installer)

`curl https://raw.github.com/doctorbh/dotfiles/master/osx/bootstrap/download-core.sh | sh`

* Setup SSH keys and GitHub token

`export SSH_KEY_HOST=`

`export GITHUB_TOKEN=`

* Run mac-bootstrap.sh

`curl https://raw.github.com/doctorbh/dotfiles/master/osx/bootstrap/mac-bootstrap.sh | sh`

* Download other standard stuff after `wget` is installed:

`curl https://raw.github.com/doctorbh/dotfiles/master/osx/download-other.sh | sh`

* Configure Dotfiles

* Install Rails
