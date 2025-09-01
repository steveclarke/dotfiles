# ⌨️ Keymaps

This configuration uses a structured approach to keymaps, inspired by [LazyVim's organization](https://www.lazyvim.org/keymaps).

## Keymap Philosophy

- **`<leader>` = `<Space>`** - Primary leader key for most functionality
- **`<localleader>` = `\`** - Secondary leader for system/config operations
- **Grouped by function** - Related commands share a common prefix (e.g., all explorer commands under `<leader>e*`)
- **Mnemonic naming** - Second letter indicates specific action (`f` = focus, `r` = reveal, etc.)
- **No comma remapping** - Preserve comma for f/F/t/T motion reversals in Markdown editing

## Table of Contents

- [⌨️ Keymaps](#️-keymaps)
  - [Keymap Philosophy](#keymap-philosophy)
  - [Table of Contents](#table-of-contents)
  - [General](#general)
  - [File Explorer (`<leader>e*`)](#file-explorer-leadere)
  - [Window Navigation](#window-navigation)
  - [Split Management (`<leader>s*`)](#split-management-leaders)
  - [System Operations (`\`)](#system-operations-)
  - [Notes](#notes)

## General

| Key | Description | Mode |
|-----|-------------|------|
| `jj` | Exit insert mode | **i** |
| `<leader>/` | Clear search highlights | **n** |
| `<C-d>` | Scroll down and center *(default: just scroll down)* | **n** |
| `<C-u>` | Scroll up and center *(default: just scroll up)* | **n** |
| `n` | Next search result and center *(default: just next result)* | **n** |
| `N` | Previous search result and center *(default: just previous result)* | **n** |
| `x` | Delete char without yanking *(default: yanks to register)* | **n** |
| `<` / `>` | Indent and reselect *(default: loses selection)* | **v** |
| `K` | Move line up *(default: show man page)* | **v** |
| `J` | Move line down *(default: join lines)* | **v** |

## File Explorer (`<leader>e*`)

| Key | Description | Mode |
|-----|-------------|------|
| `<leader>ee` | Toggle file explorer | **n** |
| `<leader>ef` | Focus file explorer | **n** |
| `<leader>er` | Reveal current file | **n** |
| `<leader>eg` | Toggle git explorer | **n** |
| `<leader>eb` | Toggle buffer explorer | **n** |

## Window Navigation

*Provided by the vim-tmux-navigator plugin*

| Key | Description | Mode |
|-----|-------------|------|
| `<C-h>` | Go to left window | **n** |
| `<C-j>` | Go to lower window | **n** |
| `<C-k>` | Go to upper window | **n** |
| `<C-l>` | Go to right window | **n** |

## Split Management (`<leader>s*`)

| Key | Description | Mode |
|-----|-------------|------|
| `<leader>sv` | Split window vertically | **n** |
| `<leader>sh` | Split window horizontally | **n** |
| `<leader>se` | Make splits equal size | **n** |
| `<leader>sx` | Close current split | **n** |

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
