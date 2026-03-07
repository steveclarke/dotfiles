---
name: obsidian-vault-context
description: Works with the local Obsidian vault using direct file operations. Knows folder structure, daily note format (YYYY-MM-DD.md), and research capture templates. Use when reading/writing Obsidian notes or capturing research. Triggers on "obsidian", "daily note", "vault", "capture research".
disable-model-invocation: true
---

# Obsidian Vault Context

## Vault Location
- **Detection:** Run `obsidian-cli print-default` to get the vault path
- Use direct file operations (Read, Write, Edit) — the vault is just a folder of markdown files
- Only use obsidian-cli for UI operations or link updates

## Folder Structure
```
$VAULT_PATH/
├── Daily/              # Daily notes (YYYY-MM-DD.md)
├── AI/                 # AI/LLM research
├── Software Development/
├── Technologies/
├── Work/
├── assets/             # Images and attachments
└── .obsidian/          # Internal config - don't modify
```

## Daily Notes
- **Format:** `YYYY-MM-DD.md` (e.g., `2025-10-18.md`)
- **Location:** `/Daily/` folder
- **No frontmatter** - clean markdown
- **Path:** `$VAULT_PATH/Daily/{YYYY-MM-DD}.md`

## Research Format
Steve captures research in daily notes using this template:

```markdown
### [Tool/Topic Name]
**Link:** [URL]

**What it is:** [Brief description]

**Key Features:**
- Feature 1
- Feature 2

**Why it's interesting:** [Relevance]

**Use case:** [When to use it]
```

## Links & Formatting
- **Internal links:** `[[Note Name]]` (wikilinks)
- **External links:** `[Text](URL)` (markdown)
- **Images:** `![[image.png]]` (stored in /assets/)

## Common Operations

**Read daily note:**
Use the Read tool with path `$VAULT_PATH/Daily/2025-10-18.md`

**Append to daily note:**
Read the existing file first, then use the Edit tool to append new content at the end. Add `\n\n` spacing before the new section.

**Create new note:**
Use the Write tool to create `$VAULT_PATH/Topic/Note.md` with the desired content.

## obsidian-cli (Use Sparingly)
- `obsidian-cli print-default` - Get vault path
- `obsidian-cli open "Note"` - Open in Obsidian UI
- `obsidian-cli move "Old" "New"` - Rename with link updates

Prefer direct file operations over obsidian-cli for reading/writing.

## Best Practices
- Check if file exists before appending
- Add `\n\n` spacing between sections
- Use YYYY-MM-DD format for daily notes
- Don't modify `.obsidian/` folder
- Preserve existing frontmatter if present
