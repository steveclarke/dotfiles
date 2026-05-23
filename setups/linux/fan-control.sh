source "${HOME}"/.dotfilesrc

# Fan control for MSI MAG B650 TOMAHAWK WIFI (Nuvoton NCT6687D chip).
#
# The in-kernel `nct6683` driver only supports read access on MSI boards.
# The out-of-tree `nct6687d-dkms-git` driver adds read/write PWM control so
# fancontrol can actually manage the fans.
#
# Config runs both case fans (System Fan #1 and #2 headers = pwm3 + pwm4) in
# zero-RPM mode below 55°C system temp. Fans stay fully off during normal desk
# work and only spin up under sustained load (games, compiles, hot weather).
#
# References:
# - https://github.com/Fred78290/nct6687d
# - https://wiki.archlinux.org/title/Fan_speed_control

set -e

# --- Hardware sanity check -------------------------------------------------
board=$(cat /sys/class/dmi/id/board_name 2>/dev/null || echo "unknown")
if [[ "$board" != *"B650 TOMAHAWK"* ]]; then
  echo "WARNING: this script is tuned for MSI MAG B650 TOMAHAWK WIFI."
  echo "Detected board: $board"
  echo "The fancontrol config (pwm channels, hwmon paths) may not match your hardware."
  read -p "Continue anyway? [y/N] " -n 1 -r; echo
  [[ $REPLY =~ ^[Yy]$ ]] || exit 1
fi

# --- Packages --------------------------------------------------------------
pacman -Q linux-headers >/dev/null 2>&1 || omarchy-pkg-add linux-headers
pacman -Q nct6687d-dkms-git >/dev/null 2>&1 || omarchy-pkg-aur-add nct6687d-dkms-git

# --- Module configuration --------------------------------------------------
echo "nct6687" | sudo tee /etc/modules-load.d/nct6687.conf >/dev/null
echo "blacklist nct6683" | sudo tee /etc/modprobe.d/blacklist-nct6683.conf >/dev/null

# Swap the read-only driver for the writable one if needed
lsmod | grep -q '^nct6683 ' && sudo modprobe -r nct6683 || true
lsmod | grep -q '^nct6687 ' || sudo modprobe nct6687

# --- Locate the current hwmon path -----------------------------------------
# hwmon numbers are assigned at probe time and can shift between reboots, so
# fancontrol needs a DEVPATH relative to /sys/devices that it can re-resolve.
hwmon_dir=""
for h in /sys/class/hwmon/hwmon*; do
  [[ "$(cat "$h/name" 2>/dev/null)" == "nct6687" ]] && hwmon_dir="$h" && break
done
if [[ -z "$hwmon_dir" ]]; then
  echo "ERROR: nct6687 hwmon entry not found after loading module." >&2
  exit 1
fi
hwmon_name="$(basename "$hwmon_dir")"
devpath="$(readlink -f "$hwmon_dir" | sed 's|^/sys/||; s|/hwmon/hwmon[0-9]*$||')"

# --- Write fancontrol config -----------------------------------------------
sudo tee /etc/fancontrol >/dev/null <<EOF
# MSI MAG B650 TOMAHAWK WIFI — case fans zero-RPM below 55°C.
# Managed by dotfiles/setups/linux/fan-control.sh — re-run to regenerate.
INTERVAL=10
DEVPATH=${hwmon_name}=${devpath}
DEVNAME=${hwmon_name}=nct6687
FCTEMPS=${hwmon_name}/pwm3=${hwmon_name}/temp2_input ${hwmon_name}/pwm4=${hwmon_name}/temp2_input
FCFANS=${hwmon_name}/pwm3=${hwmon_name}/fan3_input ${hwmon_name}/pwm4=${hwmon_name}/fan4_input
MINTEMP=${hwmon_name}/pwm3=55 ${hwmon_name}/pwm4=55
MAXTEMP=${hwmon_name}/pwm3=75 ${hwmon_name}/pwm4=75
MINSTART=${hwmon_name}/pwm3=100 ${hwmon_name}/pwm4=100
MINSTOP=${hwmon_name}/pwm3=60 ${hwmon_name}/pwm4=60
MINPWM=${hwmon_name}/pwm3=0 ${hwmon_name}/pwm4=0
MAXPWM=${hwmon_name}/pwm3=255 ${hwmon_name}/pwm4=255
EOF

# --- Pre-seed pwm_enable ---------------------------------------------------
# On first boot pwm*_enable reads as a BIOS/auto value (e.g. 99). Fancontrol
# writes `1`, reads back a non-1 value, and aborts. Putting the channels in
# manual mode first sidesteps the transition bug.
for i in 3 4; do
  echo 1 | sudo tee "$hwmon_dir/pwm${i}_enable" >/dev/null
done

# --- Service ---------------------------------------------------------------
sudo systemctl enable --now fancontrol.service

# --- Report ----------------------------------------------------------------
sleep 2
echo
echo "=== fancontrol service ==="
systemctl status fancontrol.service --no-pager -l | head -10
echo
echo "=== current fan state ==="
for i in 3 4; do
  echo "fan${i}: $(cat "$hwmon_dir/fan${i}_input") RPM, pwm=$(cat "$hwmon_dir/pwm${i}"), system_temp=$(($(cat "$hwmon_dir/temp2_input")/1000))°C"
done
