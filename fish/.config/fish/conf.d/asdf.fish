# ASDF

if test -d ~/.asdf
  source ~/.asdf/asdf.fish
  source ~/.asdf/completions/asdf.fish
else
  echo "asdf not found (https://asdf-vm.com)"
end
