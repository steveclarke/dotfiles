if status is-interactive && command -q zoxide
  zoxide init fish | source
else
  echo "zoxide not found. Install with ~/dotfiles/install-tools"
end
