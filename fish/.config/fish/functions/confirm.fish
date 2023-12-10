function confirm --description "Prompts for confirmation. Exit with status depending on whether answer is [y Y yes YES]."
  read -P "$argv [y/N]> " response
  contains $response y Y yes YES
end
