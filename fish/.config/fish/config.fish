source ~/.asdf/asdf.fish
source ~/.asdf/completions/asdf.fish

# FUNTOOO KEYCHAIN - frontend to ssh-agent
# https://www.funtoo.org/Funtoo:Keychain
# if status is-interactive
#   /usr/bin/keychain --nogui $HOME/.ssh/sevenview2020 $HOME/.ssh/sevenview
#   source $HOME/.keychain/$(hostname)-fish
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
	abbr -a dps "docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Networks}}\t{{.State}}'"
  abbr -a vim "nvim"
  abbr -a lg "lazygit"
  abbr -a gg "lazygit"
end

# Android SDK
set -x ANDROID_HOME $HOME/Android/Sdk
fish_add_path $ANDROID_HOME/emulator $ANDROID_HOME/tools $ANDROID_HOME/tools/bin $ANDROID_HOME/platform-tools $ANDROID_HOME/cmdline-tools/latest/bin 

set -x JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/

