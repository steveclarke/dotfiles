# https://zellij.dev/documentation/integration

# Automatically open and exit Zellij when the shell is interactive, but ignore
# VSCode.
# if status is-interactive
#     if test "$TERM_PROGRAM" != "vscode"
#         set ZELLIJ_AUTO_EXIT true
#         eval (zellij setup --generate-auto-start fish | string collect)
#     end
# end

# Automatically open and exit Zellij when using Alacritty.
if set -q ALACRITTY_WINDOW_ID
    set ZELLIJ_AUTO_EXIT true
    eval (zellij setup --generate-auto-start fish | string collect)
end
