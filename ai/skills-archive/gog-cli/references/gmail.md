# Gmail Commands

## Search & Read

```bash
# Search threads
gog gmail search 'newer_than:7d' --max 10
gog gmail search 'from:boss@example.com subject:urgent' --max 5

# View thread
gog gmail thread get <threadId>
gog gmail thread get <threadId> --download  # save attachments

# Get specific message
gog gmail get <messageId>

# Get attachment
gog gmail attachment <messageId> <attachmentId>

# Get Gmail web link
gog gmail url <threadId>
```

## Compose & Send

```bash
# Send email
gog gmail send --to a@b.com --subject "Hi" --body "Text"
gog gmail send --to a@b.com --subject "Hi" --body-file ./message.txt
gog gmail send --to a@b.com --subject "Hi" --body "Text" --track  # open tracking

# Drafts
gog gmail drafts list
gog gmail drafts create --subject "Draft" --body "Body"
gog gmail drafts send <draftId>
```

## Labels

```bash
gog gmail labels list
gog gmail labels create "My Label"
gog gmail labels update <labelId> --name "New Name"
gog gmail labels delete <labelId>
```

## Batch Operations

```bash
# Mark as read
gog gmail batch mark-read --query 'older_than:30d'

# Delete messages
gog gmail batch delete --query 'from:spam@example.com'

# Apply labels
gog gmail batch label --query 'from:boss@example.com' --add-labels IMPORTANT
```

## Filters & Settings

```bash
# Filters
gog gmail filters list
gog gmail filters create --from 'noreply@example.com' --label 'Notifications'

# Vacation responder
gog gmail vacation enable --subject "Out of office" --message "..."

# Forwarding
gog gmail forwarding add --email forward@example.com

# Delegation
gog gmail delegates add --email delegate@example.com
```

## Watch/History

```bash
# Pub/Sub push notifications
gog gmail watch start --topic projects/<p>/topics/<t> --label INBOX

# Change history
gog gmail history --since <historyId>
```

## Search Syntax

Gmail search uses Google's search operators:

| Operator | Example |
|----------|---------|
| `from:` | `from:user@example.com` |
| `to:` | `to:team@company.com` |
| `subject:` | `subject:meeting` |
| `newer_than:` | `newer_than:7d` |
| `older_than:` | `older_than:30d` |
| `has:attachment` | `has:attachment` |
| `is:unread` | `is:unread` |
| `label:` | `label:important` |
| `in:` | `in:inbox`, `in:sent` |
