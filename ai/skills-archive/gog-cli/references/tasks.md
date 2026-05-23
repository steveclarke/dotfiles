# Tasks Commands

## Task Lists

```bash
# List all task lists
gog tasks lists --max 50

# Create new list
gog tasks lists create <title>
```

## Manage Tasks

### View

```bash
# List tasks in a list
gog tasks list <tasklistId> --max 50
```

### Create

```bash
# Simple task
gog tasks add <tasklistId> --title "Task title"

# Task with due date
gog tasks add <tasklistId> --title "Deadline task" --due 2025-02-01

# Recurring task
gog tasks add <tasklistId> --title "Weekly sync" \
  --due 2025-02-01 --repeat weekly --repeat-count 4
```

### Update & Complete

```bash
# Update task
gog tasks update <tasklistId> <taskId> --title "New title"

# Mark complete
gog tasks done <tasklistId> <taskId>

# Reopen task
gog tasks undo <tasklistId> <taskId>
```

### Delete

```bash
# Delete single task
gog tasks delete <tasklistId> <taskId>

# Clear all completed tasks
gog tasks clear <tasklistId>
```

## Repeat Options

| Option | Description |
|--------|-------------|
| `daily` | Every day |
| `weekly` | Every week |
| `monthly` | Every month |
| `yearly` | Every year |

## Tips

- Task list ID `@default` refers to your default list
- Due dates use ISO format: `YYYY-MM-DD`
- Use `--repeat-count` to limit number of recurrences
