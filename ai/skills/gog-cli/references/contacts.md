# Contacts Commands

## Personal Contacts

### View & Search

```bash
# List contacts
gog contacts list --max 50

# Search by name
gog contacts search "Ada" --max 50

# Get by email
gog contacts get user@example.com
```

### Manage Contacts

```bash
# Create contact
gog contacts create \
  --given-name "John" \
  --family-name "Doe" \
  --email "john@example.com" \
  --phone "+1234567890"

# Update contact
gog contacts update people/<resourceName> \
  --given-name "Jane" \
  --email "jane@example.com"

# Delete contact
gog contacts delete people/<resourceName>
```

## Other Contacts

```bash
# People you've interacted with (auto-saved)
gog contacts other list --max 50
```

## Directory (Workspace Only)

```bash
# Search organization directory
gog contacts directory list --max 50
```

## People & Groups

### Profile

```bash
# View your profile
gog people me

# Search directory
gog people search "Ada Lovelace" --max 5
```

### Groups (Workspace Only)

```bash
# List groups you belong to
gog groups list

# List members of a group
gog groups members engineering@company.com
```

## Notes

- Resource names look like `people/c123456789`
- Directory search requires Google Workspace account
- Groups require Workspace and Cloud Identity API enabled
