#Editor et. al.
set -gx EDITOR (which nvim)
set -gx VISUAL $EDITOR
set -gx SUDO_EDITOR $EDITOR

# Abbrs are in ~/.config/fish/conf.d/abbr.fish

fish_config theme choose "catppuccin-mocha"

# Disable default banner
set fish_greeting 
# alias fish_greeting colortest

# Path
fish_add_path ~/bin

# Exports
set -x LESS -rF # -r: raw control chars, -F: quit if one screen

# Eza (ls replacement)
if command -q eza
  alias ls "eza --color=always --icons --group-directories-first"
  alias la "eza --color=always --icons --group-directories-first --all"
  alias ll "eza --color=always --icons --group-directories-first --all --long"
end

alias ncdu "ncdu --color dark"
