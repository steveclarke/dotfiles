# ASDF
if command -q asdf
  source ~/.asdf/asdf.fish
  source ~/.asdf/completions/asdf.fish
else
  echo "asdf not found (https://asdf-vm.com)"
end
