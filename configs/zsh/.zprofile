# ─[ Homebrew ]───────────────────────────────────────────────────────────
if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
fi

# ─[ JetBrains Toolbox ]──────────────────────────────────────────────────
if [[ -d "/Users/steve/Library/Application Support/JetBrains/Toolbox/scripts" ]]; then
    export PATH="$PATH:/Users/steve/Library/Application Support/JetBrains/Toolbox/scripts"
fi

# ─[ Mise ]───────────────────────────────────────────────────────────────
if command -v mise &> /dev/null; then
    if [[ "$TERM_PROGRAM" == "vscode" ]]; then
        eval "$(mise activate zsh --shims)"
    else
        eval "$(mise activate zsh)"
    fi
fi