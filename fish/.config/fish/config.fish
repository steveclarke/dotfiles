# Path
fish_add_path ~/bin
fish_add_path ~/.local/bin

# [[ Exports ]]
set -x LESS -rF # -r: raw control chars, -F: quit if one screen

# Editor et. al.
set -gx EDITOR (which nvim)
set -gx VISUAL $EDITOR
set -gx SUDO_EDITOR $EDITOR

# Abbrs & Aliases
if status is-interactive
    abbr -a ff clear
    abbr -a upgrade "sudo nala upgrade"
    abbr -a kill-server-pid "kill -QUIT \$(cat tmp/pids/server.pid)"
    abbr -a dps "docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Networks}}\t{{.State}}'"
    abbr -a lg lazygit
    abbr -a gg lazygit
    abbr -a ldo lazydocker
    abbr -a cat bat
    abbr -a up upgrade-all
    abbr -a df "df -h -T"
    abbr -a ncdu "ncdu --color dark"

    # Commonly cd'ed directories 
    abbr -a uapi "cd ~/src/unio-project/unio-api"
    abbr -a uapp "cd ~/src/unio-project/unio-app-ua740"
    abbr -a --set-cursor src "cd ~/src/%"
    abbr -a --set-cursor sand "cd ~/src/sandbox/%"

    # Dotfiles
    abbr -a --set-cursor dot "cd ~/dotfiles/%"
    abbr -a --set-cursor dotf "cd ~/dotfiles/fish/.config/fish/%"
    abbr -a --set-cursor dotn "cd ~/dotfiles/nvim/.config/nvim/%"
    abbr -a --set-cursor dotz "cd ~/dotfiles/zellij/.config/zellij/%"
    abbr -a --set-cursor doti "cd ~/dotfiles/i3/.config/i3/%"
    abbr -a dotup "cd ~/dotfiles && git pull && ./setup && cd -"

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
    abbr -a zju "zellij --layout ~/.config/zellij/layouts/unio.yml"

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

    # Eza (ls replacement)
    if command -q eza
        alias ls "eza --color=always --icons --group-directories-first"
        alias la "eza --color=always --icons --group-directories-first --all"
        alias ll "eza --color=always --icons --group-directories-first --all --long"
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

fish_config theme choose catppuccin-mocha

# Disable default banner
set fish_greeting
# alias fish_greeting colortest
