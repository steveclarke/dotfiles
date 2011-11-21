#!/bin/bash
if [ ! -d ~/.ssh ]
then
  echo "creating ~/.ssh..."
  mkdir ~/.ssh
fi

echo "Enter the server to copy your SSH keys from"
read ssh_server
scp $USER@$ssh_server:.ssh/id_rsa* .
