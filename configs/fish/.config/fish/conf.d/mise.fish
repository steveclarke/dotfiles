# Mise
# https://mise.jdx.dev/getting-started.html 

# Note: I had to move this to config.fish because it suddenly stopped working on
# 2025-02-14 from conf.d/mise.fish in VSCode.

# if test -f ~/.local/bin/mise
#     # https://github.com/jdx/mise/issues/2270#issuecomment-2211805443
#     if test "$VSCODE_RESOLVING_ENVIRONMENT" = "1"
#         mise activate fish --shims | source
#     else if status is-interactive
#         mise activate fish | source
#     else
#         mise activate fish --shims | source
#     end
# end

# The equivalent for .bashrc is:
#
# if [ "$VSCODE_RESOLVING_ENVIRONMENT" = "1"]; then
#   eval "$(mise activate bash --shims)"
# else
#   eval "$(mise activate bash)"
# fi
