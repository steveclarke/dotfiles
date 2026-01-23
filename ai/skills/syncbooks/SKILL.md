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
scripts/syncbooks sync -q

# Quick status check (reads from spreadsheet)
scripts/syncbooks status

# Live status (fetches fresh data from FreeAgent)
scripts/syncbooks status --live
```

One command syncs everything. Zero 1Password prompts after initial setup.

## What Gets Synced

The `sync` command updates these cells in the Cash On-hand spreadsheet:

| Cell | Field | Source |
|------|-------|--------|
| E2 | HST Collected | Invoices + bank income transactions |
| E3 | HST Reclaimed | Bills + expenses + bank expense transactions |
| E6 | Available COH | Total balance across all bank accounts |
| E9 | FA Invoices | Open + overdue invoices |
| B4 | Outstanding Bills | Open + overdue bills |

HST is calculated from the configured period start date through today.

## First-Time Setup

### 1. Cache credentials from 1Password

```bash
scripts/syncbooks setup
```

This fetches and caches these 1Password items:
- `FreeAgent API - SyncBooks` (client ID, secret)
- `Google Sheets API - SyncBooks` (client ID, secret, spreadsheet IDs)
- `WHMCS API - SyncBooks Daily Accounting` (API URL, identifier, secret)

### 2. Authenticate OAuth services

```bash
scripts/syncbooks auth fa      # FreeAgent (opens browser)
scripts/syncbooks auth sheets  # Google Sheets (opens browser)
```

### 3. WHMCS IP Whitelisting

WHMCS requires your IP to be whitelisted:
1. Go to WHMCS Admin → System Settings → General Settings → Security
2. Add your IP to "API IP Access Restriction"
3. Test with `scripts/syncbooks whmcs test`

## Command Aliases

Short aliases for faster typing:

| Alias | Expands To | Example |
|-------|------------|---------|
| `sh` | `sheets` | `syncbooks sh summary` |
| `wh` | `whmcs` | `syncbooks wh transactions` |
| `fa` | FreeAgent commands | `syncbooks fa balance` |

## HST Period Management

```bash
# Show current period
scripts/syncbooks hst-status

# Set period start (e.g., beginning of quarter)
scripts/syncbooks hst-set 2025-10-01

# After remitting quarterly HST, advance to next quarter
scripts/syncbooks hst-paid
```

## Command Reference

### Top-Level Commands

| Command | Description | Options |
|---------|-------------|---------|
| `sync` | Sync all data to Google Sheets | `-q` quiet, `--dev` use dev spreadsheet |
| `status` | Quick financial position check | `--live` fetch fresh data |
| `setup` | Cache 1Password credentials | `--refresh` force re-fetch |
| `balance` | Show bank account totals | |
| `hst` | HST report for current period | `--from DATE`, `--to DATE` |
| `hst-status` | Show HST period config | |
| `hst-set DATE` | Set HST period start | |
| `hst-paid` | Advance to next HST quarter | `--confirm` skip prompt |
| `invoices` | List invoices | `--view` (recent/open/overdue/draft), `--json` |
| `invoice ID` | Show invoice details | |
| `contacts` | List contacts | `--view` (active/all/clients/suppliers), `--json` |
| `contact ID` | Show contact details | |
| `create-invoice` | Create new invoice | See below |
| `create-contact` | Create new contact | See below |
| `company` | Show company info | |
| `projects` | List projects | `--contact ID` filter by contact |

### Create Invoice Options

```bash
scripts/syncbooks create-invoice \
  --contact "Client Name"    # or contact ID
  --description "Services"   # line item description
  --price 1000               # price per unit
  --quantity 1               # default: 1
  --tax-rate 15              # default: 15 (HST)
  --due-days 30              # default: 30
  --date 2025-01-15          # default: today
  --item-type Services       # Hours, Days, Services, Products
  --send                     # mark as sent (default: draft)
