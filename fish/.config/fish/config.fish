# Path
fish_add_path ~/bin
fish_add_path ~/.local/bin

if command -q cargo
  fish_add_path ~/.cargo/bin
end

# Editor et. al.
set -gx EDITOR (which nvim)
set -gx VISUAL $EDITOR
set -gx SUDO_EDITOR $EDITOR

# Exports
set -x LESS -rF # -r: raw control chars, -F: quit if one screen

# Abbrs & Aliases
if status is-interactive
  abbr -a ff clear
  abbr -a upgrade "sudo nala upgrade"
  abbr -a kill-server-pid "kill -QUIT \$(cat tmp/pids/server.pid)"
  abbr -a dps "docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Networks}}\t{{.State}}'"
  abbr -a vim "nvim"
  abbr -a lg "lazygit"
  abbr -a gg "lazygit"
  abbr -a cat "bat"

  # Commonly cd'ed directories 
  abbr -a uapi "cd ~/src/unio-project/unio-api"
  abbr -a uapp "cd ~/src/unio-project/unio-app-ua740"
  abbr -a --set-cursor src "cd ~/src%"
  abbr -a --set-cursor sand "cd ~/src/sandbox%"

  # Dotfiles
  abbr -a --set-cursor dot "cd ~/dotfiles%"
  abbr -a --set-cursor dotf "cd ~/dotfiles/fish/.config/fish%"
  abbr -a --set-cursor dotn "cd ~/dotfiles/nvim/.config/nvim%"
  abbr -a --set-cursor dotz "cd ~/dotfiles/zellij/.config/zellij%"

  # Zellij
  abbr -a zj "zellij"
  abbr -a zje "zellij edit"
  abbr -a zjef "zellij edit --floating"
  abbr -a zjpf "zellij action toggle-pane-frames"
  abbr -a zjcode "zellij --layout ~/.config/zellij/layouts/code.yml"

  # Links to functions
  abbr -a mdc mkdir-cd

  # Eza (ls replacement)
  if command -q eza
    alias ls "eza --color=always --icons --group-directories-first"
    alias la "eza --color=always --icons --group-directories-first --all"
    alias ll "eza --color=always --icons --group-directories-first --all --long"
    alias tree "eza --tree"
  else
    echo "Install eza for a better ls experience (https://eza.rocks)"
  end
end

fish_config theme choose "catppuccin-mocha"

# Disable default banner
set fish_greeting 
# alias fish_greeting colortest
