# ─[ Path ]───────────────────────────────────────────────────────────────
fish_add_path -g ~/bin
fish_add_path -g ~/.local/bin
fish_add_path -g ~/.local/share/dotfiles/bin
fish_add_path -g ~/.cargo/bin
fish_add_path -g --append ~/.docker/bin

# ─[ Exports ]────────────────────────────────────────────────────────────
set -x LESS -rF # -r: raw control chars, -F: quit if one screen
set -x RUBY_YJIT_ENABLE 1

# Stop Homebrew from printing hints after every command.
set -gx HOMEBREW_NO_ENV_HINTS 1
# Since April 2026 `brew upgrade` replaces `auto_updates true` casks while the
# app is running. This keeps desktop apps out of it.
set -gx HOMEBREW_NO_UPGRADE_AUTO_UPDATES_CASKS 1

# hyprmoncfg rewrites its target file wholesale, so it gets a file of its own
# rather than monitors.lua. Hyprland machines only.
if test -d ~/.config/hypr
    set -gx HYPRMONCFG_MONITORS_CONF ~/.config/hypr/monitors-generated.lua
end

# Use the `bass` plugin to source bash scripts
bass source ~/.dotfilesrc

# ─[ Editor et. al. ]─────────────────────────────────────────────────────
set -gx EDITOR (command -v vim || echo vim)
if test -n "$DISPLAY" && command -q cursor
    set -gx VISUAL "cursor --wait"
else
    set -gx VISUAL $EDITOR
end
set -gx SUDO_EDITOR $EDITOR

# ─[ Secrets ]────────────────────────────────────────────────────────────
if test -f ~/.config/fish/secrets.fish
    source ~/.config/fish/secrets.fish
end

# ─[ Aliases (available in all shells) ]──────────────────────────────────
# Eza (ls replacement) - with fallback to system ls
if command -q eza
    alias ls "eza --color=always --icons --group-directories-first"
    alias ll "eza --color=always --icons --group-directories-first --long --classify"
    alias la "eza --color=always --icons --group-directories-first --all"
    alias lla "eza --color=always --icons --group-directories-first --all --long --classify"
    alias tree "eza --tree"
else
    # Fallback to system ls if eza is not available
    alias ls "ls --color=auto"
    alias ll "ls --color=auto -alF"
    alias la "ls --color=auto -a"
    alias lla "ls --color=auto -la"
end

# ─[ Abbrs & Aliases (interactive only) ]─────────────────────────────────
if status is-interactive
    abbr -a ff clear
    if command -q nala
        abbr -a upgrade "sudo nala upgrade"
    else if command -q pacman
        abbr -a upgrade "sudo pacman -Syu"
    else if command -q brew
        abbr -a upgrade "brew upgrade"
    end
    abbr -a kill-server-pid "kill -QUIT \$(cat tmp/pids/server.pid)"
    abbr -a dps "docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Networks}}\t{{.State}}'"
    abbr -a lg lazygit
    abbr -a gg lazygit
    abbr -a ldo lazydocker
    # abbr -a cat bat
    abbr -a up upgrade-all
    abbr -a df "df -h -T"
    abbr -a ncdu "ncdu --color dark"
    abbr -a be bundle exec

    # Commonly cd'ed directories 
    abbr -a --set-cursor src "cd ~/src/%"
    abbr -a --set-cursor sand "cd ~/src/sandbox/%"
    abbr -a cun "cd ~/src/myunio/unio/"
    abbr -a cnj "cd ~/src/nj/nj"
    abbr -a cop "cd ~/src/outport"

    # Claude Code: one-off session on a specific model without touching the
    # global default (/model mid-session overwrites ~/.claude/settings.json)
    abbr -a ccfable "claude --model fable"
    abbr -a ccsonnet "claude --model sonnet"
    abbr -a ccopus "claude --model opus"

    # Dotfiles
    abbr -a --set-cursor dot "cd $DOTFILES_DIR/%"
    abbr -a --set-cursor dotf "cd $DOTFILES_DIR/configs/fish/.config/fish/%"
    abbr -a --set-cursor dotg "cd $DOTFILES_DIR/configs/ghostty/.config/ghostty/%"
    abbr -a --set-cursor dotn "cd $DOTFILES_DIR/configs/nvim/.config/nvim/%"
    abbr -a --set-cursor dotz "cd $DOTFILES_DIR/configs/zellij/.config/zellij/%"

    # Zellij
    abbr -a zj zellij
    abbr -a zje "zellij edit"
    abbr -a zjef "zellij edit --floating"
    abbr -a zjpf "zellij action toggle-pane-frames"
    abbr -a zjr zellij-run
    abbr -a zjrf zellij-run-floating

    # Layouts
    abbr -a zjcode "zellij --layout ~/.config/zellij/layouts/code.yml"
    # abbr -a zju "zellij --layout ~/.config/zellij/layouts/unio.yml --session 'unio-$(date +%F)'"
    # abbr -a zju "zellij --layout ~/.config/zellij/layouts/unio.yml"
    # abbr -a zjc "zellij --layout ~/.config/zellij/layouts/connon.yml"

    # Links to functions
    abbr -a mcd mkdir-cd

    # Docker
    abbr -a dc "docker compose"
    abbr -a dcu "docker compose up -d"
    abbr -a dcd "docker compose down"
    abbr -a dcr "docker compose run"
    abbr -a dce "docker compose exec"
    abbr -a dcl "docker compose logs"

    # Git
    abbr -a gp "git pull"
    abbr -a gP "git push"

    # Ranger
    abbr -a r ranger



    # Fuzzy-find a process and kill it
    abbr -a fkill "ps ax | fzf | awk '{print \$1}' | xargs kill"

    # Generate a random password and select it using fuzzy finder
    if command -q pbcopy
        abbr -a cpass "cpass | fzf | pbcopy"
    else if command -q wl-copy
        abbr -a cpass "cpass | fzf | wl-copy"
    else
        abbr -a cpass "cpass | fzf | xclip -selection clipboard"
    end

    # Fuzzy find a file and open it in nvim
    abbr -a n nvim
    abbr -a nf nvim-fzf
end

if is-jetbrains-ide
    # echo "Not setting a fish shell color scheme since we are in a JetBrains IDE"
    fish_config theme choose "fish default"
else
    fish_config theme choose catppuccin-mocha
end

# Disable default banner
set fish_greeting
# alias fish_greeting colortest

# pnpm
# The pnpm binary itself is managed by mise. PNPM_HOME is only the global-install
# bin dir, so append it — it must never shadow mise's pnpm shim.
if test -d ~/Library/pnpm
    set -gx PNPM_HOME "$HOME/Library/pnpm"
else
    set -gx PNPM_HOME "$HOME/.local/share/pnpm"
end
fish_add_path -g --append $PNPM_HOME
# pnpm end

# LM Studio CLI (lms)
fish_add_path -g --append ~/.lmstudio/bin

# Antigravity
fish_add_path -g ~/.antigravity/antigravity/bin

# opencode
fish_add_path -g ~/.opencode/bin

# ─[ Prompt ]─────────────────────────────────────────────────────────────
if command -q starship
    starship init fish | source
end
