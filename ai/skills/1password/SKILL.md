---
name: 1password
description: "Creates and edits 1Password items with the `op` CLI so field types and names come out right, and reads secrets by reference. Use when storing or changing a credential, API key or login in 1Password, or when a command needs a secret."
---

# 1Password CLI

Ask for the secret reference (`op://vault/item/field`, from "Copy Secret Reference" in 1Password), never the secret, and read it inside the command that needs it: `some-cli --token "$(op read 'op://vault/item/field')"`. TOTP and SSH keys read with `?attribute=otp` and `?ssh-format=openssh`. Never print a secret to the session.

Run the real `op` command and let the 1Password app prompt for sign-in. Over SSH to another Mac, `op` uses that Mac's app (`ssh <mac> 'op ...'`) and the Touch ID prompt appears on that Mac's screen, so use it when the person is at a different Mac from the agent. Where Hugo's docs cover an item or a non-interactive sign-in, they are the source of truth.

## Field types

A field with no type suffix is concealed, so a bare URL or username disappears behind dots. State the type on every field, in `op item create` and in `op item edit`:

```bash
"Field Name[text]=value"        # visible
"Field Name[concealed]=value"   # hidden
"Field Name[url]=https://..."   # clickable
"Field Name[delete]"            # remove
```

Conceal only real secrets: passwords, API keys, tokens. Client IDs, usernames, URLs, hostnames and ports stay `[text]` or `[url]`; if someone would read it aloud in a meeting, it is not a secret.

```bash
# wrong: URL and username become concealed
op item edit "My Item" "Section.URL=https://example.com" "Section.username=admin"
# right
op item edit "My Item" "Section.URL[url]=https://example.com" "Section.username[text]=admin" "Section.password[concealed]=..."
```

## Naming and tidiness

- Name fields as the service's docs do: `Client ID`, `Token Request URL`, `Client Secret` or `API Key`, never `credential`, `token_uri` or `secret`.
- Title items `Service - App` and put the account, the purpose and any rate limit or gotcha in `notesPlain`.
- Template categories add fields such as `valid from` and `expires`, set to epoch 0. Delete them (`"valid from[delete]" "expires[delete]"`) or set real dates.
