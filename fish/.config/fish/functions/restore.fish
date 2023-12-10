function restore --argument filename --description "Rename a backup such as file.bak to remove the .bak extension."
  mv $filename (echo $filename | sed 's/\.bak$//')
end
