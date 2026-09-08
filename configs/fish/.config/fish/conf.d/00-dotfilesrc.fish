# Load ~/.dotfilesrc first so every other conf.d file can read DOTFILES_* vars.
# (conf.d is sourced before config.fish, in name order.)
if test -f ~/.dotfilesrc; and functions -q bass
    bass source ~/.dotfilesrc
end
