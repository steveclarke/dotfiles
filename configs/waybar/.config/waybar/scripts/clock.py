#!/usr/bin/env python3
"""Waybar clock — natural date format with no leading zeros."""
import json
from datetime import datetime

now = datetime.now().astimezone()

text = now.strftime("%A, %B %-d, %-I:%M %p")
tooltip = "\n".join([
    now.strftime("%-d %B W%V %Y"),
    now.strftime("Day %-j of %Y"),
])

print(json.dumps({"text": text, "tooltip": tooltip}))
