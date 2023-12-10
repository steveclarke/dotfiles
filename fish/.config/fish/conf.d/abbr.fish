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
  abbr -a src "cd ~/src"

  # Dotfiles
  abbr -a dot "cd ~/dotfiles"
  abbr -a dotfish "cd ~/dotfiles/fish/.config/fish"
  abbr -a dotnvim "cd ~/dotfiles/nvim/.config/nvim"
  abbr -a dotz "cd ~/dotfiles/zellij/.config/zellij"

  # Zellij
  abbr -a z "zellij"
  abbr -a zcode "zellij --layout ~/.config/zellij/layouts/code.yml"
  abbr -a ze "zellij edit"
  abbr -a zef "zellij edit --floating"

  # Links to functions
  abbr -a mdc mkdir-cd
end
