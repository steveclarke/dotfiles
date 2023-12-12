if status is-interactive
  abbr -a -- ff clear
  abbr -a -- upgrade "sudo nala upgrade"
  abbr -a kill-server-pid "kill -QUIT \$(cat tmp/pids/server.pid)"
  abbr -a dps "docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Networks}}\t{{.State}}'"
  abbr -a vim "nvim"
  abbr -a lg "lazygit"
  abbr -a gg "lazygit"

  # Commonly cd'ed directories 
  abbr -a uapi "cd ~/src/unio-project/unio-api"
  abbr -a uapp "cd ~/src/unio-project/unio-app-ua740"
  abbr -a --set-cursor src "cd ~/src%"

  # Dotfiles
  abbr -a --set-cursor dot "cd ~/dotfiles%"
  abbr -a --set-cursor dotf "cd ~/dotfiles/fish/.config/fish%"
  abbr -a --set-cursor dotn "cd ~/dotfiles/nvim/.config/nvim%"
  abbr -a --set-cursor dotz "cd ~/dotfiles/zellij/.config/zellij%"

  # Zellij
  abbr -a z "zellij"
  abbr -a zcode "zellij --layout ~/.config/zellij/layouts/code.yml"
  abbr -a ze "zellij edit"
  abbr -a zef "zellij edit --floating"
  abbr -a zpf "zellij action toggle-pane-frames"
  abbr -a zcode "zellij --layout ~/.config/zellij/layouts/code.yml"

  # Links to functions
  abbr -a mdc mkdir-cd
end

