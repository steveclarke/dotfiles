---
name: superthread
description: Interact with Superthread project management via CLI. Use when creating/managing cards, viewing boards, searching tasks, or tracking work.
---

# Superthread CLI

Project management CLI for the Superthread API.

## Quick Start

```bash
brew install steveclarke/tap/superthread
suth setup                        # Interactive wizard — API key, workspace
suth cards assigned me             # See your cards
suth search query "term"           # Search everything
```

## Essential Patterns

```bash
--json              # Structured output (for scripts/agents)
-y / --yes          # Skip confirmations
-s SPACE            # Resolve ambiguous names (boards, lists, sprints)
me                  # Use as user reference: suth cards assigned me
```

Most commands accept **names or IDs** for spaces, boards, lists, sprints, users, and tags.

## Mentions

Use `{{@Name}}` to mention workspace members in comments, replies, checklist items, and card/page content. The name is matched case-insensitively against workspace member display names.

```bash
# Mention in a comment
suth comments create -c CARD --content "{{@Stacey}} Ready for review."

# Mention in a reply
suth replies create --comment COMMENT --content "{{@Steve Clarke}} can you take a look?"

# Multiple mentions
suth comments create -c CARD --content "{{@Stacey}} and {{@Steve Clarke}} — thoughts?"
```

Do NOT use raw HTML mention tags (e.g., `<user-mention>` or `<mention-user>`). These will not trigger notifications. Always use the `{{@Name}}` template syntax.

To include literal `{{@Name}}` text without triggering a mention, escape it: `\{{@Name}}`.

## Common Workflows

### View and manage cards

```bash
suth cards list -b BOARD                         # Cards on a board
suth cards search "login timeout"                # Find cards by keyword
suth cards assigned me                           # My cards
suth cards get CARD                              # Card details
suth cards create --title "Task" -l LIST -b BOARD
suth cards update CARD --list "Done"             # Move card (auto-resolves list name)
suth cards assign CARD user1,user2               # Assign users
```

### Browse structure

```bash
suth spaces list                                 # All spaces
suth boards list -s SPACE                        # Boards in a space
suth lists list -b BOARD                         # Columns on a board
suth projects list                               # Roadmap projects
```

### Search

```bash
suth cards search "login timeout"                # Find cards (rich output)
suth cards search "bug" --status open,started    # Filter by status
suth cards search "auth" -s SPACE --limit 50     # Filter by space, custom limit
suth search query "term"                         # Search all entity types
suth search query "bug" --types card,page        # Filter by type
suth search query "auth" --status open -s SPACE  # Filter by status and space
```

---

## Full Command Reference

Details below. Options shown as `# Options:` are optional unless marked required.

### Accounts

```bash
suth accounts list
suth accounts show
suth accounts use NAME
suth accounts add NAME                           # Interactive
suth accounts add NAME --with-token              # Non-interactive: reads API key from stdin
  # Options: --workspace-name "X"
suth accounts remove NAME
```

Non-interactive setup for agents:
```bash
echo "$SUPERTHREAD_API_KEY" | suth accounts add myaccount --with-token
```

### Workspaces

```bash
suth workspaces list
suth workspaces use WORKSPACE
suth workspaces current
```

### Current User & Members

```bash
suth me
suth members list
```

### Spaces

```bash
suth spaces list
suth spaces get SPACE
suth spaces create --title "Name"
  # Options: --description, --icon NAME, --icon-color "#HEX"
suth spaces update SPACE --title "New Name"
  # Options: --description, --icon NAME, --icon-color "#HEX"
suth spaces delete SPACE
suth spaces add_member SPACE USERS [--role ROLE]   # Comma-separated users
suth spaces remove_member SPACE USERS
```

### Boards

```bash
suth boards list -s SPACE
  # Options: --bookmarked, --include-archived
suth boards get BOARD
  # Options: -s SPACE
suth boards create -s SPACE --title "Name"
  # Options: --description, --layout (board|list|timeline|calendar),
  #          --icon NAME, --color COLOR
suth boards update BOARD --title "New Name"
  # Options: -s SPACE, --description, --layout, --icon, --color, --archived
suth boards duplicate BOARD -s SPACE
  # Options: --title, --copy-cards, --create-missing-tags
suth boards delete BOARD
  # Options: -s SPACE
```

### Lists

Board column management:

```bash
suth lists list -b BOARD
  # Options: -s SPACE
suth lists create --title "In Progress" -b BOARD
  # Options: -s SPACE, --description, --icon NAME, --color COLOR
suth lists update LIST --title "Done"
  # Options: --description, --icon NAME, --color COLOR
suth lists delete LIST
```

### Cards

