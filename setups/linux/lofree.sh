source "${HOME}"/.dotfilesrc

# The Lofree keyboard I'm using has a quirk when in Windows mode such that the
# function keys don't work. They only work as media keys.  The solution seems to
# be to switch to Mac mode, but that causes the Alt and Windows keys to be
# swapped. This script swaps them back.

# References:
# https://www.reddit.com/r/Lofree/comments/16vg1qa/lofree_flow_good_with_some_issues/
# https://github.com/alexeygumirov/lofree-flow-fn-fix

# Note: Ensure the keyboard is in Mac mode (fn+M)

# Value 1: Media controls
# Value 2: Function keys
echo 1 | sudo tee /sys/module/hid_apple/parameters/fnmode

echo 1 | sudo tee /sys/module/hid_apple/parameters/swap_opt_cmd

# Configure the system to run this script on startup
# service_file="/etc/systemd/system/lofree.service"

# if [ ! -f "$service_file" ]; then

#   cat <<EOL | sudo tee  "$service_file"
# [Unit]
# Description=Swap Lofree keyboard keys

# [Service]
# ExecStart=${DOTFILES_DIR}/setups/lofree.sh
# Type=oneshot
# RemainAfterExit=true

# [Install]
# WantedBy=default.target
# EOL

#   # sudo cp "$service_file" /etc/systemd/system/lofree.service
#   sudo systemctl enable lofree
# fi
