---
name: print
description: Print files on Mac or Linux using the `lp` command with sensible defaults (double-sided, black & white). Supports PDF, markdown (via md-to-pdf conversion), and common print options like copies, page ranges, color, and printer selection.
---

# Print

Print files on Mac or Linux using the `lp` command with sensible defaults.

## Printing Markdown

To print a markdown file, first convert it to PDF using the `/md-to-pdf` skill:

```bash
~/.claude/skills/md-to-pdf/scripts/md-to-pdf.mjs doc.md
~/.claude/skills/print/scripts/print doc.pdf
rm doc.pdf  # Delete if PDF was just for printing
```

The `/md-to-pdf` skill handles Mermaid diagrams, syntax highlighting, and page numbers.

## Defaults

| Setting | Default | Rationale |
|---------|---------|-----------|
| **Duplex** | Double-sided (long-edge) | Save paper |
| **Color** | Black & white | Save toner on color printers |

These defaults can be overridden per-request.

## Usage

### Quick Print (uses system default printer)

```bash
# Print a file with defaults (double-sided, b&w)
lp -o sides=two-sided-long-edge -o ColorModel=Gray <file>

# Or use the helper script
~/.claude/skills/print/scripts/print <file>
```

### Common Options

| Option | Flag | Example |
|--------|------|---------|
| Printer | `-d <name>` | `-d HP_LaserJet_4001` |
| Copies | `-n <count>` | `-n 3` |
| Pages | `-P <range>` | `-P 1-5` or `-P 1,3,7` |
| Single-sided | `-o sides=one-sided` | Override duplex |
| Color | `-o ColorModel=Color` | Override b&w |
| Landscape | `-o landscape` | Rotate 90° |
| Fit to page | `-o fit-to-page` | Scale to fit |

### List Available Printers

```bash
lpstat -p -d
```

Shows all printers and the system default (marked with `system default destination:`).

### Check Print Queue

```bash
lpstat -o          # Show pending jobs
lpstat -W completed # Show completed jobs
```

### Cancel a Job

```bash
cancel <job-id>    # e.g., cancel HP_LaserJet_4001-852
cancel -a          # Cancel all jobs
```

## Helper Script

The `print` script at `~/.claude/skills/print/scripts/print` wraps `lp` with the defaults:

```bash
# Basic usage
print document.pdf

# Specify printer
print document.pdf -d Brother_HL_L3280CDW_series

# Multiple copies
print document.pdf -n 3

# Single-sided color
print document.pdf --single-sided --color

# Page range
print document.pdf -P 1-5
```

Run `print --help` for all options.

## Printer-Specific Notes

### HP LaserJet 4001
- Supports duplex
- Monochrome only (no color option needed)
- Steve's default printer

### Brother HL-L3280CDW
- Color laser
- Supports duplex
- Use `--color` to override b&w default

### Brother DCP-L2550DW
- Monochrome
- Supports duplex

## Troubleshooting

### "No such file or directory"
The printer name has changed. Run `lpstat -p` to see current names.

### Job stuck in queue
```bash
lpstat -o                    # Check status
cancel <job-id>              # Cancel stuck job
cupsenable <printer-name>    # Re-enable if disabled
```

### Duplex not working
Not all printers support duplex. Check printer capabilities:
```bash
lpoptions -p <printer-name> -l | grep -i sides
```
