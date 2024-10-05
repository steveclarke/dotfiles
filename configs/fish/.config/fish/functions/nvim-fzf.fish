function nvim-fzf
    set selected_file (fzf --query="$argv" --preview 'bat --color=always {}')
    if test -n "$selected_file"
        nvim $selected_file
    end
end
