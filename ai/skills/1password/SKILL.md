---
name: 1password
description: Fetch secrets securely using 1Password CLI. Use when needing API keys, tokens, passwords, or credentials. Ask user for the 1Password secret reference (op://Vault/Item/field format) rather than the actual secret.
---

# 1Password Secret Management

Use the 1Password CLI (`op`) to securely fetch secrets without exposing them in plain text.

## Core Concept

Instead of hardcoding or asking for raw secrets, ask the user for their **1Password secret reference**. Users get this by:
1. Opening 1Password app
2. Right-clicking the field they want to share
3. Selecting **"Copy Secret Reference"**

This gives a reference like: `op://Vault/Item/field`

## Fetching Secrets

```bash
# Read a secret value
op read "op://Vault/Item/field"

# Use in a command (secret never shown in shell history)
some-cli --token "$(op read 'op://Vault/Item/api-key')"

# Use in environment variable
export API_KEY="$(op read 'op://Vault/Item/api-key')"
```

## Common Patterns

**Authenticating a CLI tool:**
```bash
toggl auth "$(op read 'op://Employee/Toggl/api key')"
gh auth login --with-token < <(op read 'op://Personal/GitHub/token')
```

**Passing to scripts:**
```bash
./deploy.sh --api-key "$(op read 'op://Work/Production/api-key')"
```

**Docker login:**
```bash
docker login -u $(op read op://Vault/Docker/username) -p $(op read op://Vault/Docker/password)
```

## When to Use This Pattern

When you need a secret (API key, token, password, credential), ask:

> "What's the 1Password reference for your [service] API key? You can get it by right-clicking the field in 1Password and selecting 'Copy Secret Reference'."

This keeps secrets:
- Out of chat history
- Out of shell history (when using subshell syntax)
- Out of config files checked into git
- Rotatable without updating scripts

## Reference Format

```
op://vault-name/item-name/field-name
op://vault-name/item-name/section-name/field-name
```

Query parameters for special fields:
```bash
# One-time password (TOTP)
op read "op://Vault/Item/one-time password?attribute=otp"

# SSH key in OpenSSH format
op read "op://Vault/Item/private key?ssh-format=openssh"
```

## Prerequisites

- 1Password app installed with CLI integration enabled
- User signed in to 1Password
- Run `op signin` if not authenticated

For full CLI documentation: https://developer.1password.com/docs/cli
