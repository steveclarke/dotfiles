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

## Core Principles

- Use compact class declarations: `class GemName::Cli::Main < GemName::Cli::Base`
- Use `extend self` instead of `module_function` for utility modules
- Use Thor's built-in `say "message", :color` for output
- Keep the Base class lean - add helpers as patterns emerge

## Tips & Gotchas

<!-- Add tips here as we discover them while working on CLI tools -->

*This section will grow as we learn from building CLI tools.*
