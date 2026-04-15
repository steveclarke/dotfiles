# Chat Commands

**Note:** Requires Google Workspace account.

## Spaces

```bash
# List spaces
gog chat spaces list

# Search spaces
gog chat spaces find "Engineering"

# Create space with members
gog chat spaces create "Engineering" \
  --member alice@company.com \
  --member bob@company.com
```

## Messages

### Read

```bash
# List messages in a space
gog chat messages list spaces/<spaceId> --max 5
```

### Send

```bash
# Send to space
gog chat messages send spaces/<spaceId> --text "Build complete!"

# Direct message
gog chat dm send user@company.com --text "ping"
```

## Space ID Format

Space IDs follow the format: `spaces/AAAABBBB`

Find space IDs by:
1. Using `gog chat spaces list`
2. From the Google Chat URL when in a space

## Tips

- Chat API requires Workspace account
- DMs create a 1:1 space if one doesn't exist
- Messages support basic formatting in text
