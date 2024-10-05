function backup --argument filename --description "Create a copy of file as file.bak."
    cp $filename $filename.bak
end
