# LazyVim-Style Modular Configuration Guide

This document explains how to achieve LazyVim-style modular plugin configurations using Lazy.nvim's `opts_extend` feature.

## The Problem: List Merging in Lazy.nvim

When you define the same plugin in multiple files, Lazy.nvim has different merging behaviors:

- **Key-value tables**: Merged together ✅
- **List-like tables**: Last one wins (overridden) ❌

### Example Problem
```lua
-- plugins/mason-tool-installer.lua
{
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  opts = {
    ensure_installed = { "lua_ls", "stylua" }
  }
}

-- lang/ruby.lua  
{
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  opts = {
    ensure_installed = { "ruby_lsp", "standardrb" }  -- This REPLACES the first list!
  }
}
```

**Result**: Only `ruby_lsp` and `standardrb` are installed. The Lua tools are lost!

## The Solution: `opts_extend`

`opts_extend` tells Lazy.nvim which keys should be **extended** (concatenated) instead of **merged** (replaced).

### Basic Usage

```lua
-- plugins/mason-tool-installer.lua
{
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  opts_extend = { "ensure_installed" },  -- ← The magic!
  opts = {
    ensure_installed = { "lua_ls", "stylua" }
  }
}

-- lang/ruby.lua  
{
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  opts = {
    ensure_installed = { "ruby_lsp", "standardrb" }  -- This gets ADDED now!
  }
}
```

**Result**: All tools installed: `lua_ls`, `stylua`, `ruby_lsp`, `standardrb` ✅

## Key Concepts

### 1. Parent Specs and Load Order

- Lazy.nvim loads files **alphabetically**
- The **first file** with a plugin spec becomes the "parent spec"
- `opts_extend` should be defined in the parent spec
- **Best Practice**: Add `opts_extend` to every spec to be load-order independent

### 2. Dotted Key Support

You can extend nested table keys using dot notation:

```lua
opts_extend = {
  "sources.completion.enabled_providers",
  "sources.compat",
  "spec"  -- Simple key
}
```

### 3. Multiple Keys

Extend multiple keys at once:

```lua
opts_extend = { "ensure_installed", "optional_tools", "disabled_tools" }
```

## Real-World Examples

### Mason Tool Installer (Our Setup)

```lua
-- plugins/mason-tool-installer.lua
{
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  -- opts_extend: Lazy.nvim feature added in v10.23.0 (June 2024)
  -- Allows specified keys to be EXTENDED (concatenated) instead of MERGED (replaced)
  -- This enables lang/* files to add tools to ensure_installed without complex functions
  -- Usage in lang files: just use opts = { ensure_installed = { "tool1", "tool2" } }
  -- Underdocumented but used extensively in LazyVim - see CHANGELOG.md
  opts_extend = { "ensure_installed" },
  opts = {
    ensure_installed = { "lua_ls", "stylua" },
    auto_update = true,
    run_on_start = true,
  }
}

-- lang/ruby.lua
{
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  opts = {
    ensure_installed = { "ruby_lsp", "standardrb", "solargraph" }
  }
}
```

### Treesitter (LazyVim Pattern)

```lua
-- plugins/treesitter.lua
{
  "nvim-treesitter/nvim-treesitter",
  opts_extend = { "ensure_installed" },
  opts = {
    ensure_installed = { "lua", "vim" }
  }
}

-- lang/javascript.lua
{
  "nvim-treesitter/nvim-treesitter", 
  opts = {
    ensure_installed = { "javascript", "typescript", "tsx" }
  }
}
```

### Which-Key (Complex Specs)

```lua
-- plugins/which-key.lua
{
  "folke/which-key.nvim",
  opts_extend = { "spec" },
  opts = {
    spec = {
      { "<C-h>", "<C-w>h", desc = "Move left" },
      { "<C-j>", "<C-w>j", desc = "Move down" }
    }
  }
}

-- lang/ruby.lua
{
  "folke/which-key.nvim",
  opts = {
    spec = {
      { "<leader>r", group = "Ruby" },
      { "<leader>rt", ":RSpecFile<cr>", desc = "Run tests" }
    }
  }
}
```

## Feature History

- **Added**: Lazy.nvim v10.23.0 (June 7, 2024)
- **Changelog**: *"plugin: `opts_extend` can be a list of dotted keys that will be extended instead of merged"*
- **Status**: Functional but underdocumented
- **Usage**: Extensively used in LazyVim for modular configurations

## Best Practices

1. **Always define `opts_extend` in your main plugin config** to ensure it works regardless of load order
2. **Use simple table syntax** in language files: `opts = { ensure_installed = { ... } }`
3. **Group related extensions** in language-specific files for maintainability
4. **Document usage** since the feature is underdocumented upstream
5. **Test load order** by alphabetically renaming files if needed

## Troubleshooting

### Not Working?

1. Check if `opts_extend` is in the parent spec (first file loaded alphabetically)
2. Verify you're using the correct key names
3. Ensure you have Lazy.nvim v10.23.0 or later
4. Look for typos in dotted key paths

### Complex Debugging

Add logging to see what's happening:
```lua
opts = function(_, opts)
  print("Before extend:", vim.inspect(opts.ensure_installed))
  return opts
end
```

## References

- [Lazy.nvim CHANGELOG](https://github.com/folke/lazy.nvim/blob/main/CHANGELOG.md) - Official feature mention
- [GitHub Discussion #1706](https://github.com/folke/lazy.nvim/discussions/1706) - Community explanation
- [LazyVim Source](https://github.com/LazyVim/LazyVim) - Extensive real-world usage examples

## Alternative Approaches

Before `opts_extend`, you had to use function-based merging:

```lua
-- Old complex way
opts = function(_, opts)
  vim.list_extend(opts.ensure_installed or {}, {
    "ruby_lsp", "standardrb", "solargraph"
  })
end

-- New simple way with opts_extend  
opts = {
  ensure_installed = { "ruby_lsp", "standardrb", "solargraph" }
}
```

The `opts_extend` approach is cleaner, more declarative, and follows the LazyVim pattern exactly.
