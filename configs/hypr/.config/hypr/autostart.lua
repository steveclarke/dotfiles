-- Apps launched at login, onto whichever workspace is active.

hl.on("hyprland.start", function()
  hl.exec_cmd(o.launch("google-chrome-stable"))
  hl.exec_cmd(o.launch("todoist"))
  hl.exec_cmd(o.launch("slack"))
  hl.exec_cmd(o.launch("nautilus --new-window"))
end)
