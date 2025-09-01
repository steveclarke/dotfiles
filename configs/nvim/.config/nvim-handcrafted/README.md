# NeoVim Configuration

A custom, handcrafted NeoVim configuration built with [Lazy.nvim](https://github.com/folke/lazy.nvim).

## Structure

```
nvim-handcrafted/
├── init.lua                    # Main entry point
└── lua/steve/
    ├── lazy.lua               # Lazy.nvim bootstrap and setup
    ├── core/                  # Core settings (keymaps, options)
    ├── plugins/               # Plugin configurations using Lazy.nvim spec
    └── lang/                  # Language-specific plugin configurations
```

## Keymaps

See [KEYMAPS.md](./KEYMAPS.md) for complete keymap documentation and philosophy.


## Key Features

- **Neo-tree** - Modern file explorer with git integration
- **Oil.nvim** - Buffer-based file editing
- **Snacks Picker** - Fast file/buffer/git file searching with telescope-like functionality
  - `<leader>ff` - Find Files (with symlink following)
  - `<leader>fg` - Find Git Files  
  - `<leader>fr` - Recent Files
  - `<leader>fb` - Find Buffers
- **Mason** - LSP server management
- **Lazy.nvim** - Fast plugin management
- **Vim-tmux-navigator** - Seamless tmux integration

---

*Inspired by [LazyVim](https://www.lazyvim.org/keymaps) keymap organization.*
