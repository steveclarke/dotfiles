#!/bin/bash
if [ ! -d ~/.ssh ]
then
  echo "creating ~/.ssh..."
  mkdir ~/.ssh
fi

scp $USER@$SSH_KEY_HOST:.ssh/id_rsa* ~/.ssh
scp $USER@$SSH_KEY_HOST:.ssh/config ~/.ssh
