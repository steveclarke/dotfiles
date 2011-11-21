## Setting up My Mac from Scratch

* Patch system
* Install [GCC](https://github.com/kennethreitz/osx-gcc-installer)
* Setup SSH keys

`curl https://raw.github.com/doctorbh/dotfiles/master/osx/ssh-setup.sh | sh`

* Setup Github

`export GITHUB_TOKEN=[my token]`

`curl https://raw.github.com/doctorbh/dotfiles/master/git/setup.sh | sh`

* Run mac-setup.sh

`curl https://raw.github.com/doctorbh/dotfiles/master/osx/mac-setup.sh | sh`

* Download other standard stuff while this other stuff is happening

`curl
https://raw.github.com/doctorbh/dotfiles/master/osx/download-core.sh |
sh`

