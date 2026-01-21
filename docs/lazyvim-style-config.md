# LazyVim-Style Config Guide

How to use `opts_extend` in Lazy.nvim for modular plugin configs.

## The Problem

When you set up the same plugin in multiple files, Lazy.nvim merges them. But lists get replaced, not combined.

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
    ensure_installed = { "ruby_lsp", "standardrb" }  -- Replaces the first list!
  }
}
```

**Result:** Only `ruby_lsp` and `standardrb` get installed. The Lua tools are gone.

## The Fix: opts_extend

Tell Lazy.nvim which keys should be combined instead of replaced:

```lua
-- plugins/mason-tool-installer.lua
{
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  opts_extend = { "ensure_installed" },  -- The fix
  opts = {
    ensure_installed = { "lua_ls", "stylua" }
  }
}

-- lang/ruby.lua
{
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  opts = {
    ensure_installed = { "ruby_lsp", "standardrb" }  -- Now gets added
  }
}
```

**Result:** All tools installed: `lua_ls`, `stylua`, `ruby_lsp`, `standardrb`

## How It Works

### Load Order

- Lazy.nvim loads files in alphabetical order
- The first file with a plugin spec is the "parent spec"
- Put `opts_extend` in the parent spec
- Tip: Add `opts_extend` to every spec so load order doesn't matter

### Nested Keys

Use dots to extend nested tables:

```lua
opts_extend = {
  "sources.completion.enabled_providers",
  "sources.compat",
  "spec"
}
```

### Multiple Keys

Extend several keys at once:

```lua
opts_extend = { "ensure_installed", "optional_tools", "disabled_tools" }
```

## Examples

### Mason Tool Installer

```lua
-- plugins/mason-tool-installer.lua
{
  "WhoIsSethDaniel/mason-tool-installer.nvim",
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

### Treesitter

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

### Which-Key

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

## Tips

1. **Put `opts_extend` in your main plugin config** so it works no matter what order files load
2. **Use simple table syntax** in language files: `opts = { ensure_installed = { ... } }`
3. **Group related tools** in language-specific files
4. **Test load order** by renaming files if needed

## Troubleshooting

**Not working?**

1. Is `opts_extend` in the parent spec (first file loaded)?
2. Are the key names spelled right?
3. Do you have Lazy.nvim v10.23.0 or later?
4. Check for typos in dotted key paths

**Debug with logging:**

```lua
opts = function(_, opts)
  print("Current:", vim.inspect(opts.ensure_installed))
  return opts
end
```

## The Old Way

Before `opts_extend`, you had to merge lists by hand:

```lua
-- Old way (complex)
opts = function(_, opts)
  vim.list_extend(opts.ensure_installed or {}, {
    "ruby_lsp", "standardrb", "solargraph"
  })
end

-- New way (simple)
opts = {
  ensure_installed = { "ruby_lsp", "standardrb", "solargraph" }
}
```

## Links

- [Lazy.nvim CHANGELOG](https://github.com/folke/lazy.nvim/blob/main/CHANGELOG.md) — feature added in v10.23.0 (June 2024)
- [GitHub Discussion #1706](https://github.com/folke/lazy.nvim/discussions/1706) — community explanation
- [LazyVim Source](https://github.com/LazyVim/LazyVim) — real-world examples
