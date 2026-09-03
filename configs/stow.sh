#!/usr/bin/env bash
#
# Stow Configuration Script
#
# Symlinks dotfile configurations from the configs/ directory to $HOME
# using GNU Stow. Handles cross-platform configs with Omarchy awareness.
#
# On Omarchy, configs managed by the framework are skipped. For bash,
# a source line is added to ~/.bashrc to hook into our config.
#
# Prerequisites: GNU Stow must be installed
# Usage: bash stow.sh (or sourced by install.sh)
#

source "${HOME}"/.dotfilesrc
source "${DOTFILES_DIR}"/lib/dotfiles.sh

# Detect OS/distro (needed for is_omarchy guards when run standalone)
detect_os

# Exit on any error
set -e

# Validate stow is installed
if ! is_installed stow; then
  error "GNU Stow is not installed. Run prereq installation first."
  exit 1
fi

config_banner() {
  banner "Configuring $1"
}

do_stow() {
  if ! stow -d "${DOTFILES_DIR}"/configs -t "${HOME}" "$1"; then
    error "Failed to stow $1"
    return 1
  fi
}

# Remove files or directories that would conflict with stow (non-symlinks only)
# This makes the script idempotent - existing stow symlinks are left untouched
cleanup_paths() {
  local path
  for path in "$@"; do
    if [ -e "$path" ] && [ ! -L "$path" ]; then
      if [ -d "$path" ]; then
        rm -rf "$path"
      else
        rm -f "$path"
      fi
    fi
  done
}

# Remove symlinks whose target no longer exists. cleanup_paths deliberately
# skips symlinks (so it doesn't eat stow's own links), which leaves nothing to
# clean up a link stow orphaned by a package losing a file.
cleanup_dead_symlinks() {
  local path
  for path in "$@"; do
    if [ -L "$path" ] && [ ! -e "$path" ]; then
      rm -f "$path"
      echo "  removed dead symlink: ${path}"
    fi
  done
}

# Ensure directories exist (for stow to symlink into)
ensure_dir() {
  local path
  for path in "$@"; do
    mkdir -p "$path"
  done
}

# Stow a configuration package
# Args: display_name, stow_package
stow_package() {
  local display_name="$1"
  local stow_package="$2"

  config_banner "${display_name}"
  do_stow "${stow_package}"
}

# Stow a configuration package with a custom target directory
# Args: display_name, stow_package, target_dir
stow_package_to() {
  local display_name="$1"
  local stow_package="$2"
  local target_dir="$3"

  config_banner "${display_name}"
  if ! stow -d "${DOTFILES_DIR}/configs" -t "${target_dir}" "${stow_package}"; then
    error "Failed to stow ${stow_package}"
    return 1
  fi
}

# =============================================================================
# Cross-platform packages (stow on all platforms)
# =============================================================================
# Cross-platform packages (stow on all platforms)
# =============================================================================

ensure_dir "${HOME}/bin"
stow_package "Bin scripts" "bin"

# Bash — new XDG-style layout under ~/.config/bash/
ensure_dir "${HOME}/.config/bash"
cleanup_paths "${HOME}/.bash_aliases" "${HOME}/.bash_profile"
stow_package "Bash" "bash"

# On Omarchy, hook our bash config into ~/.bashrc (which is safe from updates)
if is_omarchy; then
  if ! grep -q 'config/bash/rc' "${HOME}/.bashrc" 2>/dev/null; then
    echo '[[ -f ~/.config/bash/rc ]] && source ~/.config/bash/rc' >> "${HOME}/.bashrc"
  fi
fi

ensure_dir "${HOME}/.config/fish"
stow_package "Fish shell" "fish"

ensure_dir "${HOME}/.config/mise"
cleanup_paths "${HOME}/.config/mise/config.toml"
stow_package "Mise" "mise"

stow_package "Ruby" "ruby"

stow_package "Node (default npm packages)" "node"

ensure_dir "${HOME}/.config/zellij"
stow_package "Zellij" "zellij"

# Process compose — uses XDG on Linux, ~/Library/Application Support on macOS
if is_macos; then
  ensure_dir "${HOME}/Library/Application Support"
  stow_package_to "Process compose" "process-compose" "${HOME}/Library/Application Support"
else
  ensure_dir "${HOME}/.config"
  stow_package_to "Process compose" "process-compose" "${HOME}/.config"
fi

