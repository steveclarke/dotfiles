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
