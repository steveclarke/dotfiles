#!/bin/bash
# Evening Briefing Generator
# Runs via launchd at 8pm, generates a CTO briefing and prints it.

set -euo pipefail

# --- Config ---
HUGO_DIR="$HOME/src/hugo"
TODAY=$(date "+%Y-%m-%d")
OUTPUT_MD="/tmp/evening-briefing-${TODAY}.md"
OUTPUT_PDF="/tmp/evening-briefing-${TODAY}.pdf"
MD_TO_PDF="$HOME/.claude/skills/md-to-pdf/scripts/md-to-pdf.mjs"
PRINTER="HP_LaserJet_4001"
LOG="/tmp/evening-briefing.log"
MAX_BUDGET="3.00"

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG"; }

log "Starting evening briefing generation"

# --- Gather context ---
JOURNAL_FILE="${HUGO_DIR}/cto-system/daily/journal/${TODAY}.md"
MEMORY_FILE="${HUGO_DIR}/memory/${TODAY}.md"
BOOKMARKS_INBOX="${HUGO_DIR}/knowledge/bookmarks/inbox.md"
BOOKMARKS_INDEX="${HUGO_DIR}/knowledge/bookmarks/index.md"

CONTEXT=""

if [[ -f "$JOURNAL_FILE" ]]; then
  CONTEXT+="=== TODAY'S JOURNAL (${TODAY}) ===
$(cat "$JOURNAL_FILE")

"
  log "Found journal: $JOURNAL_FILE"
else
  log "No journal found for today"
fi

if [[ -f "$MEMORY_FILE" ]]; then
  CONTEXT+="=== TODAY'S MEMORY (${TODAY}) ===
$(cat "$MEMORY_FILE")

"
  log "Found memory: $MEMORY_FILE"
else
  log "No memory found for today"
fi

if [[ -f "$BOOKMARKS_INBOX" ]]; then
  CONTEXT+="=== RECENT BOOKMARKS (INBOX - last 30 lines) ===
$(tail -30 "$BOOKMARKS_INBOX")

"
fi

if [[ -f "$BOOKMARKS_INDEX" ]]; then
  CONTEXT+="=== RECENT BOOKMARKS (INDEX - last 30 lines) ===
$(tail -30 "$BOOKMARKS_INDEX")

"
fi

if [[ -z "$CONTEXT" ]]; then
  log "No content found for today. Skipping briefing."
  exit 0
fi

# --- Get API key from 1Password ---
export ANTHROPIC_API_KEY
ANTHROPIC_API_KEY=$(op read "op://Employee/Claude \/ Anthropic/API key (crush)" 2>>"$LOG")
if [[ -z "$ANTHROPIC_API_KEY" ]]; then
  log "ERROR: Failed to read API key from 1Password"
  exit 1
fi
log "API key loaded from 1Password"

# --- Generate briefing via claude -p ---
PROMPT="You are Hugo, Steve's CTO coach and executive assistant. Generate an evening briefing for Steve to read in the bath tonight.

Steve is a technical CEO who runs Sevenview Studios. He prefers printed material — short, punchy summaries he can skim with a pen in hand. He has aphantasia (learns conceptually, not visually).

Using the context below, create a briefing with 5-10 numbered items covering:
- Key work done today and why it matters
- Decisions made and their implications
- Interesting bookmarks or articles with key takeaways
- Connections between topics (e.g., how today's work relates to bigger goals)
- Anything worth thinking about overnight

Format:
- Title: \"# Evening Briefing — ${TODAY}\"
- Each item: bold heading, 2-3 short paragraphs, actionable takeaway
- Keep it concise — this is for skimming, not deep reading
- End with: \"---\" and \"*Printed for bath reading. Grab your pen — circle anything you want to dig into tomorrow.*\"

Output ONLY the markdown. No preamble, no explanation.

${CONTEXT}"

log "Calling claude -p (max budget: \$${MAX_BUDGET})"
if ! claude -p --max-budget-usd "$MAX_BUDGET" --no-session-persistence "$PROMPT" > "$OUTPUT_MD" 2>>"$LOG"; then
  log "ERROR: claude -p failed"
  exit 1
fi
log "Briefing generated: $OUTPUT_MD ($(wc -l < "$OUTPUT_MD") lines)"

# --- Convert to PDF ---
if ! "$MD_TO_PDF" "$OUTPUT_MD" "$OUTPUT_PDF" >> "$LOG" 2>&1; then
  log "ERROR: md-to-pdf conversion failed"
  exit 1
fi
log "PDF created: $OUTPUT_PDF"

# --- Print ---
if ! lp -d "$PRINTER" -o sides=two-sided-long-edge "$OUTPUT_PDF" >> "$LOG" 2>&1; then
  log "ERROR: Print failed"
  exit 1
fi
log "Printed to $PRINTER (double-sided)"
log "Evening briefing complete"
