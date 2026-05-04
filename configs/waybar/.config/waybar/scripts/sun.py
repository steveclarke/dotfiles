#!/usr/bin/env python3
"""Sunrise/sunset waybar widget.

Outputs JSON for a waybar custom module: shows the next sun event (rise or set)
with a Nerd Font glyph, and a tooltip with first/last light, day length, and the
delta vs yesterday's day length.

Location defaults to Springdale, NL. Override via env vars SUN_LAT and SUN_LON.

Algorithm: "Almanac for Computers" (USNO), accurate to ~1 minute.
"""
import json
import math
import os
from datetime import date, datetime, timedelta, timezone

LAT = float(os.environ.get("SUN_LAT", "49.4933"))
LON = float(os.environ.get("SUN_LON", "-56.0689"))  # east positive
LOCATION = os.environ.get("SUN_LOCATION", "Springdale, NL")

ZENITH_OFFICIAL = 90.833
ZENITH_CIVIL = 96.0


def _event_utc(d, lat, lon, zenith, rising):
    """Return a UTC datetime for the rise (rising=True) or set event on date d.
    Returns None for polar cases where no event occurs.
    """
    n = (d - date(d.year, 1, 1)).days + 1
    lng_hour = lon / 15.0  # east positive
    t = n + ((6 if rising else 18) - lng_hour) / 24.0

    m = (0.9856 * t) - 3.289
    l = (m + 1.916 * math.sin(math.radians(m))
         + 0.020 * math.sin(math.radians(2 * m))
         + 282.634) % 360.0

    ra = math.degrees(math.atan(0.91764 * math.tan(math.radians(l)))) % 360.0
    l_quad = math.floor(l / 90.0) * 90.0
    ra_quad = math.floor(ra / 90.0) * 90.0
    ra = (ra + (l_quad - ra_quad)) / 15.0

    sin_dec = 0.39782 * math.sin(math.radians(l))
    cos_dec = math.cos(math.asin(sin_dec))
    cos_h = ((math.cos(math.radians(zenith)) - sin_dec * math.sin(math.radians(lat)))
             / (cos_dec * math.cos(math.radians(lat))))
    if cos_h > 1.0 or cos_h < -1.0:
        return None
    if rising:
        h = 360.0 - math.degrees(math.acos(cos_h))
    else:
        h = math.degrees(math.acos(cos_h))
    h /= 15.0

    t_local = h + ra - (0.06571 * t) - 6.622
    ut = (t_local - lng_hour) % 24.0

    hours = int(ut)
    minutes_full = (ut - hours) * 60.0
    minutes = int(minutes_full)
    seconds = int(round((minutes_full - minutes) * 60.0))
    if seconds == 60:
        seconds = 0
        minutes += 1
    if minutes == 60:
        minutes = 0
        hours = (hours + 1) % 24
    return datetime(d.year, d.month, d.day, hours, minutes, seconds, tzinfo=timezone.utc)


def sun_events(d, lat, lon):
    return {
        "dawn": _event_utc(d, lat, lon, ZENITH_CIVIL, rising=True),
        "sunrise": _event_utc(d, lat, lon, ZENITH_OFFICIAL, rising=True),
        "sunset": _event_utc(d, lat, lon, ZENITH_OFFICIAL, rising=False),
        "dusk": _event_utc(d, lat, lon, ZENITH_CIVIL, rising=False),
    }


def to_local(dt):
    return dt.astimezone() if dt else None


def fmt_time(dt):
    return dt.strftime("%-I:%M %p") if dt else "—"


def fmt_delta(td):
    secs = int(round(td.total_seconds()))
    sign = "+" if secs >= 0 else "-"
    secs = abs(secs)
    return f"{sign}{secs // 60}m {secs % 60}s"


def fmt_duration(td):
    secs = int(td.total_seconds())
    return f"{secs // 3600}h {(secs % 3600) // 60}m"


def main():
    now = datetime.now().astimezone()
    today = now.date()

    today_ev = {k: to_local(v) for k, v in sun_events(today, LAT, LON).items()}
    yest_ev = {k: to_local(v) for k, v in sun_events(today - timedelta(days=1), LAT, LON).items()}
    tomo_ev = {k: to_local(v) for k, v in sun_events(today + timedelta(days=1), LAT, LON).items()}

    if today_ev["sunrise"] and now < today_ev["sunrise"]:
        next_time, alt = today_ev["sunrise"], "sunrise"
    elif today_ev["sunset"] and now < today_ev["sunset"]:
        next_time, alt = today_ev["sunset"], "sunset"
    else:
        next_time, alt = tomo_ev["sunrise"], "sunrise"

    # Nerd Font Material Design glyphs
    icons = {"sunrise": chr(0xF059C), "sunset": chr(0xF059B)}
    text = f"{icons[alt]} {fmt_time(next_time)}"

    today_len = today_ev["sunset"] - today_ev["sunrise"] if today_ev["sunrise"] and today_ev["sunset"] else timedelta()
    yest_len = yest_ev["sunset"] - yest_ev["sunrise"] if yest_ev["sunrise"] and yest_ev["sunset"] else timedelta()
    delta = today_len - yest_len

    tooltip = "\n".join([
        f"<b>{LOCATION}</b>",
        "",
        f"First Light:  {fmt_time(today_ev['dawn'])}",
        f"Sunrise:      {fmt_time(today_ev['sunrise'])}",
        f"Sunset:       {fmt_time(today_ev['sunset'])}",
        f"Last Light:   {fmt_time(today_ev['dusk'])}",
        "",
        f"Day Length:   {fmt_duration(today_len)}",
        f"vs Yesterday: {fmt_delta(delta)}",
    ])

    print(json.dumps({"text": text, "tooltip": tooltip, "alt": alt, "class": alt}))


if __name__ == "__main__":
    main()
