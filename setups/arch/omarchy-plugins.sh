source "${HOME}"/.dotfilesrc

# Git-managed Omarchy shell plugins.
#
# These are NOT vendored into this repo: each is its own upstream git
# repository, and `omarchy plugin add` clones it and records the remote so
# `omarchy plugin update` keeps it current. Vendoring a copy here would fork
# them silently. Plugins with no upstream (a clone of an Omarchy built-in, like
# steve.workspaces) DO belong in omarchy-plugins/ and are copied by stow.sh.
#
# The bar references these by id in omarchy-shell/shell.json, so a rebuilt
# machine needs them back or those widgets are dead entries.
#
# Sourced by install.sh, so no `exit` and no `set -e` here - both would take
# the whole installer down with them.

omarchy_plugins_setup() {
  command -v omarchy >/dev/null || return 0

  # id|git url. The id must match the folder omarchy plugin add creates.
  local plugins=(
    "io.github.steveclarke.screenpush|https://github.com/steveclarke/omarchy-screenpush.git"
    "vt.sun|https://github.com/vitally/omarchy-solar-times.git"
  )

  local entry id url
  for entry in "${plugins[@]}"; do
    id="${entry%%|*}"
    url="${entry#*|}"

    if [ -d "${HOME}/.config/omarchy/plugins/${id}" ]; then
      echo "  ${id} already installed"
      continue
    fi

    echo "  installing ${id} from ${url}"
    omarchy plugin add "$url" --yes || echo "  WARNING: failed to install ${id}"
  done
}

omarchy_plugins_setup
unset -f omarchy_plugins_setup
