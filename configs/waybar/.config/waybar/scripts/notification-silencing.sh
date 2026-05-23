#!/bin/bash
# Always-visible notification silencing indicator.
# Shows normal bell when notifications are on, slashed red bell when silenced.
# Click toggles state via omarchy-toggle-notification-silencing.

if makoctl mode 2>/dev/null | grep -q 'do-not-disturb'; then
  echo '{"text": "󰂛", "tooltip": "Notifications silenced (click to enable)", "class": "silenced"}'
else
  echo '{"text": "󰂚", "tooltip": "Notifications on (click to silence)", "class": "on"}'
fi
