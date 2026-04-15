#!/usr/bin/env bash
installing_banner "claude-code-plugins"

# Install Claude Code plugins from official and third-party marketplaces.
# Requires: claude (Claude Code CLI) already installed and authenticated.
# Idempotent — safe to re-run; already-installed plugins are skipped.
#
# Settings (enabledPlugins, permissions, attribution, etc.) are managed
# separately via dotfiles stow of ~/.claude/settings.json.
#
# To add a new plugin:
#   1. Add the `claude plugin install` line below
#   2. Add to enabledPlugins in your settings.json if not auto-enabled

# Extra marketplaces (beyond the built-in claude-plugins-official)
claude plugin marketplace add openai/codex-plugin-cc

# Official marketplace plugins
claude plugin install claude-code-setup@claude-plugins-official
claude plugin install code-review@claude-plugins-official
claude plugin install code-simplifier@claude-plugins-official
claude plugin install context7@claude-plugins-official
claude plugin install discord@claude-plugins-official
claude plugin install figma@claude-plugins-official
claude plugin install gopls-lsp@claude-plugins-official
claude plugin install ruby-lsp@claude-plugins-official
claude plugin install security-guidance@claude-plugins-official
claude plugin install skill-creator@claude-plugins-official
claude plugin install slack@claude-plugins-official
claude plugin install stripe@claude-plugins-official
claude plugin install superpowers@claude-plugins-official

# Third-party marketplace plugins
claude plugin install codex@openai-codex
