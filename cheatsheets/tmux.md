# tmux Cheatsheet

**Prefix:** `Ctrl+Space` (also `Ctrl+B`) · **Config:** `~/.config/tmux/tmux.conf`

## Panes

| Action            | No-prefix              | Prefix     |
|-------------------|------------------------|------------|
| Move L/D/U/R      | `Alt+h/j/k/l` · `Ctrl+Alt+←↓↑→` | — |
| Split right       | `Alt+r`                | `v` · `\|` |
| Split down        | `Alt+d`                | `h` · `-`  |
| Resize ±5         | `Ctrl+Alt+Shift+←↓↑→`  | `←↓↑→` (repeatable) |
| Zoom toggle       | `Alt+f`                | `z`        |
| Kill              | `Alt+x`                | `x`        |
| Swap (spatial)    | `Shift+←↓↑→`           | —          |

## Windows

| Action            | No-prefix         | Prefix |
|-------------------|-------------------|--------|
| New (in cwd)      | `Alt+c`           | `c`    |
| Prev / Next       | `Alt+,` / `Alt+.` · `Alt+Shift+H` / `Alt+Shift+L` · `Alt+←` / `Alt+→` | — |
| Jump to N         | `Alt+1`..`Alt+9`  | —      |
| Swap left / right | `Alt+Shift+←` / `Alt+Shift+→` | — |
| Rename            | —                 | `r`    |
| Kill              | —                 | `k`    |

## Sessions

| Action       | No-prefix           | Prefix |
|--------------|---------------------|--------|
| Prev / Next  | `Alt+Shift+K` / `Alt+Shift+J` · `Alt+↑` / `Alt+↓` | `P` / `N` |
| New (in cwd) | —                   | `C`    |
| Rename       | —                   | `R`    |
| Kill         | —                   | `K`    |
| Picker       | —                   | `s` (default) |

## Special

| Action              | Key            |
|---------------------|----------------|
| Popup lazygit       | `Alt+p` (open) · `q` (close)                |
| Scratchpad toggle   | `Alt+s`        |
| Reload config       | `Prefix q`     |

## Copy Mode (vi)

Enter: `Prefix [` · Exit: `q` or `Enter`

| Key           | Action                       |
|---------------|------------------------------|
| `h/j/k/l`     | Move                         |
| `w` / `b`     | Next / previous word         |
| `f<c>` / `F<c>` | Jump fwd / back to char    |
| `/` / `?`     | Search forward / backward    |
| `n` / `N`     | Next / previous match        |
| `v`           | Begin selection              |
| `y`           | Copy selection (and exit)    |
| `0` / `$`     | Line start / end             |
| `g` / `G`     | Top / bottom                 |

## Status Bar Indicators

`COPY` = in copy mode · `PREFIX` = prefix held · `ZOOM` = pane zoomed · windows show as `#I:#W`

## Useful Notes

- Mouse is on: drag to select, scroll to enter copy mode, drag pane borders to resize.
- Windows auto-rename to `basename($PWD)`. Override with `Prefix r`.
- `detach-on-destroy off`: closing the last window switches sessions instead of detaching.
- History: 50,000 lines. Clipboard sync: on (OSC 52).
