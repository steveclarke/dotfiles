function docker-login-gh
    echo $GITHUB_CR_PAT | docker login ghcr.io -u $GITHUB_ACTOR --password-stdin
end
