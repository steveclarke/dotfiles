function zellij-run
    command zellij run --name "$argv" -- fish -c "$argv"
end
