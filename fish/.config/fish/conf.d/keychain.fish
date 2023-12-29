# FUNTOOO KEYCHAIN - frontend to ssh-agent
# https://www.funtoo.org/Funtoo:Keychain
if status is-interactive
    keychain --nogui $HOME/.ssh/sevenview2020 $HOME/.ssh/sevenview
    source $HOME/.keychain/$hostname-fish
end