cleanup_paths "${HOME}/.zshrc" "${HOME}/.zprofile"
stow_package "Zsh" "zsh"

cleanup_paths "${HOME}/.ideavimrc"
stow_package "Idea" "idea"

cleanup_paths "${HOME}/justfile"
stow_package "Just" "just"

# Claude — statusline and hooks are shared and stowed into ~/.claude.
#
# ~/.claude/settings.json is deliberately NOT stowed. Claude Code writes to that
# file at runtime (effort level, theme, the auto mode environment survey, which
# describes this machine's infrastructure), and this repo is public. It stays a
# real machine-local file. Do NOT add cleanup_paths for it — that would delete a
# machine's settings on every `dotfiles up`.
#
# The hand-curated settings live in claude/managed-settings.json and are
# symlinked to the system managed-settings path below. See claude/README.md.
config_banner "Claude"
ensure_dir "${HOME}/.claude"
# hooks/ was removed from the claude package. Plain `stow` never cleans up a
# symlink whose target is gone, so without this every migrating machine keeps a
# dangling ~/.claude/hooks. cleanup_paths won't do it — that skips symlinks.
cleanup_dead_symlinks "${HOME}/.claude/hooks"
do_stow "claude"

# Claude managed settings — root-owned system path, so stow can't do this.
stow_claude_managed_settings() {
  local src="${DOTFILES_DIR}/claude/managed-settings.json"
  local dir

  if is_macos; then
    dir="/Library/Application Support/ClaudeCode"
  elif is_linux; then
    dir="/etc/claude-code"
  else
    echo "  skipping — no managed-settings path known for this platform"
    return 0
  fi

  local dest="${dir}/managed-settings.json"

  # Already pointing at the repo — nothing to do, and nothing to sudo for.
  if [ "$(readlink "$dest" 2>/dev/null)" = "$src" ]; then
    echo "  already linked: ${dest}"
    return 0
  fi

  # A real file here belongs to someone else (an employer's MDM, a manual
  # install). Refuse rather than clobber it.
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    error "Not a symlink, leaving alone: ${dest}"
    error "Move it aside yourself if you want dotfiles to manage it."
    return 0
  fi

  if sudo mkdir -p "$dir" && sudo ln -sfn "$src" "$dest"; then
    echo "  linked: ${dest}"
  else
    error "Failed to link ${dest}"
    error "Claude Code is running without your curated settings until this is fixed."
    return 1
  fi
}

config_banner "Claude managed settings"
# Don't let a failure here abort the rest of stow, but don't let it pass silently
# either — error() returns 0, so without this the whole run reports success.
STOW_FAILED=""
stow_claude_managed_settings || STOW_FAILED="claude-managed-settings"

# Tmux — Omarchy ships a stock tmux.conf with no extension point, so we own
# the file. cleanup_paths removes Omarchy's copy before stow drops in our symlink.
ensure_dir "${HOME}/.config/tmux"
cleanup_paths "${HOME}/.config/tmux/tmux.conf"
stow_package "Tmux" "tmux"

# =============================================================================
# Omarchy-only packages
# =============================================================================

