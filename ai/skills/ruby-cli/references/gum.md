# Gum CLI Styling

Rich terminal UI using [Charm Ruby's gum gem](https://charm-ruby.dev/).

## Setup

```ruby
# gemspec
spec.add_dependency "gum", "~> 0.1"
```

Requires `gum` CLI: `brew install gum`

## UI Module Pattern

Create a UI module to wrap Gum with consistent branding:

```ruby
# lib/gem_name/cli/ui.rb
module GemName::Cli::Ui
  extend self

  BRAND_COLOR = "#7D56F4"

  def header(text)
    puts Gum.style(text, foreground: BRAND_COLOR, bold: true,
      border: :rounded, border_foreground: BRAND_COLOR, padding: "0 2")
    puts ""
  end

  def success(text) = puts Gum.style("✓ #{text}", foreground: "green", bold: true)
  def warning(text) = puts Gum.style("! #{text}", foreground: "yellow", bold: true)
  def error(text)   = puts Gum.style("✗ #{text}", foreground: "red", bold: true)
  def muted(text)   = puts Gum.style(text, faint: true)
  def info(text)    = puts Gum.style(text, foreground: BRAND_COLOR)

  def table(rows, columns:)
    Gum.table(rows, columns: columns, print: true,
      border: :rounded, header_foreground: BRAND_COLOR)
    puts ""
  end

  def confirm(question, default: true) = Gum.confirm(question, default: default)
  def input(prompt, placeholder: nil)  = Gum.input(prompt: prompt, placeholder: placeholder)
  def password(prompt)                 = Gum.input(prompt: prompt, password: true)
  def write(placeholder: nil)          = Gum.write(placeholder: placeholder)
  def choose(items, header: nil)       = Gum.choose(items, header: header)
  def filter(items, placeholder: nil)  = Gum.filter(items, placeholder: placeholder)

  def spin(title, &block)
    Gum.spin(title: title, spinner: :dot, &block)
  end
end
```

Add `ui` helper to Base class:

```ruby
class GemName::Cli::Base < Thor
  private
  def ui = GemName::Cli::Ui
end
```

## Usage in Commands

```ruby
class GemName::Cli::Main < GemName::Cli::Base
  desc "deploy", "Deploy application"
  def deploy
    ui.header("Deploying")

    ui.spin("Building...") { build_app }

    if ui.confirm("Push to production?")
      push_to_production
      ui.success("Deployed!")
    else
      ui.muted("Cancelled")
    end
  end
end
```

## Quick Reference

### Text Styling

```ruby
Gum.style("text", foreground: "green")           # colored
Gum.style("text", foreground: "green", bold: true)  # bold
Gum.style("text", faint: true)                   # muted
Gum.style("text", foreground: "#7D56F4")         # hex color
```

### Borders

```ruby
Gum.style("Title", border: :rounded, border_foreground: "#7D56F4", padding: "0 2")
# Border styles: :rounded, :double, :thick, :normal, :hidden, :none
```

### Tables

```ruby
Gum.table(
  [["Row1", "Data"], ["Row2", "Data"]],
  columns: %w[Name Value],
  print: true,
  border: :rounded,
  header_foreground: "#7D56F4"
)
```

### Input

```ruby
# Confirmation (returns boolean)
Gum.confirm("Continue?", default: true)

# Text input
Gum.input(placeholder: "Name", header: "Enter:")

# Password (hidden input)
Gum.input(placeholder: "Password", password: true)

# Multi-line text
Gum.write(placeholder: "Enter description...")

# Single selection
Gum.choose("A", "B", "C", header: "Pick one:")

# Multiple selection (returns array)
Gum.choose("A", "B", "C", header: "Pick any:", no_limit: true)

# Fuzzy filter
Gum.filter(["apple", "banana", "cherry"], placeholder: "Search...")
```

### Spinners

```ruby
Gum.spin("Working...", spinner: :dot) { do_work }
# Styles: :dot, :line, :minidot, :jump, :pulse, :points, :globe, :moon, :monkey, :meter
```

### Colors

```ruby
# Named colors
foreground: "red"    # green, yellow, blue, magenta, cyan, white

# Hex colors
foreground: "#7D56F4"

# ANSI 256
foreground: "212"
```
