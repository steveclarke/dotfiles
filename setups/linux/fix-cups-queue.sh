#!/usr/bin/env bash
# Replace a broken cups-browsed implicitclass:// queue with a direct
# driverless IPP queue. Symptom: jobs sit in queue, CUPS log shows
# "universal filter failed" / implicitclass backend status 7.
#
# Usage: fix-cups-queue.sh <queue-name> <printer-host-or-ip>
# Example: fix-cups-queue.sh Brother_HL_L3280CDW_series brother-hl-l3280cdw.local

set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $(basename "$0") <queue-name> <printer-host-or-ip>" >&2
  exit 1
fi

queue=$1
host=$2

# cups-browsed races us — it re-creates implicitclass:// queues for any mDNS
# printer it sees, clobbering our permanent queue within seconds. Stop and
# disable it; modern CUPS handles IPP-everywhere directly.
if systemctl is-active --quiet cups-browsed; then
  echo "Stopping cups-browsed (it overwrites permanent queues)"
  sudo systemctl disable --now cups-browsed
fi

echo "Cancelling any pending jobs on $queue"
cancel -a "$queue" 2>/dev/null || true

echo "Removing existing queue: $queue"
sudo lpadmin -x "$queue" || true

echo "Recreating $queue -> ipp://$host/ipp/print (driverless)"
sudo lpadmin -p "$queue" -E -v "ipp://$host/ipp/print" -m everywhere

cupsenable "$queue"
cupsaccept "$queue"

echo
lpstat -v "$queue"
lpstat -p "$queue"
