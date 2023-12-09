if status is-interactive
	abbr -a -- ff clear
	abbr -a -- upgrade "sudo nala upgrade"
	abbr -a kill-server-pid "kill -QUIT \$(cat tmp/pids/server.pid)"
	abbr -a dps "docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Networks}}\t{{.State}}'"
  abbr -a vim "nvim"
  abbr -a lg "lazygit"
  abbr -a gg "lazygit"
  abbr -a z "zellij"

  # Commonly cd'ed directories 
  abbr -a uapi "cd ~/src/unio-project/unio-api"
  abbr -a uapp "cd ~/src/unio-project/unio-app-ua740"

  abbr -a dot "cd ~/dotfiles"
  abbr -a dotfish "cd ~/dotfiles/fish/.config/fish"
  abbr -a dotnvim "cd ~/dotfiles/nvim/.config/nvim"
end
