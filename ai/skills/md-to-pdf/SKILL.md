---
name: md-to-pdf
description: "Renders a Markdown file to a PDF in one house style: page numbers with the file name in the footer, highlighted code, Mermaid diagrams and KaTeX math. Use when asked for a PDF from Markdown, or before printing Markdown."
---

# Markdown to PDF

Every PDF from Markdown goes through one script so they all come out the same: GitHub-light styling, a footer with the file name and page X / Y, syntax-highlighted code that wraps instead of shrinking the page, and ` ```mermaid ` blocks drawn as diagrams.

```bash
~/.claude/skills/md-to-pdf/scripts/md-to-pdf.cjs input.md [output.pdf]
```

The output defaults to `input.pdf` beside the source. The script finds Chrome itself and installs its own Node dependencies on first run and after each skill update, so there is no setup step.

- It writes a temporary `.~input.md` beside the source, so the source folder must be writable.
- Relative image paths resolve against the source file's folder.
- A `chrome:` or `puppeteer:` key in the file's front matter replaces the footer.
- When the PDF exists only to be printed, `trash` it afterwards.
