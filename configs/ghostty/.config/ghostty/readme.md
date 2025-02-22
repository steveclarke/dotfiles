A good example keybind config I found:

```
# -= Keybinds =-
# I want to have a leader based control
# system for ghostty (to avoid key collissions
# with other applications), where <C-s>
# is used as my leader key for operations
# while the meta/alt key is used for
# movement within the multiplexed terminals

# -= Commands =-

# General
keybind = ctrl+s>r=reload_config
keybind = ctrl+s>a=select_all
keybind = ctrl+s>c=copy_to_clipboard
keybind = ctrl+s>v=paste_from_clipboard
keybind = ctrl+s>k>i>l>l=close_surface
# Currently not working
# keybind = ctrl+s>t>i=inspector


# Window stuff
keybind = ctrl+s>w>n=new_window
keybind = ctrl+s>w>d=toggle_window_decorations
keybind = ctrl+s>w>f=toggle_fullscreen
# Note This requires you to have the right editor set via xdg. 
# This can be done with `xdg-mime default nvim.desktop text/plain`
keybind = ctrl+s>w>s=write_screen_file:open

# Tab and splits (panes)
keybind = ctrl+s>t>n=new_tab
keybind = ctrl+s>p>n=new_split:auto
keybind = ctrl+s>p>r=new_split:right
keybind = ctrl+s>p>l=new_split:left
keybind = ctrl+s>p>u=new_split:up
keybind = ctrl+s>p>d=new_split:down
keybind = ctrl+s>p>f=toggle_split_zoom

keybind = alt>equal=equalize_splits
keybind = alt>,=resize_split:left,10
keybind = alt>.=resize_split:right,10
keybind = alt>6=resize_split:up,10
keybind = alt>7=resize_split:down,10




# -= Navigation =-

# Split navigation
# NOTE: Currently (januari 10th) the split movement is 
# somewhat broken on linux, the issue is known and 
# is actively worked on I believe.
keybind = alt+h=goto_split:left
keybind = alt+j=goto_split:bottom
keybind = alt+k=goto_split:top
keybind = alt+l=goto_split:right

# Tab navigation
keybind = alt+[=previous_tab
keybind = alt+]=next_tab

# Prompt navigation
keybind = alt+b=jump_to_prompt:-1
keybind = alt+f=jump_to_prompt:1
```
