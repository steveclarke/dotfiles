source "${HOME}"/.dotfilesrc

# Enable DDC/CI access for ddcutil so it (and vdu_controls) can drive
# external monitors over I2C without root. Loads the i2c-dev kernel module
# and adds the user to the i2c group.
#
# References:
# - https://www.ddcutil.com/i2c_permissions/

set -e

# Skip silently if ddcutil isn't installed (CLI install runs before setups,
# but a user could disable it).
command -v ddcutil >/dev/null || exit 0

# Persist the module across reboots and load it now.
echo "i2c-dev" | sudo tee /etc/modules-load.d/i2c-dev.conf >/dev/null
sudo modprobe i2c-dev

# Group access to /dev/i2c-*. Membership applies to new logins; for the
# current shell, run via `sg i2c -c '...'`.
sudo groupadd -f i2c
sudo usermod -aG i2c "${USER}"
