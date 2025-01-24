# ─[ Path ]───────────────────────────────────────────────────────────────
fish_add_path ~/bin
fish_add_path ~/.local/bin
fish_add_path ~/.local/share/dotfiles/bin

# ─[ Exports ]────────────────────────────────────────────────────────────
set -x LESS -rF # -r: raw control chars, -F: quit if one screen
set -x RUBY_YJIT_ENABLE 1

# Use the `bass` plugin to source bash scripts
bass source ~/.dotfilesrc

# ─[ Editor et. al. ]─────────────────────────────────────────────────────
set -gx EDITOR (which vim)
if test -n "$DISPLAY" && command -q code
    set -gx VISUAL "code --wait"
else
    set -gx VISUAL $EDITOR
end
set -gx SUDO_EDITOR $EDITOR

# ─[ Secrets ]────────────────────────────────────────────────────────────
if test -f ~/.config/fish/secrets.fish
    source ~/.config/fish/secrets.fish
end

# ─[ Abbrs & Aliases ]────────────────────────────────────────────────────
if status is-interactive
    abbr -a ff clear
    abbr -a upgrade "sudo nala upgrade"
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

    # Dotfiles
    abbr -a --set-cursor dot "cd $DOTFILES_DIR/%"
    abbr -a --set-cursor dotf "cd $DOTFILES_DIR/configs/fish/.config/fish/%"
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

    # Eza (ls replacement)
    if command -q eza
        alias ls "eza --color=always --icons --group-directories-first"
        alias la "eza --color=always --icons --group-directories-first --all"
        alias lla "eza --color=always --icons --group-directories-first --all --long"
        alias tree "eza --tree"
    end

    # Fuzzy-find a process and kill it
    abbr -a fkill "ps ax | fzf | awk '{print \$1}' | xargs kill"

    # Generate a random password and select it using fuzzy finder
    abbr -a cpass "cpass | fzf | xclip -selection clipboard"

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
