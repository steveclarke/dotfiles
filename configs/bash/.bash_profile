# Login-shell startup, read by `bash -lc` — which is how process-compose and
# other dev stacks shell out (zsh is the interactive shell, but the stacks use
# bash). This is the bash twin of configs/zsh/.zshenv.
#
# macOS `/usr/libexec/path_helper` (run from /etc/profile in any login shell)
# front-loads the system dirs onto PATH, so /usr/bin/ruby (system 2.6) shadows
# the mise-managed toolchain. Keep the mise shims ahead of it so dev-stack and
# agent processes resolve repo-managed Ruby/Node/etc. This runs after
# /etc/profile, so the prepend wins.
_mise_shims="$HOME/.local/share/mise/shims"
if [[ -d "$_mise_shims" ]]; then
  # Move shims to the FRONT — remove any existing occurrence, then prepend — so
  # it wins even when an inherited PATH already lists it after /usr/bin.
  PATH=":${PATH}:"
  PATH="${PATH//:${_mise_shims}:/:}"
  PATH="${PATH#:}"
  PATH="${PATH%:}"
  PATH="${_mise_shims}:${PATH}"
  export PATH
fi
unset _mise_shims

# For interactive login shells, load the normal interactive config.
if [[ $- == *i* && -f "$HOME/.bashrc" ]]; then
  source "$HOME/.bashrc"
fi
