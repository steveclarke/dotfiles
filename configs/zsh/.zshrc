# =============================================================================
# ZSH RC - INTERACTIVE SHELL CONFIGURATION  
# =============================================================================
# This file (.zshrc) is loaded for ALL INTERACTIVE shells (login + non-login)
#
# INTERACTIVE SHELLS are created when:
# - Opening a new terminal tab/window (most common)
# - Running `zsh` without special flags
# - Any shell where you can type commands interactively
# - NOT loaded for non-interactive shells (scripts, command execution)
#
# LOADING ORDER:
# For login shells:      ~/.zprofile → ~/.zshrc (THIS FILE)
# For non-login shells:  ~/.zshrc (THIS FILE) only
#
# Use this file for:
# - Interactive features: completion, prompt, key bindings, aliases
# - Plugin configuration and shell enhancements
# - Settings that should apply to every interactive session
# - Anything that makes the shell more pleasant to use interactively
# =============================================================================

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
# ENVIRONMENT VARIABLES
# =============================================================================

# Add local bin directories to PATH
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/share/dotfiles/bin:$PATH"

# Less pager configuration: -r (raw control chars), -F (quit if one screen)
export LESS="-rF"

# Enable Ruby YJIT (Just-In-Time compiler) for better performance
export RUBY_YJIT_ENABLE=1

# Dotfiles directory for aliases
export DOTFILES_DIR="$HOME/.local/share/dotfiles"

# Source shared dotfiles configuration (environment variables, secrets, etc.)
# This file is shared between Fish (via bass plugin) and Zsh
if [[ -f "$HOME/.dotfilesrc" ]]; then
    source "$HOME/.dotfilesrc"
fi

# =============================================================================
# EDITOR AND SUDO_EDITOR
# =============================================================================
export EDITOR=$(command -v vim || echo vim)
if [[ -n "$DISPLAY" ]] && command -v cursor >/dev/null 2>&1; then
    export VISUAL="cursor --wait"
else
    export VISUAL="$EDITOR"
fi
export SUDO_EDITOR="$EDITOR"

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
# Add colors to the completion list (split LS_COLORS on colons for zsh format)
if [[ -n "$LS_COLORS" ]]; then
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi

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

alias be="bundle exec"
alias dps="docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Networks}}\t{{.State}}'"
alias ff=clear
alias gg=lazygit
alias kill-server-pid="kill -QUIT \$(cat tmp/pids/server.pid)"
alias lg=lazygit
alias ncdu="ncdu --color dark"

# Commonly cd'ed directories (fish had --set-cursor, zsh uses simple aliases)
alias src="cd ~/src/"
alias sand="cd ~/src/sandbox/"
alias cun="cd ~/src/myunio/unio/"

# Dotfiles (requires DOTFILES_DIR to be set)
alias dot="cd \$DOTFILES_DIR/"
alias dotf="cd \$DOTFILES_DIR/configs/fish/.config/fish/"
alias dotg="cd \$DOTFILES_DIR/configs/ghostty/.config/ghostty/"
alias dotn="cd \$DOTFILES_DIR/configs/nvim/.config/nvim/"
alias dotz="cd \$DOTFILES_DIR/configs/zellij/.config/zellij/"

# Zellij
alias zj=zellij

# Nvim
alias n="NVIM_APPNAME=nvim-handcrafted nvim"

# Eza (ls replacement) - with fallback to system ls
if command -v eza >/dev/null 2>&1; then
    alias ls="eza --color=always --icons --group-directories-first"
    alias ll="eza --color=always --icons --group-directories-first --long --classify"
    alias la="eza --color=always --icons --group-directories-first --all"
    alias lla="eza --color=always --icons --group-directories-first --all --long --classify"
    alias tree="eza --tree"
else
    # Fallback to system ls if eza is not available
    alias ls="ls --color=auto"
    alias ll="ls --color=auto -alF"
    alias la="ls --color=auto -a"
    alias lla="ls --color=auto -la"
fi

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
# SNIPPETS
# =============================================================================

# zinit snippet OMZP::git
# zinit snippet OMZP::sudo

# =============================================================================
# DIRENV
# =============================================================================

if command -v direnv >/dev/null 2>&1; then
    eval "$(direnv hook zsh)"
fi

# =============================================================================
# MISE
# =============================================================================
# Activate mise for interactive shells (both login and non-login)
# Non-login shells (like those opened in VS Code/Cursor) won't load .zprofile
# so we need this here to ensure mise is available in all interactive shells
if command -v mise >/dev/null 2>&1; then
    eval "$(mise activate zsh)"
fi

# =============================================================================
# KEYCHAIN - frontend to ssh-agent (Linux only)
# =============================================================================
# Keychain is a frontend to ssh-agent that manages SSH keys across shell sessions.
# It's particularly useful on Linux where ssh-agent management isn't as integrated
# as it is on macOS. This configuration:
#
# 1. Only runs on Linux systems (macOS has better native SSH agent integration)
# 2. Only runs in interactive sessions to avoid issues with non-interactive scripts
# 3. Checks for specific SSH keys before attempting to load them
# 4. Provides helpful warnings when expected keys are missing
# 5. Sources the keychain environment to make SSH keys available to all shells
#
# Expected SSH keys:
# - ~/.ssh/sevenview2020 - Primary SSH key
# - ~/.ssh/sevenview     - Secondary SSH key
#
# See: https://www.funtoo.org/Funtoo:Keychain

if [[ "$OSTYPE" == "linux-gnu"* ]] && [[ -o interactive ]] && command -v keychain >/dev/null 2>&1; then
    # Only load keychain if SSH keys exist
    ssh_keys=()
    missing_keys=()
    
    if [[ -f "$HOME/.ssh/sevenview2020" ]]; then
        ssh_keys+=("$HOME/.ssh/sevenview2020")
    else
        missing_keys+=("sevenview2020")
    fi
    
    if [[ -f "$HOME/.ssh/sevenview" ]]; then
        ssh_keys+=("$HOME/.ssh/sevenview")
    else
        missing_keys+=("sevenview")
    fi
    
    # Only run keychain if we have keys to load
    if [[ ${#ssh_keys[@]} -gt 0 ]]; then
        keychain --nogui "${ssh_keys[@]}"
        if [[ -f "$HOME/.keychain/$HOST-sh" ]]; then
            source "$HOME/.keychain/$HOST-sh"
        fi
    else
        echo "⚠ Keychain: No SSH keys found (${missing_keys[*]})"
        echo "  SSH keys should be placed in ~/.ssh/ during dotfiles setup"
    fi
fi

# pnpm
export PNPM_HOME="/Users/steve/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Stop Homebrew from showing hints after every command
export HOMEBREW_NO_ENV_HINTS=1

# Herd Lite - PHP development environment
if [[ -d "/Users/steve/.config/herd-lite/bin" ]]; then
    export PATH="/Users/steve/.config/herd-lite/bin:$PATH"
    export PHP_INI_SCAN_DIR="/Users/steve/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"
fi


# Added by Antigravity
export PATH="/Users/steve/.antigravity/antigravity/bin:$PATH"

# opencode
export PATH=/Users/steve/.opencode/bin:$PATH
