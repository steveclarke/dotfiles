# Minimal zshenv for non-interactive agent shells.
# Keep mise shims ahead of system tools so /usr/bin/env ruby/node/etc. use the
# repo-managed toolchain even when .zprofile/.zshrc are not loaded.
_mise_shims="$HOME/.local/share/mise/shims"
if [[ -d "$_mise_shims" ]]; then
    path=("$_mise_shims" ${path:#"$_mise_shims"})
    export PATH
fi
unset _mise_shims
