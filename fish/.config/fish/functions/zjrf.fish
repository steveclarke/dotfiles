function zjrf
  command zellij run --name "$argv" --floating -- fish -c "$argv"
end
