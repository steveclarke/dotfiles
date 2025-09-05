# ⌨️ Keymaps

This configuration uses a structured approach to keymaps, inspired by [LazyVim's organization](https://www.lazyvim.org/keymaps).

## Keymap Philosophy

- **`<leader>` = `<Space>`** - Primary leader key for most functionality
- **`\` (backslash)** - System/config operations (literal key, not leader-based)
- **Grouped by function** - Related commands share a common prefix (e.g., all explorer commands under `<leader>e*`)
- **Mnemonic naming** - Second letter indicates specific action (`f` = focus, `r` = reveal, etc.)
- **No comma remapping** - Preserve comma for f/F/t/T motion reversals in Markdown editing

## Table of Contents

- [⌨️ Keymaps](#️-keymaps)
  - [Keymap Philosophy](#keymap-philosophy)
  - [Table of Contents](#table-of-contents)
  - [General](#general)
  - [Buffer Navigation](#buffer-navigation)
  - [File Explorer (`<leader>e*`)](#file-explorer-leadere)
  - [File Picker (`<leader>f*`)](#file-picker-leaderf)
  - [Window Navigation](#window-navigation)
  - [Search \& Grep (`<leader>s*`, `<leader>/`)](#search--grep-leaders-leader)
  - [Todo Comments Navigation](#todo-comments-navigation)
  - [Code Completion (`blink.cmp`)](#code-completion-blinkcmp)
  - [Window Management](#window-management)
  - [UI/Utility (`<leader>u*`)](#uiutility-leaderu)
  - [System Operations (`\`)](#system-operations-)
  - [Notes](#notes)

## General

| Key | Description | Mode |
|-----|-------------|------|
| `jj` | Exit insert mode | **i** |
| `<esc>` | Escape and clear search highlights *(LazyVim style)* | **i**, **n**, **s** |
| `<C-d>` | Scroll down and center *(default: just scroll down)* | **n** |
| `<C-u>` | Scroll up and center *(default: just scroll up)* | **n** |
| `n` | Next search result and center *(default: just next result)* | **n** |
| `N` | Previous search result and center *(default: just previous result)* | **n** |
| `x` | Delete char without yanking *(default: yanks to register)* | **n** |
| `<` / `>` | Indent and reselect *(default: loses selection)* | **v** |
| `<A-j>` | Move line/selection down | **n**, **i**, **v** |
| `<A-k>` | Move line/selection up | **n**, **i**, **v** |
| `<leader>qq` | Quit all without saving | **n** |

## Buffer Navigation

*All buffer management provided by bufferline.nvim plugin*

| Key | Description | Mode |
|-----|-------------|------|
| `<S-h>` | Prev Buffer | **n** |
| `<S-l>` | Next Buffer | **n** |
| `[b` | Prev Buffer | **n** |
| `]b` | Next Buffer | **n** |
| `[B` | Move buffer prev | **n** |
| `]B` | Move buffer next | **n** |
| `<leader>bb` | Switch to Other Buffer | **n** |
| `<leader>bd` | Delete Buffer | **n** |
| `<leader>bo` | Delete Other Buffers | **n** |
| `<leader>bp` | Toggle Pin | **n** |
| `<leader>bP` | Delete Non-Pinned buffers | **n** |
| `<leader>br` | Delete Buffers to the Right | **n** |
| `<leader>bl` | Delete Buffers to the Left | **n** |
| `<leader>bD` | Delete Buffer and Window | **n** |

## File Explorer (`<leader>e*`)

| Key | Description | Mode |
|-----|-------------|------|
| `<leader>ee` | Toggle file explorer | **n** |
| `<leader>ef` | Focus file explorer | **n** |
| `<leader>er` | Reveal current file | **n** |
| `<leader>eg` | Toggle git explorer | **n** |
| `<leader>eb` | Toggle buffer explorer | **n** |

## File Picker (`<leader>f*`)

*Provided by Snacks picker with symlink support (`follow = true`)*

| Key | Description | Mode |
|-----|-------------|------|
| `<leader><space>` | Smart Find Files *(buffers + recent + files)* | **n** |
| `<leader>ff` | Find files | **n** |
| `<leader>fg` | Find git files | **n** |
| `<leader>fr` | Recent files | **n** |
| `<leader>fb` | Find buffers | **n** |

## Window Navigation

*Provided by the vim-tmux-navigator plugin*

| Key | Description | Mode |
|-----|-------------|------|
| `<C-h>` | Go to left window | **n** |
| `<C-j>` | Go to lower window | **n** |
| `<C-k>` | Go to upper window | **n** |
| `<C-l>` | Go to right window | **n** |

## Search & Grep (`<leader>s*`, `<leader>/`)

*Provided by Snacks picker with live grep functionality*

| Key | Description | Mode |
|-----|-------------|------|
| `<leader>/` | Grep (Root Dir) | **n** |
| `<leader>sg` | Grep (Root Dir) | **n** |
| `<leader>sG` | Grep (cwd) | **n** |
| `<leader>sw` | Visual selection or word (Root Dir) | **n**, **x** |
| `<leader>sW` | Visual selection or word (cwd) | **n**, **x** |
| `<leader>s"` | Registers | **n** |
| `<leader>sb` | Buffer Lines | **n** |
| `<leader>sB` | Grep Open Buffers | **n** |

## Todo Comments Navigation

*Provided by todo-comments.nvim plugin for jumping between todo comments*

| Key | Description | Mode |
|-----|-------------|------|
| `]t` | Next todo comment | **n** |
| `[t` | Previous todo comment | **n** |

## Code Completion (`blink.cmp`)

*Provided by blink.cmp plugin with 'default' preset (similar to built-in completions)*

| Key | Description | Mode |
|-----|-------------|------|
| `<C-Space>` | Open completion menu or docs if menu is open | **i** |
| `<C-n>` / `<Down>` / `<C-j>` | Select next completion item | **i** |
| `<C-p>` / `<Up>` / `<C-k>` | Select previous completion item | **i** |
| `<C-y>` | Accept completion *(default preset behavior)* | **i** |
| `<C-e>` | Hide completion menu | **i** |

**Note**: `<C-k>` is customized for navigation, overriding the default signature help binding.

## Window Management

*LazyVim-style window operations with visual mnemonics*

| Key | Description | Mode |
|-----|-------------|------|
| `<leader>-` | Split Window Below *(horizontal)* | **n** |
| `<leader>|` | Split Window Right *(vertical)* | **n** |
| `<leader>we` | Make splits equal size | **n** |
| `<leader>wd` | Delete Window | **n** |
| `<leader>wm` | Toggle Window Maximize *(zoom current window)* | **n** |

## UI/Utility (`<leader>u*`)

*LazyVim-style UI and utility functions*

| Key | Description | Mode |
|-----|-------------|------|
| `<leader>uC` | Colorschemes | **n** |

## System Operations (`\`)

| Key | Description | Mode |
|-----|-------------|------|
| `\c` | Edit config (init.lua) | **n** |
| `\r` | Reload current file | **n** |
| `\w` | Toggle line wrap | **n** |
| `\n` | Toggle line numbers | **n** |

## Notes

- **Legend**: **n** = normal mode, **i** = insert mode, **v** = visual mode, **x** = visual mode, **t** = terminal mode
- Keymaps are organized by functional groups to make them easier to remember
- Most keymaps follow a two-character pattern after the leader key for consistency
