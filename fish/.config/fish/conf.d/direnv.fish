# DIRENV
# Source this after asdf so it's path doesn't override any path set in .envrc
# https://lifesaver.codes/answer/fish-direnv-is-no-longer-triggered-on-shell-creation-583
# This solves a problem where the .envrc wasn't parsed immediately after
# VSCode opens a new terminal instance.
if status is-interactive && command -q direnv
  direnv hook fish | source
  direnv export fish | source
else
  echo "direnv not found. Install with 'apt install direnv'"
end
