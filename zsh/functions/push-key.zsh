# usage: push-key user@host
function push-key {
  ssh $1 "echo '`cat ~/.ssh/id_rsa.pub`' >> ~/.ssh/authorized_keys"
}

