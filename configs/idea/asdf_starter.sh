#asdf_bin_root=$(dirname $RUBY_VERSION_MANAGER_PATH)
#source "${asdf_bin_root}/../asdf.sh"
#asdf shell ruby $RUBY_VERSION_MANAGER_DISTRIBUTION_ID

# https://youtrack.jetbrains.com/issue/RUBY-27899/Terminal-fails-to-source-chruby.sh-when-using-fish
# https://youtrack.jetbrains.com/issue/RUBY-27517/Terminal-fish-shell-prints-an-error-for-ASDF-startup-script
set asdf_bin_root $(dirname $RUBY_VERSION_MANAGER_PATH)
source $asdf_bin_root/../asdf.fish
asdf shell ruby $RUBY_VERSION_MANAGER_DISTRIBUTION_ID

