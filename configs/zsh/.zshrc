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
# COMPLETION CONFIGURATION
# =============================================================================

# Load enhanced completion definitions for many commands
zinit light zsh-users/zsh-completions

# Initialize the completion system with security checks
autoload -U compinit && compinit

# Enable case-insensitive completion matching (lowercase matches uppercase)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

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
alias ff=clear
