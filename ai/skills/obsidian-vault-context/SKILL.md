---
name: obsidian-vault-context
description: Work with Steve's Obsidian vault at /Users/steve/Documents/Main using direct file operations. Knows folder structure, daily note format (YYYY-MM-DD.md), and research capture templates. Use when reading/writing Obsidian notes or capturing research. Triggers on "obsidian", "daily note", "vault", "capture research".
disable-model-invocation: true
---

# Obsidian Vault Context

## Key Concept
Obsidian vaults are just folders of markdown files. Use direct file operations (read_file, write, search_replace) first. Only use obsidian-cli for UI operations or link updates.

## Steve's Vault
- **Path:** `/Users/steve/Documents/Main`
- **Detection:** Try `obsidian-cli print-default` first, then check `/Users/steve/Documents/Main`

## Folder Structure
```
/Users/steve/Documents/Main/
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
- **Path:** `/Users/steve/Documents/Main/Daily/{YYYY-MM-DD}.md`

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
```python
read_file("/Users/steve/Documents/Main/Daily/2025-10-18.md")
```

**Append to daily note:**
```python
existing = read_file(daily_path)
updated = existing + "\n\n### New Entry\n**Link:** ...\n"
write(daily_path, updated)
```

**Create new note:**
```python
write("/Users/steve/Documents/Main/Topic/Note.md", "# Note\n\nContent")
```

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
