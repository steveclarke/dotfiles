# ─[ Path ]───────────────────────────────────────────────────────────────
export PATH="$HOME/bin:$HOME/.local/bin:$HOME/.local/share/dotfiles/bin:$PATH"

# ─[ Dotfiles ]───────────────────────────────────────────────────────────
source ~/.dotfilesrc

# ─[ Completions ]────────────────────────────────────────────────────────
# Load custom completions
if [[ -f ~/.config/bash/completions/dotfiles ]]; then
    source ~/.config/bash/completions/dotfiles
fi

# ─[ Aliases ]────────────────────────────────────────────────────────────
if [[ -f ~/.bash_aliases ]]; then
    source ~/.bash_aliases
fi

# ─[ Exports ]────────────────────────────────────────────────────────────
export LESS=-rF
export RUBY_YJIT_ENABLE=1
export EDITOR=$(which vim)
if [[ -n "$DISPLAY" ]] && command -v code &> /dev/null; then
    export VISUAL="code --wait"
else
    export VISUAL=$EDITOR
fi
export SUDO_EDITOR=$EDITOR 
