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
1. Prompt for your API key (from Superthread Settings > API)
2. Validate and fetch your workspaces
3. Let you select a default workspace
4. Save configuration

After setup, try:
```bash
suth spaces list
suth boards list -s SPACE
suth cards assigned me
```

To view or modify config later:
```bash
suth config show
suth config set KEY VALUE
```

## Command Reference

### Spaces

```bash
suth spaces list                              # List all spaces
suth spaces get SPACE                         # Get space details
suth spaces create --title "Name"             # Create space
suth spaces update SPACE --title "New Name"   # Update space
suth spaces delete SPACE                      # Delete space
suth spaces add_member SPACE USER             # Add member
suth spaces remove_member SPACE MEMBER_ID     # Remove member
```

### Boards

```bash
suth boards list -s SPACE                     # List boards in space
suth boards get BOARD                         # Get board details
suth boards lists BOARD                       # List columns on board
suth boards create -s SPACE --title "Name"    # Create board
suth boards update BOARD --title "New Name"   # Update board
suth boards duplicate BOARD                   # Duplicate board
suth boards delete BOARD                      # Delete board

# List (column) management
suth boards list_create -b BOARD --title "In Progress"
suth boards list_update LIST_ID --title "Done"
suth boards list_delete LIST_ID
```

### Cards

```bash
suth cards get CARD_ID                        # Get card details
suth cards create --title "Task" -l LIST -b BOARD
suth cards update CARD_ID --title "New title" --priority 1
suth cards delete CARD_ID -f                  # Delete (with --force)
suth cards duplicate CARD_ID                  # Duplicate card
suth cards assigned USER                      # Cards assigned to user
suth cards assigned me                        # Cards assigned to me

# Members
suth cards assign CARD_ID USER                # Assign user
suth cards unassign CARD_ID USER              # Unassign user

# Relationships
suth cards link CARD_ID OTHER --type=blocks   # Link cards
suth cards unlink CARD_ID OTHER               # Unlink cards

# Checklists
suth cards add-checklist CARD_ID --title "Tasks"
suth cards edit-checklist CARD_ID CL_ID --title "Updated"
suth cards rm-checklist CARD_ID CL_ID -f
suth cards add-item CARD_ID CL_ID --title "Do thing"
suth cards edit-item CARD_ID CL_ID ITEM_ID --checked
suth cards rm-item CARD_ID CL_ID ITEM_ID -f

# Tags
suth cards tags                               # List available tags
suth cards tag CARD_ID tag1,tag2              # Add tags
suth cards untag CARD_ID tag1                 # Remove tag
```

### Projects (Epics)

```bash
suth projects list                            # List roadmap projects
suth projects get PROJECT_ID                  # Get project details
suth projects create --title "Q1" --list LIST_ID
suth projects update PROJECT_ID --title "New"
suth projects delete PROJECT_ID
suth projects add_card PROJECT_ID CARD_ID     # Link card to project
suth projects remove_card PROJECT_ID CARD_ID  # Unlink card
```

### Search

```bash
suth search query "term"                      # Search workspace
suth search query "bug" --types card,page     # Filter by type
suth search query "auth" --space SPACE        # Filter by space
```

### Other Commands

```bash
# Users
suth users me                                 # Current user info
suth users members                            # Workspace members

# Workspaces
suth workspaces list                          # List workspaces
suth workspaces use WORKSPACE_ID              # Set default
suth workspaces current                       # Show current

# Pages
suth pages list -s SPACE
suth pages get PAGE_ID
suth pages create -s SPACE --title "Doc"
suth pages archive PAGE_ID
suth pages delete PAGE_ID

# Comments
suth comments get COMMENT_ID
suth comments create --card_id CARD --content "Note"
suth comments reply COMMENT_ID --content "Reply"

# Notes
suth notes list
suth notes get NOTE_ID
suth notes create --title "Meeting"
suth notes delete NOTE_ID

# Sprints
suth sprints list -s SPACE
suth sprints get SPRINT_ID -s SPACE

# Tags
suth tags create --name "urgent" --color "#ff0000"
suth tags update TAG --name "critical"
suth tags delete TAG
```

## Tips

- Most commands accept **names or IDs** for spaces, boards, users
- Use `-s SPACE` to help resolve ambiguous board names
- Use `--json` for scripted output: `suth cards assigned me --json`
- Destructive commands need `-f` or `--force` to skip confirmation
- Priority levels: 1=Urgent, 2=High, 3=Medium, 4=Low
