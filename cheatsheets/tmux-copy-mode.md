---
title: Copying Text in tmux
author: Steve's dotfiles
---

# Copying Text in tmux

There is a small trick at the heart of copying text in tmux: you are not copying from the terminal in the normal way.

Most of the time, your terminal shows whatever the shell, editor, log command, or REPL is printing right now. tmux sits between that program and the terminal. It keeps its own history for each pane. When you scroll back inside tmux, you are moving through tmux's memory of that pane, not through the terminal's native scrollback.

That is why tmux has **copy mode**. Copy mode is tmux's little reader. It lets you pause the pane, walk backward through its history, select text, and copy it.

Your config makes that reader feel like Vim.

```tmux
setw -g mode-keys vi
```

That one line tells tmux to use vi-style keys in copy mode. So instead of arrow-only movement, you get familiar motions like `h`, `j`, `k`, `l`, `w`, `b`, `/`, and `?`.

## Entering Copy Mode

Your tmux prefix is `Ctrl+Space`.

```tmux
set -g prefix C-Space
set -g prefix2 C-b
```

`Ctrl+B` still works as a second prefix, but `Ctrl+Space` is the main one. To enter copy mode, press:

```text
Ctrl+Space [
```

In tmux language, that is:

```text
Prefix [
```

Once you press it, the pane stops behaving like an active shell for a moment. You are now looking at tmux's scrollback. You can move around without sending keys to the program running in the pane.

This matters. If you are looking at a long command output, a stack trace, or a log, copy mode lets you inspect it without disturbing the shell.

## Moving Around

Because your config uses vi keys, the basic movement keys are:

```text
h   left
j   down
k   up
l   right
```

Those are tmux defaults in vi copy mode. Your config adds a few more bindings on purpose:

```tmux
bind -T copy-mode-vi w send -X next-word
bind -T copy-mode-vi b send -X previous-word
bind -T copy-mode-vi f send -X jump-to-char
bind -T copy-mode-vi F send -X jump-to-char -b
```

So you can use:

```text
w       next word
b       previous word
f<char> jump forward to a character
F<char> jump backward to a character
```

For example, if a line contains a path like this:

```text
/home/steve/.local/share/dotfiles/configs/tmux/.config/tmux/tmux.conf
```

You can press `f.` to jump forward to the next dot, or `f/` to jump forward to the next slash. If you overshoot, `F/` searches backward for a slash.

You also get the usual vi-style search keys:

```text
/       search forward
?       search backward
n       next match
N       previous match
```

Search is often the fastest way to copy from output. Enter copy mode, press `/`, type part of the thing you remember, then press `Enter`.

## Selecting Text

In your config, selection starts with `v`:

```tmux
bind -T copy-mode-vi v send -X begin-selection
```

This mirrors visual mode in Vim. Move the cursor to the start of the text, press `v`, then move to the end of the text.

A normal copy flow looks like this:

```text
Ctrl+Space [    enter copy mode
/error          search for "error"
Enter           jump to the match
v               begin selection
j or l or w     extend the selection
y               copy and leave copy mode
```

You do not need to hold Shift. You do not need to drag with the mouse. You are selecting from inside tmux itself.

Mouse selection still exists because your config has:

```tmux
set -g mouse on
```

But keyboard selection is more reliable once you get used to it. It also works well over SSH, inside nested sessions, and in panes where mouse selection would grab the wrong layer.

## Copying

Your copy key is `y`:

```tmux
bind -T copy-mode-vi y send -X copy-selection-and-cancel
```

That command does two things:

1. It copies the selected text into tmux's copy buffer.
2. It exits copy mode.

So `y` means "copy this, then take me back to the pane."

tmux has its own internal clipboard, called a **buffer**. When you copy text, tmux stores it there. You can paste that buffer later with tmux's paste command.

But your config goes one step further:

```tmux
set -g set-clipboard on
```

That tells tmux to try to sync copied text to the system clipboard through the terminal. The mechanism is usually called **OSC 52**. It is a terminal escape sequence that says, in effect, "please put this text on the clipboard."

When your terminal supports it, this is the magic that makes `y` feel like a normal desktop copy. You select inside tmux, press `y`, and then paste somewhere else.

## The Mental Model

The easiest way to understand tmux copying is to picture three layers:

```text
Program output
     |
tmux pane history
     |
terminal window
```

Your shell, editor, or command writes text. tmux receives that text and keeps a history for the pane. Your terminal displays what tmux sends it.

Copy mode works in the middle layer. You are not asking the running program for text. You are asking tmux to look through what it has already seen.

That is why copy mode can grab output from a command that has already finished. The program is gone, but tmux still has the text in pane history.

Your history limit is generous:

```tmux
set -g history-limit 50000
```

That gives each pane 50,000 lines of scrollback. Copy mode is how you walk through those lines.

## A Few Useful Habits

If you need one line, search first. Press `Ctrl+Space [`, then `/`, then type a word from the line. This is faster than paging around.

If you need a path, use `f/`, `F/`, `w`, and `b` to move by shape. Paths have lots of useful landmarks.

If you need a block, move to the top-left corner of the block, press `v`, move to the bottom-right corner, then press `y`.

If you get lost, press `q` to leave copy mode.

## Your Copy Mode Cheat Sheet

Here is the whole flow in one place:

| Key | Meaning |
| --- | --- |
| `Ctrl+Space [` | Enter copy mode |
| `q` | Leave copy mode |
| `h` / `j` / `k` / `l` | Move left / down / up / right |
| `w` / `b` | Move next / previous word |
| `f<char>` | Jump forward to a character |
| `F<char>` | Jump backward to a character |
| `/` / `?` | Search forward / backward |
| `n` / `N` | Next / previous search match |
| `v` | Begin selection |
| `y` | Copy selection and leave copy mode |

The short version is:

```text
Prefix [   look through pane history
v          start selecting
y          copy and return
```

Once that clicks, tmux copying stops feeling like a special case. It becomes a quiet habit: step into the pane's memory, mark what you need, and bring it back with you.
