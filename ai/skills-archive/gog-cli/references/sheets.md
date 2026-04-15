# Sheets Commands

## Read Data

```bash
# Get spreadsheet metadata (sheet names, properties)
gog sheets metadata <spreadsheetId>

# Read cell range
gog sheets get <spreadsheetId> 'Sheet1!A1:B10'
gog sheets get <spreadsheetId> 'Sheet1!A:A'  # entire column
```

## Write Data

```bash
# Update cells (pipe = row separator, comma = column separator)
gog sheets update <spreadsheetId> 'A1' 'val1|val2,val3|val4'
# Result:
#   A1: val1  B1: val2
#   A2: val3  B2: val4

# Append row to end of data
gog sheets append <spreadsheetId> 'Sheet1!A:C' 'new|row|data'

# Clear range
gog sheets clear <spreadsheetId> 'Sheet1!A1:B10'
```

## Formatting

```bash
# Apply formatting (JSON format spec)
gog sheets format <spreadsheetId> 'Sheet1!A1:B2' \
  --format-json '{"textFormat":{"bold":true}}'

# Common format options:
# {"textFormat":{"bold":true}}
# {"textFormat":{"italic":true}}
# {"backgroundColor":{"red":1,"green":0.9,"blue":0.9}}
# {"horizontalAlignment":"CENTER"}
```

## Create & Export

```bash
# Create new spreadsheet
gog sheets create "My New Spreadsheet" --sheets "Sheet1,Sheet2"

# Export to PDF
gog sheets export <spreadsheetId> --format pdf --out ./sheet.pdf
```

## Range Notation

| Notation | Description |
|----------|-------------|
| `Sheet1!A1:B10` | Specific range |
| `Sheet1!A:A` | Entire column A |
| `Sheet1!1:1` | Entire row 1 |
| `Sheet1!A1:A` | Column A from row 1 down |
| `'Sheet Name'!A1` | Sheet names with spaces need quotes |

## Tips

- Spreadsheet ID is in the URL: `docs.google.com/spreadsheets/d/<ID>/edit`
- Data format for update/append: pipe `|` separates columns, comma `,` separates rows
- Use `--json` for machine-readable output when reading data
