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
-w, --workspace ID    Workspace ID (or use config/env var)
-y, --yes             Skip confirmation prompts (for scripts/agents)
-v, --verbose         Detailed logging
-q, --quiet           Minimal logging
--json                Output in JSON format (default is table)
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
suth cards list -b BOARD                      # List cards on a board
suth cards get CARD_ID [-o]                   # Get card details (--open for browser)
suth cards create --title "Task" -l LIST -b BOARD
suth cards update CARD_ID --title "New title" --priority 1
suth cards delete CARD_ID                     # Delete card
suth cards duplicate CARD_ID                  # Duplicate card
suth cards assigned USER                      # Cards assigned to user
suth cards assigned me                        # Cards assigned to me

# Members
suth cards assign CARD_ID USER                # Assign user
suth cards unassign CARD_ID USER              # Unassign user

# Relationships
suth cards link --card CARD --related OTHER --type blocks
suth cards unlink --card CARD --related OTHER

# Checklists
suth cards add-checklist CARD_ID --title "Tasks"
suth cards edit-checklist --card CARD --checklist CL --title "Updated"
suth cards remove-checklist --card CARD --checklist CL
suth cards add-item --card CARD --checklist CL --title "Do thing" [--checked]
suth cards edit-item --card CARD --checklist CL --item ITEM --title "New"
suth cards remove-item --card CARD --checklist CL --item ITEM

# Tags
suth cards tags                               # List available tags
suth cards tag CARD_ID tag1,tag2              # Add tags
suth cards untag CARD_ID tag1                 # Remove tag
```

### Projects (Epics)

```bash
suth projects list                            # List roadmap projects
suth projects get PROJECT_ID [-o]             # Get project details
suth projects create --title "Q1" -l LIST [-b BOARD]
suth projects update PROJECT_ID --title "New"
suth projects delete PROJECT_ID
suth projects add_card PROJECT_ID CARD_ID     # Link card to project
suth projects remove_card PROJECT_ID CARD_ID  # Unlink card
```

### Pages

```bash
suth pages list [-s SPACE]                    # List pages
suth pages get PAGE_ID [-o]                   # Get page details
suth pages create -s SPACE [--title "Doc"]    # Create page
suth pages update PAGE_ID --title "New title" # Update page
suth pages duplicate PAGE_ID -s SPACE         # Duplicate page
suth pages archive PAGE_ID                    # Archive page
suth pages delete PAGE_ID                     # Delete page
```

### Comments

```bash
suth comments get COMMENT_ID [-o]             # Get comment (opens parent card)
suth comments create --card CARD --content "Note"
suth comments update COMMENT_ID --content "Updated"
suth comments delete COMMENT_ID
suth comments reply COMMENT_ID --content "Reply"
suth comments replies COMMENT_ID              # Get replies to a comment
suth comments update-reply --comment COMMENT --reply REPLY --content "New"
suth comments delete-reply --comment COMMENT --reply REPLY
```

### Notes

```bash
suth notes list                               # List notes
suth notes get NOTE_ID [-o]                   # Get note details
suth notes create --title "Meeting" [--transcript "..."]
suth notes delete NOTE_ID
```

### Sprints

```bash
suth sprints list -s SPACE                    # List sprints in space
suth sprints get SPRINT_ID -s SPACE           # Get sprint details
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

- Most commands accept **names or IDs** for spaces, boards, lists, users, and tags
- Use `-s SPACE` to help resolve ambiguous board/list names
- Use `--json` for scripted output: `suth cards assigned me --json`
- Use `me` as a user reference: `suth cards assigned me`
- Use `-o` to open any resource in your browser: `suth cards get CARD -o`
- Use `-y` to skip confirmation prompts (for scripts/agents)
- Priority levels: 1=Urgent, 2=High, 3=Medium, 4=Low
