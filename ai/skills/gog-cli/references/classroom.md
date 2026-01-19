# Classroom Commands

**Note:** Requires Google Workspace for Education.

## Courses

```bash
# List courses
gog classroom courses list

# Create course
gog classroom courses create --name "Math 101"

# Archive course
gog classroom courses archive <courseId>

# Get web link
gog classroom courses url <courseId>
```

## Course Content

### Assignments

```bash
gog classroom coursework create <courseId> \
  --title "Homework 1" \
  --type ASSIGNMENT \
  --state PUBLISHED
```

### Materials

```bash
gog classroom materials create <courseId> \
  --title "Syllabus" \
  --state PUBLISHED
```

### Announcements

```bash
gog classroom announcements create <courseId> --text "Welcome!"
```

## Submissions & Grading

```bash
# View submissions
gog classroom submissions list <courseId> <courseworkId>

# Grade submission
gog classroom submissions grade <courseId> <courseworkId> <submissionId> \
  --grade 85

# Return graded work
gog classroom submissions return <courseId> <courseworkId> <submissionId>
```

## Roster Management

```bash
# View enrolled students
gog classroom roster <courseId>

# Add student directly
gog classroom students add <courseId> <userId>

# Send invitation
gog classroom invitations create <courseId> <userId> --role student
```

## States

| State | Description |
|-------|-------------|
| `DRAFT` | Not visible to students |
| `PUBLISHED` | Visible to students |

## Coursework Types

| Type | Description |
|------|-------------|
| `ASSIGNMENT` | Work to submit |
| `SHORT_ANSWER_QUESTION` | Text response |
| `MULTIPLE_CHOICE_QUESTION` | Choice question |

## Tips

- Course IDs are numeric (found in URL)
- Use `--state DRAFT` to create without publishing
- Students receive email notifications for published content
