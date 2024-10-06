# Mise
# https://mise.jdx.dev/getting-started.html 

if test -f ~/.local/bin/mise
    # https://github.com/jdx/mise/issues/2270#issuecomment-2211805443
    if test "$VSCODE_RESOLVING_ENVIRONMENT" = 1
        mise activate fish --shims | source
    else if status is-interactive
        mise activate fish | source
    else
        mise activate fish --shims | source
    end
end
