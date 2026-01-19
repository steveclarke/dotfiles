# Docs & Slides Commands

## Google Docs

### Create

```bash
gog docs create "My Doc"
```

### Export

```bash
# Export as PDF
gog docs export <docId> --format pdf --out ./doc.pdf

# Export as Word
gog docs export <docId> --format docx --out ./doc.docx
```

### Read Content

```bash
# Display document content
gog docs cat <docId> --max-bytes 10000
```

## Google Slides

### Create

```bash
gog slides create "My Deck"
```

### Export

```bash
# Export as PowerPoint
gog slides export <presentationId> --format pptx --out ./deck.pptx

# Export as PDF
gog slides export <presentationId> --format pdf --out ./deck.pdf
```

## Export Formats

| Service | Formats |
|---------|---------|
| Docs | `pdf`, `docx`, `txt`, `odt`, `html` |
| Slides | `pdf`, `pptx`, `odp` |

## Tips

- Document/Presentation ID is in the URL: `docs.google.com/document/d/<ID>/edit`
- For Slides: `docs.google.com/presentation/d/<ID>/edit`
- Use `gog drive` commands for upload, download, sharing, and organization
