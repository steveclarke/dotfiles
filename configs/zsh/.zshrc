# ─[ Path ]───────────────────────────────────────────────────────────────
export PATH="$HOME/bin:$HOME/.local/bin:$HOME/.local/share/dotfiles/bin:$PATH"

# ─[ Dotfiles ]───────────────────────────────────────────────────────────
source ~/.dotfilesrc


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

# ─[ Aliases ]────────────────────────────────────────────────────────────
alias ff=clear
alias upgrade="sudo nala upgrade"
alias gg=lazygit
alias lg=lazygit
alias s="cd $HOME/src"
alias dps="docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Networks}}\t{{.State}}'"
alias vim=nvim
alias z=zellij

# ─[ Eza (ls replacement) ]───────────────────────────────────────────────
if command -v eza &> /dev/null; then
    alias ls="eza --color=always --icons --group-directories-first"
    alias la="eza --color=always --icons --group-directories-first --all"
    alias lla="eza --color=always --icons --group-directories-first --all --long"
    alias tree="eza --tree"
fi