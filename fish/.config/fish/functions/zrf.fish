function zrf
  command zellij run --name "$argv" --floating -- fish -c "$argv"
end
