---
name: 1password
description: Fetch secrets and create/manage 1Password items via CLI. Use when needing API keys, tokens, or credentials, or when storing new secrets. Ask user for the 1Password secret reference (op://Vault/Item/field format) rather than the actual secret.
---

# 1Password CLI

Use the 1Password CLI (`op`) to fetch and manage secrets without exposing them in plain text.

## Fetching Secrets

Ask the user for their **1Password secret reference** (right-click field in 1Password → "Copy Secret Reference"):

```bash
# Read a secret value
op read "op://Vault/Item/field"

# Use in a command (secret never shown in shell history)
some-cli --token "$(op read 'op://Vault/Item/api-key')"

# Use as environment variable
export API_KEY="$(op read 'op://Vault/Item/api-key')"
```

### Common Patterns

```bash
# CLI auth
toggl auth "$(op read 'op://Employee/Toggl/api key')"
gh auth login --with-token < <(op read 'op://Personal/GitHub/token')

# Docker login
docker login -u $(op read op://Vault/Docker/username) -p $(op read op://Vault/Docker/password)
```

### Reference Format

```
op://vault-name/item-name/field-name
op://vault-name/item-name/section-name/field-name
```

Special fields:
```bash
op read "op://Vault/Item/one-time password?attribute=otp"      # TOTP
op read "op://Vault/Item/private key?ssh-format=openssh"        # SSH key
```

## Creating Items

### Field Type Syntax

```bash
"Field Name[text]=value"        # Plain text (visible)
"Field Name[concealed]=value"   # Password/secret (hidden)
"Field Name[url]=https://..."   # Clickable URL
"Field Name[delete]"            # Remove a field
```

Default (no suffix) = concealed. **Always be explicit about field types.**

### Principles

1. **Only conceal actual secrets** — passwords, API keys, tokens. URLs, usernames, client IDs, hostnames, ports, and other non-sensitive identifiers must use `[text]` or `[url]`. If someone would read it aloud in a meeting, it's not a secret.
2. **Use clear, descriptive field names** — Match the source terminology
3. **Include context** — Add account info, notes, and details
4. **Clean up template cruft** — Remove or set default fields from templates

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

### Editing Existing Items

When adding fields to existing items with `op item edit`, the same type rules apply — **always specify the field type explicitly**:

```bash
# WRONG — defaults to concealed, hides the URL and username
op item edit "My Item" "Section.URL=https://example.com" "Section.username=admin"

# RIGHT — only the password is concealed
op item edit "My Item" "Section.URL[url]=https://example.com" "Section.username[text]=admin" "Section.password[concealed]=secret"
```

### Handling Template Fields

Some categories add default fields like `valid from` and `expires` set to epoch 0.

```bash
# Delete if not applicable
op item edit "Item Name" --vault="VaultName" "valid from[delete]" "expires[delete]"

# Set if applicable
op item edit "Item Name" --vault="VaultName" "valid from=2026-01-27" "expires=2027-01-27"
```

### Field Naming

| Bad | Good |
|-----|------|
| `credential` | `Client ID` |
| `token_uri` | `Token Request URL` |
| `secret` | `Client Secret` or `API Key` |

Match the terminology from the service's docs.

## Prerequisites

- 1Password app installed with CLI integration enabled
- User signed in (`op signin` if not authenticated)
- Check vaults: `op vault list`
- Docs: https://developer.1password.com/docs/cli
