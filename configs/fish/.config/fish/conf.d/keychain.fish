# FUNTOOO KEYCHAIN - frontend to ssh-agent
# https://www.funtoo.org/Funtoo:Keychain
if status is-interactive
    # Only load keychain if SSH keys exist
    set -l ssh_keys
    set -l missing_keys
    
    if test -f $HOME/.ssh/sevenview2020
        set ssh_keys $ssh_keys $HOME/.ssh/sevenview2020
    else
        set missing_keys $missing_keys sevenview2020
    end
    
    if test -f $HOME/.ssh/sevenview
        set ssh_keys $ssh_keys $HOME/.ssh/sevenview
    else
        set missing_keys $missing_keys sevenview
    end
    
    # Only run keychain if we have keys to load
    if test (count $ssh_keys) -gt 0
        keychain --nogui $ssh_keys
        if test -f $HOME/.keychain/$hostname-fish
            source $HOME/.keychain/$hostname-fish
        end
    else
        echo "⚠ Keychain: No SSH keys found ($missing_keys)"
        echo "  SSH keys should be placed in ~/.ssh/ during dotfiles setup"
    end
end
