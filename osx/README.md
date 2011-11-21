## Setting up My Mac from Scratch

* Install and patch system

* Install [GCC](https://github.com/kennethreitz/osx-gcc-installer)

`curl https://raw.github.com/doctorbh/dotfiles/master/osx/download-core.sh | sh`

* Setup SSH keys and GitHub token

`export SSH_KEY_HOST=`

`export GITHUB_TOKEN=`

* Run mac-setup.sh

`curl https://raw.github.com/doctorbh/dotfiles/master/osx/mac-setup.sh | sh`

* Download other standard stuff after `wget` is installed:

`curl https://raw.github.com/doctorbh/dotfiles/master/osx/download-other.sh | sh`
