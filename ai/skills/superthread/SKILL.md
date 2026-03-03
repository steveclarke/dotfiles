---
name: superthread
description: Interact with Superthread project management via CLI. Use when creating/managing cards, viewing boards, searching tasks, or tracking work.
---

# Superthread CLI

Project management CLI for the Superthread API.

## Installation

```bash
brew install steveclarke/tap/superthread
```

## Setup

```bash
suth setup
```

The interactive wizard will:
1. Prompt for an account name (e.g., "personal" or "work")
2. Prompt for your API key (from Superthread Settings > API)
3. Validate and auto-detect your workspace
4. Save configuration

After setup, try:
```bash
suth spaces list
suth boards list -s SPACE
suth cards assigned me
```

## Global Options

```
-a, --account NAME    Use specific account for this command
-w, --workspace ID    Workspace (ID or name)
-y, --yes             Skip confirmation prompts (for scripts/agents)
-v, --verbose         Detailed logging
-q, --quiet           Minimal logging
--json                Output in JSON format (default is table)
--limit N             Max items to show (default: 50)
```

## Command Reference

### Accounts

```bash
suth accounts list                            # List all configured accounts
suth accounts show                            # Show current account details
suth accounts use NAME                        # Switch to account
suth accounts add NAME                        # Add new account (interactive)
suth accounts remove NAME                     # Remove account
```

### Workspaces

```bash
suth workspaces list                          # List available workspaces
suth workspaces use WORKSPACE                 # Set default workspace
suth workspaces current                       # Show current workspace
```

### Current User & Members

```bash
suth me                                       # Get current user info
suth members list                             # List workspace members
```

### Spaces

```bash
suth spaces list                              # List all spaces
suth spaces get SPACE [-o]                    # Get space details (--open for browser)
suth spaces create --title "Name"             # Create space
suth spaces update SPACE --title "New Name"   # Update space
suth spaces delete SPACE                      # Delete space
suth spaces add_member SPACE USER [--role ROLE]  # Add member
suth spaces remove_member SPACE USER          # Remove member
```

### Boards

```bash
suth boards list -s SPACE                     # List boards in space
suth boards get BOARD [-o]                    # Get board details
suth boards lists BOARD                       # List columns on board
suth boards create -s SPACE --title "Name"    # Create board
suth boards update BOARD --title "New Name"   # Update board
suth boards duplicate BOARD                   # Duplicate board
suth boards delete BOARD                      # Delete board

# List (column) management
suth boards create-list -b BOARD --title "In Progress"
suth boards update-list LIST_ID --title "Done"
suth boards delete-list LIST_ID
```

### Cards

```bash
# Listing
suth cards list -b BOARD                      # List cards on a board
suth cards list --sprint SPRINT -s SPACE      # List cards in a sprint
  # Options: --list, --include-archived, --since DATE, --updated-since DATE
suth cards assigned USER                      # Cards assigned to user
suth cards assigned me                        # Cards assigned to me
  # Options: --board, --space, --project, --include-archived,
  #          --since DATE, --updated-since DATE

# CRUD
suth cards get CARD [-o]                      # Get card details (--open for browser)
  # Options: --raw, --no-content
suth cards create --title "Task" -l LIST -b BOARD [options]
  # Options: --content HTML, --parent-card ID, --epic ID,
  #          --sprint SPRINT -s SPACE (alternative to --board),
  #          --start-date TIMESTAMP, --due-date TIMESTAMP,
  #          --priority N, --owner USER
suth cards update CARD [options]
  # Options: --title, --list LIST, --board BOARD, --sprint SPRINT -s SPACE,
  #          --position N, --priority N, --epic ID, --archived/--no-archived
  # Note: list names auto-resolve for both board and sprint cards.
  #   Moving to a sprint requires --sprint and -s (space).
suth cards delete CARD                        # Delete card
suth cards duplicate CARD                     # Duplicate card

# Members
suth cards assign CARD USER                   # Assign user
suth cards unassign CARD USER                 # Unassign user

# Relationships
suth cards link --card CARD --related OTHER --type blocks
suth cards unlink --card CARD --related OTHER

# Tags
suth cards tags                               # List available tags
suth cards tag CARD tag1,tag2                 # Add tags
suth cards untag CARD tag1                    # Remove tag
```

