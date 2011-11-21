## Setting up My Mac from Scratch

* Install and patch system

* Install [GCC](https://github.com/kennethreitz/osx-gcc-installer)

`curl https://raw.github.com/doctorbh/dotfiles/master/osx/download-core.sh | sh`

* Setup SSH keys

`export SSH_KEY_HOST=[hostname to retrive ssh key(s) from]`

`curl https://raw.github.com/doctorbh/dotfiles/master/osx/ssh-setup.sh | sh`

* Setup Github

`export GITHUB_TOKEN=[my token]`

`curl https://raw.github.com/doctorbh/dotfiles/master/git/setup.sh | sh`

* Run mac-setup.sh

`curl https://raw.github.com/doctorbh/dotfiles/master/osx/mac-setup.sh | sh`

* Download other standard stuff after `wget` is installed:

`curl https://raw.github.com/doctorbh/dotfiles/master/osx/download-other.sh | sh`
