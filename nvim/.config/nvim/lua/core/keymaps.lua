local keymap = vim.keymap
local options = require("utils.core").keymap_options

-- Nvim Tree Explorer
keymap.set("n", "<leader>e", vim.cmd.NvimTreeFocus, options({ desc = "Focus file explorer" }))
keymap.set("n", "<leader>fe", vim.cmd.NvimTreeToggle, options({ desc = "Toggle file explorer" }))

-- Map Ctrl-l to move to the window on the right
keymap.set("n", "<C-l>", "<C-w>l", options())
keymap.set("n", "<C-h>", "<C-w>h", options())
keymap.set("n", "<C-j>", "<C-w>j", options())
keymap.set("n", "<C-k>", "<C-w>k", options())

-- Redo with opposite of undo
keymap.set("n", "U", "<C-r>", options())

-- Clear search highlight
keymap.set("n", "<leader>/", "<cmd>noh<CR>", options({ desc = "Clear search highlights" }))

-- Move current line / block with Alt-u/i ala vscode.
-- Note: not using Alt-j/k because they're used by Zellij
keymap.set("n", "<A-u>", ":m .+1<CR>==", options())
keymap.set("n", "<A-i>", ":m .-2<CR>==", options())
keymap.set("i", "<A-u>", "<Esc>:m .+1<CR>==gi", options())
keymap.set("i", "<A-i>", "<Esc>:m .-2<CR>==gi", options())
keymap.set("v", "<A-u>", ":m '>+1<CR>gv-gv", options())
keymap.set("v", "<A-i>", ":m '<-2<CR>gv-gv", options())

-- Better indenting
keymap.set("v", "<", "<gv", options())
keymap.set("v", ">", ">gv", options())

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

-- Resize splits with ctrl keys
keymap.set("n", "<C-Up>", ":resize -2<CR>", options())
keymap.set("n", "<C-Down>", ":resize +2<CR>", options())
keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", options())
keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", options())

-- Copy the current line or visual selection down
keymap.set("n", "<leader>yp", ":copy .<cr>", options({ desc = "Yank and paste line" }))
keymap.set("n", "<C-d>", ":copy .<cr>", options())
keymap.set("v", "<leader>yp", ":copy '<,'>.<CR>", options({ desc = "Yank and paste selection" }))
keymap.set("v", "<C-d>", ":copy '<,'>.<CR>", options())

keymap.set("n", "<leader>qq", ":qa!<CR>", options({ desc = "Quit all without saving" }))