```bash
# Listing
suth cards list -b BOARD
suth cards list --sprint SPRINT -s SPACE
  # Options: --list, --include-archived, --since DATE, --updated-since DATE, -s SPACE
suth cards assigned USER
suth cards assigned me
  # Options: --board, --space, --project, --include-archived,
  #          --since DATE, --updated-since DATE

# Search
suth cards search TERM
  # Options: -s SPACE, --status STATUS, --field title|content,
  #          --include-archived, --limit N (default: 30, 0 = unlimited)

# CRUD
suth cards get CARD
  # Options: --raw, --no-content
suth cards create --title "Task" -l LIST -b BOARD
  # Options: --content HTML, --project ID, --parent-card ID, --epic ID,
  #          --sprint SPRINT, -s SPACE, --start-date TIMESTAMP,
  #          --due-date TIMESTAMP, --priority N, --owner/-o USER
suth cards update CARD
  # Options: --title, --content HTML, --list LIST, --board BOARD, --sprint SPRINT,
  #          -s SPACE, --position N, --priority N, --epic ID, --archived/--no-archived
  # Note: list names auto-resolve. Moving to sprint requires --sprint and -s.
  # Note: --content uses a separate PUT endpoint from other fields.
suth cards delete CARD
suth cards duplicate CARD --project ID -b BOARD -l LIST
  # Required: --project, --board/-b, --list/-l
  # Options: --title, --space/-s

# Members
suth cards assign CARD USERS                       # Comma-separated
suth cards unassign CARD USERS

# Relationships
suth cards link --card CARD --related OTHER --type blocks
suth cards unlink --card CARD --related OTHER

# Tags
suth cards tag CARD tag1,tag2
suth cards untag CARD tag1
```

### Projects (Epics)

```bash
suth projects list
suth projects get PROJECT
suth projects create --title "Q1" -l LIST [-b BOARD]
  # Options: --content, --start-date TIMESTAMP, --due-date TIMESTAMP,
  #          --priority N, --owner/-o USER, -s SPACE
suth projects update PROJECT --title "New"
  # Options: --list/-l, --board/-b, --space/-s, --owner/-o USER,
  #          --start-date, --due-date, --priority, --archived
suth projects delete PROJECT
suth projects add_card PROJECT CARD
suth projects remove_card PROJECT CARD
```

### Pages

```bash
suth pages list [-s SPACE]
  # Options: --include-archived, --updated-recently
suth pages get PAGE
suth pages create -s SPACE [--title "Doc"]
  # Options: --content, --parent-page ID, --is-public
suth pages update PAGE --title "New title"
  # Options: --content HTML, --is-public, --parent-page ID, --archived
suth pages duplicate PAGE -s SPACE
  # Options: --title, --parent-page ID
suth pages archive PAGE
suth pages delete PAGE
```

### Comments & Replies

```bash
suth comments list -c CARD
suth comments get COMMENT
suth comments create --content "Note" -c CARD
  # Options: --page/-p PAGE (for page comments instead of card)
suth comments update COMMENT --content "Updated"
  # Options: --status (resolved|open|orphaned)
suth comments delete COMMENT

suth replies list --comment COMMENT
suth replies get REPLY --comment COMMENT
suth replies create --comment COMMENT --content "Reply text"
suth replies update REPLY --comment COMMENT --content "Updated"
  # Options: --status (resolved|open|orphaned)
suth replies delete REPLY --comment COMMENT
```

### Checklists

```bash
suth checklists list -c CARD
suth checklists get CHECKLIST -c CARD
suth checklists create --title "Tasks" -c CARD
suth checklists update CHECKLIST --title "New Title" -c CARD
suth checklists delete CHECKLIST -c CARD

# Items
suth checklists add-item CHECKLIST --title "Do thing" -c CARD [--checked]
suth checklists update-item ITEM --checklist CL -c CARD --title "New"
suth checklists remove-item ITEM --checklist CL -c CARD
suth checklists check ITEM [ITEM...] --checklist CL -c CARD
suth checklists uncheck ITEM [ITEM...] --checklist CL -c CARD
```

### Tags

```bash
suth tags list
  # Options: --space/-s SPACE, --all (include unused tags)
suth tags create --name "urgent" --color "#ff0000"
  # Options: --space/-s SPACE
suth tags update TAG --name "critical"
  # Options: --color
suth tags delete TAG
```

### Notes

```bash
suth notes list
suth notes get NOTE
suth notes create --title "Meeting" [--transcript "..."]
  # Options: --user-notes, --is-public
suth notes delete NOTE
```

### Sprints

```bash
suth sprints list -s SPACE
suth sprints get SPRINT -s SPACE
```

### Search

```bash
suth search query TERM
  # Options: --types card,page,..., --status open,started, --field title|content,
  #          -s SPACE, --include-archived, --grouped, --limit N (default: 30, 0 = unlimited)
```

### Activity

```bash
suth activity                     # Recent activity (default: today)
  # Runs `show` subcommand by default
  # Options: --since DATE, --user USER, --board/-b BOARD, --space/-s SPACE
```

### Config & Completion

```bash
suth config init                  # Create default config file
suth config show                  # Show current configuration
suth config set KEY VALUE
suth config path                  # Show config file path

suth completion bash              # Generate completion script
suth completion zsh
suth completion fish
```

## Global Options

```
-a, --account NAME    Use specific account
-w, --workspace ID    Workspace (ID or name)
-y, --yes             Skip confirmations
-v, --verbose         Detailed logging
-q, --quiet           Minimal logging
--json                JSON output
--limit N             Max items (default: 50)
```

## Option Aliases

| Long | Short | Description |
|------|-------|-------------|
| `--space` | `-s` | Space (ID or name) |
| `--board` | `-b` | Board (ID or name) |
| `--list` | `-l` | List (ID or name) |
| `--card` | `-c` | Card ID |
| `--related` | `-r` | Related card ID |
| `--owner` | `-o` | Owner (user ID, name, or email) |
| `--yes` | `-y` | Skip confirmations |

Priority levels: 1=Urgent, 2=High, 3=Medium, 4=Low
