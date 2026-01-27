---
name: 1password-items
description: Create and manage 1Password items via CLI with proper field types, naming, and structure. Use when storing API credentials, secrets, or any structured data in 1Password.
---

# Creating 1Password Items via CLI

## Core Principles

1. **Only conceal actual secrets** — Client IDs, URLs, usernames are NOT secrets
2. **Use clear, descriptive field names** — Don't abbreviate; match the source terminology
3. **Include context** — Add account info, notes, and any details that explain what this is for
4. **Clean up template cruft** — Remove or properly set default fields from templates

## Field Type Syntax

Use suffixes to control field types:

```bash
"Field Name[text]=value"        # Plain text (visible)
"Field Name[concealed]=value"   # Password/secret (hidden)
"Field Name[url]=https://..."   # Clickable URL
"Field Name[delete]"            # Remove a field
```

Default (no suffix) = concealed. Always be explicit.

## Common Item Types

### OAuth API Credential

```bash
op item create --category="API Credential" --title="Service Name - App Name" --vault="VaultName" \
  "Client ID[text]=ABC123" \
  "Client Secret[concealed]=secret-value-here" \
  "Account[text]=user@example.com" \
  "Redirect URL[text]=http://localhost:8080" \
  "Authorization URL[text]=https://service.com/oauth2/authorize" \
  "Token Request URL[text]=https://api.service.com/oauth2/token" \
  "Developer Portal[url]=https://developer.service.com" \
  "notesPlain=Context about this credential and any gotchas."
```

### Simple API Key

```bash
op item create --category="API Credential" --title="Service Name API" --vault="VaultName" \
  "API Key[concealed]=sk-xxxxxxxxxxxx" \
  "Account[text]=user@example.com" \
  "Documentation[url]=https://docs.service.com/api" \
  "notesPlain=Used for X purpose. Rate limit: 1000/day."
```

### Database Credential

```bash
op item create --category="Database" --title="Production DB - ServiceName" --vault="VaultName" \
  "type[text]=postgresql" \
  "server[text]=db.example.com" \
  "port[text]=5432" \
  "database[text]=myapp_production" \
  "username[text]=app_user" \
  "password[concealed]=secret-password" \
  "notesPlain=Read replica. Primary is on port 5433."
```

### Server/SSH

```bash
op item create --category="Server" --title="Server Name" --vault="VaultName" \
  "URL[url]=https://server.example.com" \
  "username[text]=admin" \
  "password[concealed]=secret-password" \
  "Admin URL[url]=https://server.example.com/admin" \
  "notesPlain=Purpose and access notes."
```

## Handling Template Fields

Some categories (like "API Credential") add default fields like `valid from` and `expires` set to epoch 0 (shows as Dec 31, 1969).

**If not applicable:** Delete them after creation:
```bash
op item edit "Item Name" --vault="VaultName" "valid from[delete]" "expires[delete]"
```

**If applicable:** Set valid dates (YYYY-MM-DD format):
```bash
op item edit "Item Name" --vault="VaultName" "valid from=2026-01-27" "expires=2027-01-27"
```

## Field Naming Guidelines

| Bad | Good |
|-----|------|
| `credential` | `Client ID` |
| `token_uri` | `Token Request URL` |
| `auth_url` | `Authorization URL` |
| `secret` | `Client Secret` or `API Key` (be specific) |

Match the terminology from the service's documentation or portal.

## Adding Context

**Account association:** When a credential is tied to a specific account, add an explicit field:
```bash
"Account[text]=user@example.com"
```

**Notes:** Use `notesPlain` for markdown notes explaining:
- What this credential is for
- Why a particular account was used (especially if non-obvious)
- Any gotchas, limitations, or rate limits
- Links to relevant documentation

## Available Vaults

Check available vaults first:
```bash
op vault list
```

## Verification

After creating an item, verify in the 1Password UI:
- Only actual secrets are concealed
- Field names are clear and match source terminology
- No stale template fields (or they have valid dates if applicable)
- Context/notes are present if needed
