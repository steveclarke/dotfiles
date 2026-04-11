---
name: to-markdown
description: Convert files to Markdown using markitdown. Use this skill whenever the user wants to convert a document, PDF, Word file, Excel spreadsheet, PowerPoint, image, HTML page, or any other file into Markdown format. Also use it when importing external documents into a knowledge base, extracting text from files for AI processing, or converting office documents to plain text. Trigger on phrases like "convert to markdown", "extract text from", "import this document", "turn this PDF into markdown", "get the content of this file".
---

Convert files to Markdown using [markitdown](https://github.com/microsoft/markitdown) — Microsoft's utility that extracts and structures content from many file formats.

## Supported Formats

| Format | Notes |
|--------|-------|
| PDF | Text extracted; table structure may be approximate |
| Word (.docx) | Clean conversion including tables |
| Excel (.xlsx) | Sheets as markdown tables |
| PowerPoint (.pptx) | Slide text and structure |
| HTML | Cleaned readable content |
| Images | OCR (requires LLM vision for best results) |
| Audio | Transcription via SpeechRecognition |
| CSV / JSON / XML | Structured text |
| YouTube URLs | Transcript extraction |
| EPub | Chapter text |

## Usage

```bash
# Convert to stdout
markitdown input.pdf 2>/dev/null

# Save to file
markitdown input.pdf -o output.md 2>/dev/null

# Or redirect
markitdown input.docx 2>/dev/null > output.md
```

Always use `2>/dev/null` to suppress noisy font/parser warnings that don't affect output quality.

## Workflow

1. **Check if markitdown is installed:**
   ```bash
   which markitdown || echo "not installed"
   ```

2. **Install if missing** (with all format support):
   ```bash
   pip install 'markitdown[all]'
   ```

3. **Run the conversion** with stderr suppressed:
   ```bash
   markitdown "$INPUT_FILE" 2>/dev/null
   ```

4. **Handle the output** based on user intent:
   - Saving to the knowledge base → write to appropriate `.md` file
   - Quick review → show in conversation
   - Multiple files → loop and convert each

## Output Quality Notes

- **PDFs**: Text is extracted faithfully but table cells may land on separate lines (PDF doesn't encode table structure). If the user needs clean tables from a PDF, note this limitation.
- **Word/Excel**: Usually clean output with proper table formatting.
- **Complex layouts**: Multi-column PDFs or heavily formatted documents may have scrambled reading order.
- **Scanned PDFs**: Image-only PDFs produce no text without OCR/LLM vision integration.

## Common Use Cases

**Import a document into knowledge base:**
```bash
markitdown report.pdf 2>/dev/null > knowledge/competitive/raw/report.md
```

**Convert a Word doc someone sent you:**
```bash
markitdown meeting-notes.docx 2>/dev/null > notes.md
```

**Batch convert a directory:**
```bash
for f in docs/*.pdf; do
  markitdown "$f" 2>/dev/null > "${f%.pdf}.md"
done
```

**Check what a PDF contains before deciding what to do with it:**
```bash
markitdown document.pdf 2>/dev/null | head -50
```
