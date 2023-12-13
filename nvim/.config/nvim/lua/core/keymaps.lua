local keymap = vim.keymap
local core = require("utils.core")

-- Nvim Tree Explorer
-- keymap.set("n", "<leader>e", vim.cmd.NvimTreeFocus, { desc = "Focus file explorer" })
keymap.set("n", "<leader>e", vim.cmd.NvimTreeFocus, core.options({ desc = "Focus file explorer" }))
keymap.set("n", "<leader>fe", vim.cmd.NvimTreeToggle, core.options({ desc = "Toggle file explorer" }))

-- Map Ctrl-l to move to the window on the right
keymap.set("n", "<C-l>", "<C-w>l", core.options())
keymap.set("n", "<C-h>", "<C-w>h", core.options())
keymap.set("n", "<C-j>", "<C-w>j", core.options())
keymap.set("n", "<C-k>", "<C-w>k", core.options())

-- Redo with opposite of undo
keymap.set("n", "U", "<C-r>", core.options())

-- Clear search highlight
keymap.set("n", "<leader>/", "<cmd>noh<CR>", core.options({ desc = "Clear search highlights" }))

-- Move current line / block with Alt-u/i ala vscode.
-- Note: not using Alt-j/k because they're used by Zellij
keymap.set("n", "<A-u>", ":m .+1<CR>==", core.options())
keymap.set("n", "<A-i>", ":m .-2<CR>==", core.options())
keymap.set("i", "<A-u>", "<Esc>:m .+1<CR>==gi", core.options())
keymap.set("i", "<A-i>", "<Esc>:m .-2<CR>==gi", core.options())
keymap.set("v", "<A-u>", ":m '>+1<CR>gv-gv", core.options())
keymap.set("v", "<A-i>", ":m '<-2<CR>gv-gv", core.options())

-- Better indenting
keymap.set("v", "<", "<gv", core.options())
keymap.set("v", ">", ">gv", core.options())

-- [[ Splits ]]
keymap.set("n", "<leader>sv", vim.cmd.vsplit, core.options({ desc = "Split vertically" }))
keymap.set("n", "<leader>sh", vim.cmd.split, core.options({ desc = "Split horizontally" }))
keymap.set("n", "-ss", ":new<cr>", core.options({ desc = "Open split with new buffer" }))
keymap.set("n", "-vv", ":vnew<cr>", core.options({ desc = "Open vertical split with new buffer" }))
keymap.set("n", "-tb", ":tabnew %<cr>", core.options({ desc = "Open current buffer in new tab" }))
keymap.set("n", "-tt", ":tabnew<cr>", core.options({ desc = "Open new tab" }))

-- Commenting - Ctrl-/ to toggle comments in normal/visual mode.
keymap.set("n", "<C-_>", "<Plug>(comment_toggle_linewise_current)", core.options())
keymap.set("x", "<C-_>", "<Plug>(comment_toggle_linewise_visual)gv", core.options())

-- Reformat code
vim.keymap.set(
  { "n", "v" },
  "<leader>rf",
  "<cmd>lua vim.lsp.buf.format({async=true})<CR>",
  core.options({ desc = "Reformat code" })
)

-- Resize splits with ctrl keys
keymap.set("n", "<C-Up>", ":resize -2<CR>", core.options())
keymap.set("n", "<C-Down>", ":resize +2<CR>", core.options())
keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", core.options())
keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", core.options())

-- Copy the current line or visual selection down
keymap.set("n", "<leader>yp", ":copy .<cr>", core.options({ desc = "Yank and paste line" }))
keymap.set("n", "<C-d>", ":copy .<cr>", core.options())
keymap.set("v", "<leader>yp", ":copy '<,'>.<CR>", core.options({ desc = "Yank and paste selection" }))
keymap.set("v", "<C-d>", ":copy '<,'>.<CR>", core.options())
