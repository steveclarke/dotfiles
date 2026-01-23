---
name: syncbooks
description: Daily accounting reconciliation with FreeAgent and Google Sheets. Use when user asks about invoices, contacts, accounting, FreeAgent, cash position, HST report, Google Sheets, spreadsheet updates, or financial reconciliation. Triggers on "syncbooks", "freeagent", "invoice", "contact", "accounting", "reconciliation", "cash position", "HST", "spreadsheet", "sheets", "sync my accounting".
---

# SyncBooks

Daily accounting sync between FreeAgent and Google Sheets.

## Daily Use

```bash
# Sync all FreeAgent data to your Cash On-hand spreadsheet
scripts/freeagent sync

# Quiet mode (minimal output)
scripts/freeagent sync --quiet
```

One command syncs everything. Zero 1Password prompts after initial setup.

## What Gets Synced

| Cell | Field | Source |
|------|-------|--------|
| E2 | HST Collected | Invoices + bank income transactions |
| E3 | HST Reclaimed | Bills + expenses + bank expense transactions |
| E6 | Available COH | Total balance across all bank accounts |
| E9 | FA Invoices | Open + overdue invoices |
| B4 | Outstanding Bills | Open + overdue bills |

HST is calculated from the configured period start date through today.

## First-Time Setup

Run once to cache credentials from 1Password:

```bash
scripts/freeagent setup
```

This stores client IDs, secrets, and spreadsheet IDs in config so daily syncs don't prompt for 1Password.

Then authenticate with each service (opens browser for OAuth):

```bash
scripts/freeagent auth   # FreeAgent OAuth
scripts/sheets auth      # Google Sheets OAuth
```

## HST Period Management

```bash
# Show current period
scripts/freeagent hst-status

# Set period start (e.g., beginning of quarter)
scripts/freeagent hst-set 2025-10-01

# After remitting quarterly HST, advance to next quarter
scripts/freeagent hst-paid
```

## View Data (Without Syncing)

```bash
# Bank account balances
scripts/freeagent balance

# HST report with breakdown
scripts/freeagent hst

# Spreadsheet summary
scripts/sheets summary

# Open invoices
scripts/freeagent invoices --view open
```

## Reference: All Commands

### FreeAgent

| Command | Description |
|---------|-------------|
| `sync` | Sync all data to Google Sheets |
| `setup` | Cache 1Password credentials (run once) |
| `auth` | OAuth authentication |
| `balance` | Show bank account totals |
| `hst` | HST report for current period |
| `hst-status` | Show HST period config |
| `hst-set DATE` | Set HST period start |
| `hst-paid` | Advance to next HST quarter |
| `invoices` | List invoices (--view: recent, open, overdue, draft) |
| `invoice ID` | Show invoice details |
| `contacts` | List contacts |
| `contact ID` | Show contact details |
| `create-invoice` | Create new invoice |
| `create-contact` | Create new contact |

### Google Sheets

| Command | Description |
|---------|-------------|
| `auth` | OAuth authentication |
| `info` | Show spreadsheet metadata |
| `summary` | Show cash position summary |
| `read RANGE` | Read cells (e.g., "Main!E2:E10") |
| `write RANGE VALUE` | Write to cell (requires --force for production) |

## Configuration Files

| File | Purpose |
|------|---------|
| `~/.config/syncbooks/config.json` | Cached credentials, HST period, last sync |
| `~/.local/share/syncbooks/credentials.json` | OAuth tokens (auto-refreshed) |

## Refreshing Credentials

```bash
# Re-fetch from 1Password (if credentials changed)
scripts/freeagent setup --refresh

# Re-authenticate OAuth (if tokens invalid)
scripts/freeagent auth
scripts/sheets auth
```

## Notes

- Contact names are matched case-insensitively
- Invoices are created as Draft by default; use `--send` to mark as sent
- Default currency is CAD, default tax rate is 15% (HST)
- Run `scripts/freeagent --help` for full command usage
