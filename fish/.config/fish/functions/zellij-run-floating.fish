function zellij-run-floating
    command zellij run --name "$argv" --floating -- fish -c "$argv"
end
