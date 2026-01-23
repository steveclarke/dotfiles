---
name: syncbooks
description: Daily accounting reconciliation with FreeAgent, WHMCS, and Google Sheets. Use when user asks about invoices, contacts, accounting, FreeAgent, WHMCS, cash position, HST report, Google Sheets, spreadsheet updates, or financial reconciliation. Triggers on "syncbooks", "freeagent", "whmcs", "invoice", "contact", "accounting", "reconciliation", "cash position", "HST", "spreadsheet", "sheets", "sync my accounting".
---

# SyncBooks

Daily accounting sync between FreeAgent, WHMCS, and Google Sheets.

## Daily Use

```bash
# Sync all FreeAgent data to your Cash On-hand spreadsheet
scripts/syncbooks sync

# Quiet mode (minimal output)
scripts/syncbooks sync --quiet

# Quick status check (from last sync)
scripts/syncbooks status

# Live status (fetch from FreeAgent)
scripts/syncbooks status --live
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
scripts/syncbooks setup
```

This stores client IDs, secrets, and spreadsheet IDs in config so daily syncs don't prompt for 1Password.

Then authenticate with each service (opens browser for OAuth):

```bash
scripts/syncbooks auth fa      # FreeAgent OAuth
scripts/syncbooks auth sheets  # Google Sheets OAuth
```

## Command Aliases

All service commands have short aliases for faster typing:

| Full Command | Alias | Example |
|--------------|-------|---------|
| `freeagent X` | `fa X` | `scripts/syncbooks fa balance` |
| `sheets X` | `sh X` | `scripts/syncbooks sh summary` |
| `whmcs X` | `wh X` | `scripts/syncbooks wh transactions` |

## HST Period Management

```bash
# Show current period
scripts/syncbooks hst-status

# Set period start (e.g., beginning of quarter)
scripts/syncbooks hst-set 2025-10-01

# After remitting quarterly HST, advance to next quarter
scripts/syncbooks hst-paid
```

## View Data (Without Syncing)

```bash
# Quick status check
scripts/syncbooks status

# Bank account balances
scripts/syncbooks balance

# HST report with breakdown
scripts/syncbooks hst

# Spreadsheet summary
scripts/syncbooks sheets summary

# Open invoices
scripts/syncbooks invoices --view open

# WHMCS transactions
scripts/syncbooks whmcs transactions
```

## Command Reference

### Top-Level Commands

| Command | Description |
|---------|-------------|
| `sync` | Sync all data to Google Sheets |
| `status` | Quick financial position check (--live for fresh data) |
| `setup` | Cache 1Password credentials (run once) |
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
| `company` | Show company info |
| `projects` | List projects |

### Auth Subcommands

| Command | Description |
|---------|-------------|
| `auth fa` | FreeAgent OAuth authentication |
| `auth sheets` | Google Sheets OAuth authentication |

### Sheets Subcommands (`sheets` or `sh`)

| Command | Description |
|---------|-------------|
| `sheets info` | Show spreadsheet metadata |
| `sheets summary` | Show cash position summary |
| `sheets read RANGE` | Read cells (e.g., "Main!E2:E10") |
| `sheets write RANGE VALUE` | Write to cell (requires --force for production) |
| `sheets update:coh` | Update only Available Cash On Hand |
| `sheets update:hst` | Update only HST Collected/Reclaimed |
| `sheets update:receivables` | Update only FA Invoices |
| `sheets update:bills` | Update only Outstanding Bills |
| `sheets update:all` | Update all metrics (same as sync) |

### WHMCS Subcommands (`whmcs` or `wh`)

| Command | Description |
|---------|-------------|
| `whmcs transactions` | List recent transactions |
| `whmcs invoices` | List invoices (--status: Paid, Unpaid, Cancelled) |
| `whmcs invoice ID` | Show invoice details |
| `whmcs clients` | List clients (--search to filter) |
| `whmcs client ID` | Show client details |
| `whmcs test` | Test API connection |

### FreeAgent Alias (`fa`)

| Command | Description |
|---------|-------------|
| `fa balance` | Show bank account totals |
| `fa invoices` | List invoices |
| `fa contacts` | List contacts |
| `fa hst` | HST report |
| `fa company` | Show company info |
| `fa projects` | List projects |

## Configuration Files

| File | Purpose |
|------|---------|
| `~/.config/syncbooks/config.json` | Cached credentials, HST period, last sync |
| `~/.local/share/syncbooks/credentials.json` | OAuth tokens (auto-refreshed) |

## Refreshing Credentials

```bash
# Re-fetch from 1Password (if credentials changed)
scripts/syncbooks setup --refresh

# Re-authenticate OAuth (if tokens invalid)
scripts/syncbooks auth fa
scripts/syncbooks auth sheets
```

## Notes

- Contact names are matched case-insensitively
- Invoices are created as Draft by default; use `--send` to mark as sent
- Default currency is CAD, default tax rate is 15% (HST)
- All table outputs support `--json` for machine-readable output
- Run `scripts/syncbooks --help` for full command usage
