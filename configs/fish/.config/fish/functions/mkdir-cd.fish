function mkdir-cd --argument dir --description "Create a directory and cd into it"
    mkdir -p -- $dir
    and cd -- $dir
end