```

### Create Contact Options

```bash
scripts/syncbooks create-contact \
  --organisation "Company Name"  # OR use --first-name/--last-name
  --email "billing@example.com"
  --phone "555-1234"
  --address "123 Main St"
  --town "Toronto"
  --region "Ontario"
  --postcode "M5V 1A1"
  --country "Canada"             # default: Canada
  --payment-terms 30             # default: 30
```

### Auth Subcommands

| Command | Description |
|---------|-------------|
| `auth fa` | FreeAgent OAuth authentication |
| `auth sheets` | Google Sheets OAuth authentication |

### Sheets Subcommands (`sheets` or `sh`)

| Command | Description |
|---------|-------------|
| `sh info` | Show spreadsheet metadata |
| `sh summary` | Show cash position summary (formatted) |
| `sh read RANGE` | Read cells (e.g., "Main!E2:E10") |
| `sh write RANGE VALUE` | Write to cell (requires `--force` for production) |
| `sh update:coh` | Update only Available Cash On Hand |
| `sh update:hst` | Update only HST Collected/Reclaimed |
| `sh update:receivables` | Update only FA Invoices |
| `sh update:bills` | Update only Outstanding Bills |
| `sh update:all` | Update all metrics (same as sync) |

All sheets commands support `--dev` to use the dev spreadsheet.

### WHMCS Subcommands (`whmcs` or `wh`)

WHMCS integration is **read-only** - for viewing Sevenview Hosting billing data.

| Command | Description | Options |
|---------|-------------|---------|
| `wh transactions` | List recent transactions | `--limit N` (default: 25), `--json` |
| `wh invoices` | List invoices | `--status` (Paid/Unpaid/Cancelled), `--limit N`, `--json` |
| `wh invoice ID` | Show invoice details | |
| `wh clients` | List clients | `--search TEXT`, `--limit N`, `--json` |
| `wh client ID` | Show client details | |
| `wh test` | Test API connection | |

### FreeAgent Alias (`fa`)

The `fa` subcommand provides shortcuts to top-level FreeAgent commands:

| Command | Same As |
|---------|---------|
| `fa balance` | `balance` |
| `fa invoices` | `invoices` |
| `fa contacts` | `contacts` |
| `fa hst` | `hst` |
| `fa company` | `company` |
| `fa projects` | `projects` |

## Configuration Files

| File | Purpose |
|------|---------|
| `~/.config/syncbooks/config.json` | Cached credentials, HST period, last sync |
| `~/.local/share/syncbooks/credentials.json` | OAuth tokens (auto-refreshed) |

### Config Contents

```json
{
  "freeagent_client_id": "...",
  "freeagent_client_secret": "...",
  "google_client_id": "...",
  "google_client_secret": "...",
  "spreadsheet_id": "...",
  "spreadsheet_id_dev": "...",
  "whmcs_api_url": "https://...",
  "whmcs_identifier": "...",
  "whmcs_secret": "...",
  "hst_period_start": "2025-01-01",
  "last_sync": "2025-01-23T12:00:00Z"
}
```

## Troubleshooting

### Re-fetch credentials from 1Password

```bash
scripts/syncbooks setup --refresh
```

### Re-authenticate OAuth

```bash
scripts/syncbooks auth fa
scripts/syncbooks auth sheets
```

### WHMCS "Invalid IP" error

Your IP needs to be whitelisted in WHMCS Admin → System Settings → General Settings → Security → API IP Access Restriction.

### Token refresh failed

OAuth tokens auto-refresh, but if they become invalid:
1. Delete `~/.local/share/syncbooks/credentials.json`
2. Re-run `scripts/syncbooks auth fa` or `auth sheets`

## Notes

- Contact names are matched case-insensitively when creating invoices
- Invoices are created as Draft by default; use `--send` to mark as sent
- Default currency is CAD, default tax rate is 15% (HST)
- All table outputs support `--json` for machine-readable output
- Sheets write operations require `--force` for production spreadsheet (safety check)
- WHMCS integration is read-only (no posting transactions to FreeAgent yet)
