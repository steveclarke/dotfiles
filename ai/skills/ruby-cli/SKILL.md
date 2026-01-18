---
name: ruby-cli
description: Build and maintain Ruby CLI tools using Thor and Zeitwerk. Use when creating new Ruby CLI gems, adding commands, editing CLI code, refactoring, or enhancing existing CLI tools. Triggers on "Ruby CLI", "Thor CLI", "command-line tool in Ruby", or when working on files in a Thor/Zeitwerk CLI codebase.
---

# Ruby CLI Development

Build Ruby CLI tools using Thor for commands and Zeitwerk for autoloading.

## Quick Navigation

- **Starting a new CLI gem from scratch?** See [references/bootstrap.md](references/bootstrap.md)
- **Adding commands or subcommands?** See [references/patterns.md](references/patterns.md)
- **Thor syntax reference?** See [references/patterns.md](references/patterns.md)
- **Rich terminal UI with Gum?** See [references/gum.md](references/gum.md)

## Core Principles

- Use compact class declarations: `class GemName::Cli::Main < GemName::Cli::Base`
- Use `extend self` instead of `module_function` for utility modules
- Keep the Base class lean - add helpers as patterns emerge

## Output Styling

For basic output, use Thor's built-in `say "message", :color`.

For rich terminal UI (headers, tables, spinners, confirmations), use the Gum gem:

```ruby
ui.header("Section Title")    # branded header with border
ui.success("Done!")           # green checkmark
ui.error("Failed")            # red X
ui.table(rows, columns: [...]) # formatted table
ui.spin("Working...") { ... } # spinner during work
```

See [references/gum.md](references/gum.md) for setup and full API.

## Tips & Gotchas

- Add `# rubocop:disable Rails/Output` to UI modules (stdout is intentional in CLIs)
- Gum requires `brew install gum` on the host machine
