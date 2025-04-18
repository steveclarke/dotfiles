# Laravel initialisation from https://laravel.com/docs/12.x
# /bin/bash -c "$(curl -fsSL https://php.new/install/linux/8.4)"
# This script doesnt work with fish, so we need to do it manually
if test -d "/home/steve/.config/herd-lite/bin"
    fish_add_path -p "/home/steve/.config/herd-lite/bin"
    set -x PHP_INI_SCAN_DIR "/home/steve/.config/herd-lite/bin" $PHP_INI_SCAN_DIR
end
