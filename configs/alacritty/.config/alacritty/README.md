# Alacritty

If you want to override any settings for a specific machine, create a file
called `local.yml`.

## Tips

### 'alacritty': unknown terminal type

If you get this error when trying to run something like `top` on a remote server
while using Alacritty terminal, run the following on the remote machine:

```bash
curl -sSL https://raw.githubusercontent.com/alacritty/alacritty/master/extra/alacritty.info | tic -x -
```

This will install the alacritty terminfo on the machine. Alternately you can
run ssh with a terminfo that is recognized with:

```bash
alias ssh="TERM=xterm-256color $(which ssh)"
```
