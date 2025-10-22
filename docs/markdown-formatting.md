# Markdown Formatting with mdformat

Quick reference for formatting Markdown files with mdformat.

## Installation

### 1. Install pipx

```bash
brew install pipx
pipx ensurepath
```

### 2. Install mdformat with GFM Support

```bash
# Install mdformat
pipx install mdformat

# Add GFM plugins (tables, strikethrough, task lists, autolinks)
pipx inject mdformat mdformat-gfm mdformat-tables
```

### 3. Add Frontmatter Plugin (Important!)

The frontmatter plugin preserves YAML frontmatter (`---` sections) in your
Markdown files. Without it, mdformat will corrupt these sections.

```bash
pipx inject mdformat mdformat-frontmatter
```

### 4. Verify Installation

```bash
mdformat --help | tail -5
```

You should see:

```
installed extensions:
  mdformat_tables: tables
  mdformat-gfm: gfm, tables
```

### Note: Don't Use Homebrew

If you install `mdformat` via Homebrew (`brew install mdformat`), the GFM
plugins won't work properly. Tables will get broken when using `--wrap`, even
with plugins installed. Use the pipx installation method above instead.

## Common Usage

### Basic Formatting

```bash
# Format a single file
mdformat README.md

# Format multiple files
mdformat file1.md file2.md file3.md

# Format all .md files recursively
mdformat .

# Check formatting without modifying (useful for CI)
mdformat --check .
```

### Line Wrapping

The `--wrap` parameter controls paragraph wrapping:

```bash
# Wrap at 80 characters (Vim-friendly)
mdformat --wrap 80 file.md

# Wrap at 100 characters
mdformat --wrap 100 file.md

# No wrapping (single long lines)
mdformat --wrap no file.md

# Keep existing wrapping (default)
mdformat --wrap keep file.md
```

### Other Useful Parameters

```bash
# Apply consecutive numbering to ordered lists
mdformat --number file.md

# Control line endings
mdformat --end-of-line lf file.md    # Unix (default)
mdformat --end-of-line crlf file.md  # Windows

# Combine parameters
mdformat --wrap 80 --number --end-of-line lf *.md
```

## VSCode Integration

Install the **mdformat-vscode** extension (`bittorala.mdformat`) for
format-on-save support.

Add to your VSCode settings:

```json
{
  "[markdown]": {
    "editor.defaultFormatter": "bittorala.mdformat",
    "editor.formatOnSave": true
  },
  "mdformat.wrap": 80
}
```

## Tips

- Always install the frontmatter plugin to avoid corrupting YAML headers
- Use `--wrap 80` for Vim-friendly editing
- Use `--check` in CI pipelines to enforce formatting
- Mdformat is CommonMark compliant and validates that formatting doesn't change
  rendered HTML
- `pipx` installs Python CLI tools in isolated environments, preventing version
  conflicts
- The `mdformat-gfm` plugin provides proper support for GFM tables,
  strikethrough, task lists, and autolinks
- Tables cannot be wrapped at 80 characters - they maintain their structure
  while other text wraps
