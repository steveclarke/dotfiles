#!/usr/bin/env bash
installing_banner "virtualbox"
omarchy-pkg-add virtualbox
sudo usermod -aG vboxusers "$USER"
