# https://zellij.dev/documentation/integration

# Automatically open and exit Zellij when the shell is interactive, but ignore
# VSCode.
if status is-interactive  and test "$VSCODE_RESOLVING_ENVIRONMENT" != 1
  set ZELLIJ_AUTO_EXIT true
  eval (zellij setup --generate-auto-start fish | string collect)
end
