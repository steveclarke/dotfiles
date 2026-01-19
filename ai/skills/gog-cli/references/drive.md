# Drive Commands

## List & Search

```bash
# List files
gog drive ls --max 20

# Search by name
gog drive search "invoice" --max 20

# Get file metadata
gog drive get <fileId>

# Get web link
gog drive url <fileId>
```

## Upload & Download

```bash
# Upload file to folder
gog drive upload ./path/to/file --parent <folderId>

# Download file
gog drive download <fileId> --out ./downloaded.bin

# Export as different format (for Google Docs/Sheets/Slides)
gog drive download <fileId> --format pdf --out ./exported.pdf
```

## Organize

```bash
# Create folder
gog drive mkdir "New Folder" --parent <parentFolderId>

# Rename
gog drive rename <fileId> "New Name"

# Move to different folder
gog drive move <fileId> --parent <destinationFolderId>

# Delete (move to trash)
gog drive delete <fileId>
```

## Permissions & Sharing

```bash
# List permissions
gog drive permissions <fileId>

# Share with user
gog drive share <fileId> --email user@example.com --role reader
gog drive share <fileId> --email user@example.com --role writer

# Revoke access
gog drive unshare <fileId> --permission-id <permissionId>

# List shared drives
gog drive drives --max 100
```

## Roles

| Role | Description |
|------|-------------|
| `reader` | View only |
| `commenter` | View and comment |
| `writer` | Edit |
| `organizer` | Manage (shared drives) |

## Tips

- File IDs are found in Google Drive URLs after `/d/`
- Parent folder ID `root` refers to "My Drive"
- Export formats: `pdf`, `docx`, `xlsx`, `pptx`, `txt`, `csv`
