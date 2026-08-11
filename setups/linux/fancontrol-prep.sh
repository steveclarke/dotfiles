#!/usr/bin/env bash
#
# Re-resolve fancontrol's hwmon index and put the PWM channels in manual mode.
#
# Installed to /usr/local/bin/fancontrol-prep by fan-control.sh and wired in as
# ExecStartPre for fancontrol.service.
#
# Two failure modes this exists to kill:
#
# 1. /etc/fancontrol refers to the chip by hwmon index. Indexes are assigned at
#    probe time and shift whenever the kernel changes device enumeration order,
#    so a kernel upgrade silently points the config at the wrong device and
#    fancontrol aborts with "Device path of hwmonN has changed".
#
# 2. The BIOS leaves pwm*_enable at an auto value (99 on this board). fancontrol
#    writes 1, reads back non-1, and gives up. Pre-seeding manual mode sidesteps
#    that transition bug.
#
# The chip NAME is the stable identifier; the index is not. Trust the name.

set -euo pipefail

CONF=/etc/fancontrol
[[ -f $CONF ]] || exit 0

chip=$(awk -F= '/^DEVNAME=/{print $3; exit}' "$CONF")
old=$(awk -F'[=/]' '/^DEVNAME=/{print $2; exit}' "$CONF")
if [[ -z ${chip:-} || -z ${old:-} ]]; then
  echo "fancontrol-prep: cannot parse DEVNAME from $CONF" >&2
  exit 1
fi

new=""
for h in /sys/class/hwmon/hwmon*; do
  if [[ "$(cat "$h/name" 2>/dev/null)" == "$chip" ]]; then
    new=$(basename "$h")
    break
  fi
done
if [[ -z $new ]]; then
  echo "fancontrol-prep: no hwmon entry named '$chip' - is the module loaded?" >&2
  exit 1
fi

if [[ $new != "$old" ]]; then
  echo "fancontrol-prep: $chip moved $old -> $new, rewriting $CONF"
  # \b keeps hwmon1 from matching inside hwmon10.
  sed -i "s|\b${old}\b|${new}|g" "$CONF"
fi

for pwm in $(grep -oE "${new}/pwm[0-9]+" "$CONF" | sort -u); do
  enable="/sys/class/hwmon/${pwm}_enable"
  if [[ -w $enable ]] && [[ "$(cat "$enable")" != "1" ]]; then
    echo "fancontrol-prep: setting ${pwm}_enable to manual (was $(cat "$enable"))"
    echo 1 >"$enable"
  fi
done
