source ~/.asdf/asdf.fish
source ~/.asdf/completions/asdf.fish

# FUNTOOO KEYCHAIN - frontend to ssh-agent
# https://www.funtoo.org/Funtoo:Keychain
# if status is-interactive
#   /usr/bin/keychain --nogui $HOME/.ssh/sevenview2020 $HOME/.ssh/sevenview
#   /usr/bin/keychain --nogui $HOME/.ssh/sevenview2020 $HOME/.ssh/sevenview2020
#   source $HOME/.keychain/$hostname-fish
# end

# DIRENV
# Source this after asdf so it's path doesn't override any path set in .envrc
# https://lifesaver.codes/answer/fish-direnv-is-no-longer-triggered-on-shell-creation-583
# This solves a problem where the .envrc wasn't parsed immediately after
# VSCode opens a new terminal instance.
if status is-interactive
  direnv hook fish | source
  direnv export fish | source
end

if status is-interactive
	abbr -a -- ff clear
	abbr -a -- upgrade "sudo nala upgrade"
	abbr -a kill-server-pid "kill -QUIT \$(cat tmp/pids/server.pid)"
end
