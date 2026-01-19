# Calendar Commands

## View Events

```bash
# Today's events
gog calendar events <calendarId> --today
gog calendar events primary --today

# This week
gog calendar events <calendarId> --week

# Next N days
gog calendar events <calendarId> --days 3

# Search events
gog calendar search "meeting" --today

# Team availability
gog calendar team <group-email> --today
```

## Create Events

```bash
# Basic event
gog calendar create <calendarId> --summary "Meeting" \
  --from 2025-01-15T10:00:00Z --to 2025-01-15T11:00:00Z

# With attendees and location
gog calendar create <calendarId> --summary "Team Sync" \
  --attendees "alice@example.com,bob@example.com" \
  --location "Zoom"

# Recurring event
gog calendar create <calendarId> --summary "Payment" \
  --rrule "RRULE:FREQ=MONTHLY;BYMONTHDAY=11"
```

## Special Event Types

```bash
# Focus time
gog calendar focus-time --from 2025-01-15T13:00:00Z --to 2025-01-15T14:00:00Z

# Out of office
gog calendar out-of-office --from 2025-01-20 --to 2025-01-21 --all-day

# Working location
gog calendar working-location --type office --office-label "HQ" \
  --from 2025-01-22 --to 2025-01-23
```

## Manage Invitations

```bash
# Accept
gog calendar respond <calendarId> <eventId> --status accepted

# Decline
gog calendar respond <calendarId> <eventId> --status declined

# Propose new time
gog calendar propose-time <calendarId> <eventId>
```

## Availability

```bash
# Check free/busy
gog calendar freebusy --calendars "primary,work@example.com" \
  --from 2025-01-15T00:00:00Z --to 2025-01-16T00:00:00Z

# Detect conflicts
gog calendar conflicts --calendars "primary" --today
```

## Notes

- Use `primary` as calendarId for your main calendar
- Times use ISO 8601 format with timezone (Z = UTC)
- RRULE follows iCalendar recurrence rule format
