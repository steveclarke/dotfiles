---
name: evening-briefing
description: Generate and print a nightly CTO briefing for Steve's bath reading. Summarizes the day's work, decisions, bookmarks, and topics of interest into 5-10 concise items. Runs automatically at 8pm via launchd, or invoke manually with /evening-briefing.
---

# Evening Briefing

Generate a printed end-of-day briefing for Steve to read in the bath.

## What It Produces

A 5-10 item briefing covering:
- Key work done today (from journal)
- Decisions and learnings (from memory)
- Interesting bookmarks and articles (from inbox/index)
- Actionable insights and "what this means for you" takeaways
- Anything worth thinking about overnight

## Format

- Title: "Evening Briefing — [date]"
- Numbered items, each with bold heading + 2-3 paragraphs + takeaway
- Concise enough to skim, detailed enough to be useful
- Closing: "Printed for bath reading. Grab your pen."

## Content Sources

| Source | Path |
|--------|------|
| Journal | `~/src/hugo/cto-system/daily/journal/YYYY-MM-DD.md` |
| Memory | `~/src/hugo/memory/YYYY-MM-DD.md` |
| Bookmarks inbox | `~/src/hugo/knowledge/bookmarks/inbox.md` (last 30 lines) |
| Bookmarks index | `~/src/hugo/knowledge/bookmarks/index.md` (last 30 lines) |

## Manual Invocation

When Steve says "evening briefing" or `/evening-briefing`:

1. Read today's journal, memory, and recent bookmarks
2. Generate the briefing as markdown
3. Convert to PDF: `~/.claude/skills/md-to-pdf/scripts/md-to-pdf.mjs`
4. Print double-sided: `lp -d HP_LaserJet_4001 -o sides=two-sided-long-edge`

## Automated Schedule

**Launchd job:** `com.hugo.evening-briefing` runs at 8:00 PM daily.

Script: `~/.claude/skills/evening-briefing/scripts/generate-briefing.sh`
Log: `/tmp/evening-briefing.log`
Output: `/tmp/evening-briefing-YYYY-MM-DD.md` and `.pdf`

**Cost:** ~$0.30-0.50/day (~$10-15/month) via Anthropic API.

### Troubleshooting

```bash
# Check log
cat /tmp/evening-briefing.log

# Run manually
~/.claude/skills/evening-briefing/scripts/generate-briefing.sh

# Check launchd status
launchctl list | grep evening

# Reload after plist changes
launchctl unload ~/Library/LaunchAgents/com.hugo.evening-briefing.plist
launchctl load ~/Library/LaunchAgents/com.hugo.evening-briefing.plist
```