### Projects (Epics)

```bash
suth projects list                            # List roadmap projects
suth projects get PROJECT [-o]                # Get project details
suth projects create --title "Q1" -l LIST [-b BOARD]
suth projects update PROJECT --title "New"
suth projects delete PROJECT
suth projects add_card PROJECT CARD           # Link card to project
suth projects remove_card PROJECT CARD        # Unlink card
```

### Pages

```bash
suth pages list [-s SPACE]                    # List pages
suth pages get PAGE [-o]                      # Get page details
suth pages create -s SPACE [--title "Doc"]    # Create page
suth pages update PAGE --title "New title"    # Update page
suth pages duplicate PAGE -s SPACE            # Duplicate page
suth pages archive PAGE                       # Archive page
suth pages delete PAGE                        # Delete page
```

### Comments

```bash
suth comments get COMMENT [-o]               # Get comment (opens parent card)
suth comments create --card CARD --content "Note"
suth comments update COMMENT --content "Updated"
suth comments delete COMMENT
```

### Replies

```bash
suth replies list COMMENT                     # List replies to a comment
suth replies get REPLY                        # Get reply details
suth replies create COMMENT --content "Reply text"
suth replies update REPLY --content "Updated"
suth replies delete REPLY
```

### Checklists

Checklists are a separate subcommand, not under `cards`:

```bash
suth checklists list -c CARD                 # List checklists on a card
suth checklists get CHECKLIST -c CARD        # Get checklist details
suth checklists create --title "Tasks" -c CARD
suth checklists update CHECKLIST --title "New Title" -c CARD
suth checklists delete CHECKLIST -c CARD

# Items
suth checklists add-item CHECKLIST --title "Do thing" -c CARD [--checked]
suth checklists update-item ITEM --checklist CL -c CARD --title "New"
suth checklists remove-item ITEM --checklist CL -c CARD
suth checklists check ITEM --checklist CL -c CARD
suth checklists uncheck ITEM --checklist CL -c CARD
```

### Lists

Board list (column) management as a separate subcommand:

```bash
suth lists list -b BOARD                     # List columns on board
suth lists get LIST                          # Get list details
suth lists create --title "In Progress" -b BOARD
suth lists update LIST --title "Done"
suth lists delete LIST
```

### Notes

```bash
suth notes list                               # List notes
suth notes get NOTE [-o]                      # Get note details
suth notes create --title "Meeting" [--transcript "..."]
suth notes delete NOTE
```

### Sprints

```bash
suth sprints list -s SPACE                    # List sprints in space
suth sprints get SPRINT -s SPACE              # Get sprint details
```

### Search

```bash
suth search query "term"                      # Search workspace
suth search query "bug" --types card,page     # Filter by type
suth search query "auth" -s SPACE [--grouped] # Filter by space
```

### Tags

```bash
suth tags create --name "urgent" --color "#ff0000"
suth tags update TAG --name "critical"
suth tags delete TAG
```

### Config

```bash
suth config init                              # Create default config file
suth config show                              # Show current configuration
suth config set KEY VALUE                     # Set a config value
suth config path                              # Show config file path
```

### Activity

```bash
suth activity                                 # Show recent activity across workspace
```

### Discovery

```bash
suth tree                                     # Print tree of all available commands
```

### Shell Completion

```bash
suth completion bash                          # Generate bash completion script
suth completion zsh                           # Generate zsh completion script
suth completion fish                          # Generate fish completion script
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
| `--open` | `-o` | Open in browser (on get commands) |
| `--yes` | `-y` | Skip confirmation prompts |

## Tips

- Most commands accept **names or IDs** for spaces, boards, lists, sprints, users, and tags
- Use `-s SPACE` to help resolve ambiguous board/list/sprint names
- Use `--json` for scripted output: `suth cards assigned me --json`
- Use `me` as a user reference: `suth cards assigned me`
- Use `-o` to open any resource in your browser: `suth cards get CARD -o`
- Use `-y` to skip confirmation prompts (for scripts/agents)
- Priority levels: 1=Urgent, 2=High, 3=Medium, 4=Low
- Sprint cards auto-detect context: `suth cards update CARD -l "Done"` works without `--sprint`
