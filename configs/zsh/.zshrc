# =============================================================================
# ZINIT PLUGIN MANAGER
# =============================================================================

### Added by Zinit's installer
ZINIT_HOME="$HOME/.local/share/zinit"
if [[ ! -f $ZINIT_HOME/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$ZINIT_HOME" && command chmod g-rwX "$ZINIT_HOME"
    command git clone https://github.com/zdharma-continuum/zinit "$ZINIT_HOME/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$ZINIT_HOME/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust
### End of Zinit's installer chunk

# =============================================================================
# SYNTAX HIGHLIGHTING (for shell commands)
# =============================================================================
zinit light zsh-users/zsh-syntax-highlighting

# =============================================================================
# COMPLETIONS 
# =============================================================================

# Load enhanced completion definitions for many commands
zinit light zsh-users/zsh-completions

# Load and initialize zsh's completion system (compinit)
# autoload -U loads the compinit function without expanding aliases
# compinit initializes completions and performs security checks by verifying
# that completion files are not writable by others (prevents code injection)
autoload -U compinit && compinit

# Replay cached completion definitions from loaded plugins (quietly)
# This must run after compinit to activate all the completion rules from
# plugins like zsh-completions. Without this, tab completion won't work for
# many commands. The -q flag suppresses output during the replay process.
# See: https://github.com/zdharma-continuum/zinit#calling-compinit-without-turbo-mode
zinit cdreplay -q

# Enable case-insensitive completion matching (lowercase matches uppercase)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# Add colors to the completion list
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# =============================================================================
# AUTO-SUGGESTIONS (FISH-STYLE)
# =============================================================================

zinit light zsh-users/zsh-autosuggestions

# =============================================================================
# HISTORY CONFIGURATION
# =============================================================================

# Set the maximum number of commands to keep in memory during the session
export HISTSIZE=5000

# Set the maximum number of commands to save to the history file
export SAVEHIST=$HISTSIZE

# Remove duplicate entries from history when it gets full
export HISTDUP=erase

# Append new history entries to the history file (instead of overwriting)
setopt appendhistory

# Share history between all active zsh sessions in real-time
setopt sharehistory

# Don't save commands that start with a space to history (useful for sensitive commands)
setopt hist_ignore_space

# Don't add duplicate commands to history, even if they're not consecutive
setopt hist_ignore_all_dups

# Don't save duplicate commands to the history file
setopt hist_save_no_dups

# When searching history, don't display duplicates of the same command
setopt hist_find_no_dups

# =============================================================================
# KEY BINDINGS
# =============================================================================

# Use emacs key bindings
bindkey -e

# Bind Ctrl+P/N to search backwards/forwards through history based on current input
# Example: type "git" then Ctrl+P to cycle through previous git commands only
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# =============================================================================
# PROMPT CONFIGURATION
# =============================================================================

if command -v starship >/dev/null; then
    eval "$(starship init zsh)"
fi

# =============================================================================
# ALIASES
# =============================================================================

# Eza (ls replacement) - with fallback to system ls
if command -v eza >/dev/null 2>&1; then
    alias ls="eza --color=always --icons --group-directories-first"
    alias la="eza --color=always --icons --group-directories-first --all"
    alias lla="eza --color=always --icons --group-directories-first --all --long"
    alias tree="eza --tree"
else
    # Fallback to system ls if eza is not available
    alias ls="ls --color=auto"
    alias la="ls --color=auto -a"
    alias lla="ls --color=auto -la"
fi

alias ff=clear

# =============================================================================
# FUZZY FINDER (FZF)
# =============================================================================

if command -v fzf >/dev/null 2>&1; then
    zinit light Aloxaf/fzf-tab
    eval "$(fzf --zsh)"
    zstyle ':completion:*' menu no
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
fi

# =============================================================================
# ZOXIDE
# =============================================================================

if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init --cmd cd zsh)"
    # use fzf-tab to preview the directory
    if command -v fzf >/dev/null 2>&1; then
        zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
    fi
fi

# =============================================================================
# SNIPPETS
# =============================================================================

# zinit snippet OMZP::git
# zinit snippet OMZP::sudo