if is_omarchy; then
  # Voxtype — Omarchy updates can overwrite config with stock defaults
  ensure_dir "${HOME}/.config/voxtype"
  cleanup_paths "${HOME}/.config/voxtype/config.toml"
  stow_package "Voxtype" "voxtype"

  # Hyprland — Omarchy 4 configures Hyprland in Lua; the old .conf hook files are
  # inert. Never touch hyprland.lua itself, Omarchy owns it. Deliberately NOT
  # stowed: monitors-generated.lua (hyprmoncfg rewrites it wholesale) and
  # xdph.conf (portal config, left as Omarchy ships it).
  ensure_dir "${HOME}/.config/hypr"
  cleanup_paths "${HOME}/.config/hypr/monitors.lua" "${HOME}/.config/hypr/bindings.lua" "${HOME}/.config/hypr/autostart.lua" "${HOME}/.config/hypr/input.lua" "${HOME}/.config/hypr/looknfeel.lua" "${HOME}/.config/hypr/hyprsunset.conf"
  stow_package "Hyprland" "hypr"

  # hyprmoncfg monitor profiles — the saved screen arrangements, keyed by panel
  # make/model/serial rather than by machine, so the daemon auto-applies
  # whichever profile matches what is plugged in. Stow folds the whole
  # profiles/ DIRECTORY into a symlink, so a profile saved later lands in this
  # repo with no extra step. (Linking the directory rather than each file also
  # survives hyprmoncfg writing profiles atomically: the rename happens inside
  # the real directory.) monitors-generated.lua stays out — hyprmoncfg rewrites
  # it wholesale from whichever profile is active.
  ensure_dir "${HOME}/.config/hyprmoncfg"
  cleanup_paths "${HOME}/.config/hyprmoncfg/profiles"
  stow_package "hyprmoncfg profiles" "hyprmoncfg"

  # Omarchy shell — bar layout, widget set, idle/lock timings (shell.json) and
  # the machine-level font/spacing override (shell.toml). COPIED, never
  # symlinked: both are rewritten atomically by Omarchy itself — the shell's
  # FileView uses `atomicWrites: true` for shell.json, and
  # omarchy-display-text-size does `mv "$tmp" shell.toml`. A temp-file rename
  # replaces a symlink with a real file, so a stow link silently detaches the
  # first time the bar UI or `omarchy display text size` writes. Dotfiles is
  # the source of truth; edits made through the Omarchy UI live only in
  # ~/.config until copied back here, and `dotfiles stow` overwrites them.
  config_banner "Omarchy shell"
  ensure_dir "${HOME}/.config/omarchy"
  # rm -f, not cleanup_paths: cleanup_paths deliberately skips symlinks, and a
  # leftover link from the days these were stowed would make cp write straight
  # back into this repo.
  rm -f "${HOME}/.config/omarchy/shell.json" "${HOME}/.config/omarchy/shell.toml"
  for shell_file in "${DOTFILES_DIR}"/omarchy-shell/*; do
    [ -f "$shell_file" ] || continue
    cp -a "$shell_file" "${HOME}/.config/omarchy/$(basename "$shell_file")"
    echo "  copied $(basename "$shell_file")"
  done

  # Omarchy shell plugins — COPIED, never symlinked: omarchy-plugin-validate
  # rejects symlinks in or as a plugin folder, which is the one place the stow
  # pattern does not work. Hence living outside configs/. Local edits under
  # ~/.config/omarchy/plugins/ are overwritten, so edit the dotfiles copy.
  config_banner "Omarchy shell plugins"
  ensure_dir "${HOME}/.config/omarchy/plugins"
  for plugin_src in "${DOTFILES_DIR}"/omarchy-plugins/*/; do
    [ -d "$plugin_src" ] || continue
    plugin_name="$(basename "$plugin_src")"
    rm -rf "${HOME}/.config/omarchy/plugins/${plugin_name}"
    cp -a "$plugin_src" "${HOME}/.config/omarchy/plugins/${plugin_name}"
    echo "  copied ${plugin_name}"
  done

  # Omarchy custom themes — user-authored themes under ~/.config/omarchy/themes/
  ensure_dir "${HOME}/.config/omarchy/themes"
  stow_package "Omarchy themes" "omarchy-themes"

  # Omarchy hooks — post-update.d/voxtype-gpu re-enables Voxtype GPU after upgrades swap it to CPU
  ensure_dir "${HOME}/.config/omarchy/hooks/post-update.d"
  cleanup_paths "${HOME}/.config/omarchy/hooks/post-update" "${HOME}/.config/omarchy/hooks/post-update.d/voxtype-gpu"
  stow_package "Omarchy hooks" "omarchy-hooks"
fi

# =============================================================================
# Skip on Omarchy (Omarchy manages these)
# =============================================================================

if ! is_omarchy; then
  # Terminals — Omarchy manages via theming
  ensure_dir "${HOME}/.config/alacritty"
  stow_package "Alacritty" "alacritty"

  ensure_dir "${HOME}/.config/ghostty"
  stow_package "Ghostty" "ghostty"

  # Neovim — Omarchy ships its own LazyVim
  ensure_dir "${HOME}/.config/nvim"
  stow_package "Neovim" "nvim"

  # Starship — Omarchy manages starship prompt
  stow_package "Starship" "starship"

  # Fonts — Omarchy ships JetBrains Mono NF
  ensure_dir "${HOME}/.local/share/fonts"
  stow_package "Fonts" "fonts"

  # OpenCode — Omarchy has its own config
  stow_package "OpenCode" "opencode"
fi

if [ -n "${STOW_FAILED:-}" ]; then
  error "Stow finished with failures: ${STOW_FAILED}"
  exit 1
fi

success "All configurations stowed successfully"
