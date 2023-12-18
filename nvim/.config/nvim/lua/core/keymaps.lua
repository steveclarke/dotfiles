local keymap = vim.keymap
local options = require("utils.core").keymap_options

-- File explorer
keymap.set("n", "<leader>e", "<cmd>Neotree filesystem toggle left<cr>", options({ desc = "Toggle file explorer" }))
keymap.set("n", ",e", "<cmd>Neotree filesystem focus left<cr>", options({ desc = "Focus file explorer" }))
-- TODO: add keymap for opening file explorer in current file's directory
keymap.set("n", "<leader>ge", "<cmd>Neotree git_status toggle float<cr>", options({ desc = "Toggle git explorer" }))
keymap.set("n", "<leader>be", "<cmd>Neotree buffers toggle float<cr>", options({ desc = "Toggle buffer explorer" }))

-- Move to windows using <ctrl> hjkl
keymap.set("n", "<C-l>", "<C-w>l", options())
keymap.set("n", "<C-h>", "<C-w>h", options())
keymap.set("n", "<C-j>", "<C-w>j", options())
keymap.set("n", "<C-k>", "<C-w>k", options())

-- Resize window with <ctrl> arrow keys
keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", options({ desc = "Increase window height" }))
keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", options({ desc = "Decrease window height" }))
keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", options({ desc = "Decrease window width" }))
keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", options({ desc = "Increase window width" }))

-- Redo with opposite of undo
keymap.set("n", "U", "<C-r>", options())

-- Clear search highlight
keymap.set("n", "<leader>/", "<cmd>noh<CR>", options({ desc = "Clear search highlights" }))

-- Move current line / block with <alt> u/i ala vscode.
-- Note: not using Alt-j/k because they're used by Zellij
keymap.set("n", "<A-u>", "<cmd>m .+1<cr>==", options())
keymap.set("n", "<A-i>", "<cmd>m .-2<cr>==", options())
keymap.set("i", "<A-u>", "<esc><cmd>m .+1<cr>==gi", options())
keymap.set("i", "<A-i>", "<esc><cmd>m .-2<cr>==gi", options())
keymap.set("v", "<A-u>", "<cmd>m '>+1<cr>gv=gv", options())
keymap.set("v", "<A-i>", "<cmd>m '<-2<cr>gv=gv", options())

-- Better indenting
keymap.set("v", "<", "<gv", options())
keymap.set("v", ">", ">gv", options())

-- Buffers
keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", options({ desc = "Prev buffer" }))
keymap.set("n", "<S-l>", "<cmd>bnext<cr>", options({ desc = "Next buffer" }))
keymap.set("n", "[b", "<cmd>bprevious<cr>", options({ desc = "Prev buffer" }))
keymap.set("n", "]b", "<cmd>bnext<cr>", options({ desc = "Next buffer" }))
keymap.set("n", "<leader>bb", "<cmd>e #<cr>", options({ desc = "Switch to Other Buffer" }))
keymap.set("n", "<leader>`", "<cmd>e #<cr>", options({ desc = "Switch to Other Buffer" }))

-- [[ Splits ]]
keymap.set("n", ",s", ":new<cr>", options({ desc = "Open split with new buffer" }))
keymap.set("n", ",v", ":vnew<cr>", options({ desc = "Open vertical split with new buffer" }))
keymap.set("n", ",tb", ":tabnew %<cr>", options({ desc = "Open current buffer in new tab" }))
keymap.set("n", ",tt", ":tabnew<cr>", options({ desc = "Open new tab" }))

-- Commenting - Ctrl-/ to toggle comments in normal/visual mode.
keymap.set("n", "<C-_>", "<Plug>(comment_toggle_linewise_current)", options())
keymap.set("x", "<C-_>", "<Plug>(comment_toggle_linewise_visual)gv", options())

-- Reformat code
vim.keymap.set(
  { "n", "v" },
  "<leader>rf",
  "<cmd>lua vim.lsp.buf.format({async=true})<CR>",
  options({ desc = "Reformat code" })
)

-- Copy the current line or visual selection down
keymap.set("n", "<leader>yp", ":copy .<cr>", options({ desc = "Yank and paste line" }))
keymap.set("n", "<C-d>", ":copy .<cr>", options())
keymap.set("v", "<leader>yp", ":copy '<,'>.<CR>", options({ desc = "Yank and paste selection" }))
keymap.set("v", "<C-d>", ":copy '<,'>.<CR>", options())

keymap.set("n", "<leader>qq", ":qa!<CR>", options({ desc = "Quit all without saving" }))

-- Persistence (session manager)
vim.api.nvim_set_keymap("n", "<leader>sr", [[<cmd>lua require("persistence").load({ last = true })<cr>]],
  options({ desc = "Restore last session" }))
vim.api.nvim_set_keymap("n", "<leader>sd", [[<cmd>lua require("persistence").load()<cr>]],
  options({ desc = "Restore session for current directory" }))
