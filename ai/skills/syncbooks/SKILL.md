---
name: syncbooks
description: Daily accounting reconciliation with FreeAgent, WHMCS, and Google Sheets. Use when user asks about invoices, contacts, accounting, FreeAgent, WHMCS transactions, cash position, HST report, Google Sheets, spreadsheet updates, or financial reconciliation. Triggers on "syncbooks", "freeagent", "invoice", "contact", "accounting", "reconciliation", "cash position", "HST", "spreadsheet", "sheets".
---

# SyncBooks

CLI scripts for daily accounting tasks. Integrates with FreeAgent, WHMCS, and Google Sheets.

## FreeAgent Commands

Use `scripts/freeagent` for FreeAgent operations.

### Contacts

```bash
# List contacts
scripts/freeagent contacts
scripts/freeagent contacts --view all

# Show contact details
scripts/freeagent contact 12345

# Create contact (organisation)
scripts/freeagent create-contact \
  --organisation "Acme Corp" \
  --email "billing@acme.com" \
  --address "123 Main St" \
  --town "Toronto" \
  --region "Ontario" \
  --postcode "M5V 1A1" \
  --payment-terms 30

# Create contact (individual)
scripts/freeagent create-contact \
  --first-name "John" \
  --last-name "Doe" \
  --email "john@example.com"
```

### Invoices

```bash
# List invoices
scripts/freeagent invoices
scripts/freeagent invoices --view open
scripts/freeagent invoices --view draft

# Show invoice details
scripts/freeagent invoice 12345

# Create invoice
scripts/freeagent create-invoice \
  --contact "Acme Corp" \
  --description "Consulting services - January 2025" \
  --price 2500 \
  --quantity 1 \
  --tax-rate 15 \
  --due-days 30

# Create and send invoice
scripts/freeagent create-invoice \
  --contact 12345 \
  --description "Web development" \
  --price 150 \
  --quantity 8 \
  --item-type Hours \
  --send
```

### Balance & Cash Position

```bash
# Total balance across all bank accounts
scripts/freeagent balance
```

Shows active accounts grouped by type (bank, credit card, PayPal) with totals.

### HST Report

```bash
# Calculate HST from period start to today (default)
scripts/freeagent hst

# Calculate HST for a specific date range
scripts/freeagent hst --from 2025-10-01 --to 2025-12-31

# Show current HST period
scripts/freeagent hst-status

# Set HST period start date
scripts/freeagent hst-set 2025-10-01

# Mark quarter as paid, advance to next quarter
scripts/freeagent hst-paid
```

**HST Period Tracking:**
- Period start is stored in `~/.config/syncbooks/config.json`
- Default: calculates from period start to today
- Use `hst-paid` after remitting quarterly HST to advance the period

Calculates HST by aggregating:
- **HST Charged**: Invoices + bank transactions categorized as income
- **HST Reclaimed**: Bills + expenses + bank transactions categorized as expenses

Output matches FreeAgent's official HST Report (Tax → HST on the web UI).

### Utility

```bash
# Company info
scripts/freeagent company

# List projects
scripts/freeagent projects
scripts/freeagent projects --contact 12345
```

## Google Sheets Commands

Use `scripts/sheets` for Google Sheets operations.

### Read/Write

```bash
# Read cells from spreadsheet
scripts/sheets read "Main!E2:E10"

# Write to a cell (dev spreadsheet only by default)
scripts/sheets write "Main!E2" "1234.56"

# Write to production spreadsheet (use with caution)
scripts/sheets write "Main!E2" "1234.56" --force

# Use a specific spreadsheet ID
scripts/sheets read "Main!A1:B5" -s "spreadsheet-id-here"
```

### Info

```bash
# Show spreadsheet info
scripts/sheets info
```

### Safety

Write operations are blocked for non-dev spreadsheets by default. The script checks if the spreadsheet title contains "(dev)". Use `--force` to bypass this check.

## Authentication

### FreeAgent

```bash
# Initial setup (opens browser for OAuth)
scripts/freeagent auth

# Clear stored credentials
scripts/freeagent auth --clear
```

Client credentials from 1Password (`op://Employee/FreeAgent API - SyncBooks/`).

### Google Sheets

```bash
# Initial setup (opens browser for OAuth)
scripts/sheets auth

# Clear stored credentials
scripts/sheets auth --clear
```

Client credentials from 1Password (`op://Employee/Google Sheets API - SyncBooks/`).

All tokens are stored in `~/.local/share/syncbooks/credentials.json` and auto-refresh when expired.

## Notes

- Contact names are matched case-insensitively
- Invoices are created as Draft by default; use `--send` to mark as sent
- Default currency is CAD, default tax rate is 15% (HST)
- Run `scripts/freeagent --help` for full usage
