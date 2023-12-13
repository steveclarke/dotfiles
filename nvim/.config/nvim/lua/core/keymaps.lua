local keymap = vim.keymap

local opts = { noremap = true, silent = true }

-- Nvim Tree Explorer
keymap.set("n", "<leader>e", vim.cmd.NvimTreeFocus, { desc = "Focus file explorer" })
keymap.set("n", "<leader>fe", vim.cmd.NvimTreeToggle, { desc = "Toggle file explorer" })

-- Map Ctrl-l to move to the window on the right
keymap.set("n", "<C-l>", "<C-w>l", opts)
keymap.set("n", "<C-h>", "<C-w>h", opts)
keymap.set("n", "<C-j>", "<C-w>j", opts)
keymap.set("n", "<C-k>", "<C-w>k", opts)

-- Redo with opposite of undo
keymap.set("n", "U", "<C-r>", opts)

-- Clear search highlight
keymap.set("n", "<leader>/", "<cmd>noh<CR>", { desc = "Clear search highlights" })

-- Move current line / block with Alt-j/k ala vscode.
keymap.set("n", "<A-j>", ":m .+1<CR>==", opts)
keymap.set("n", "<A-k>", ":m .-2<CR>==", opts)
keymap.set("i", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
keymap.set("i", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)
keymap.set("v", "<A-j>", ":m '>+1<CR>gv-gv", opts)
keymap.set("v", "<A-k>", ":m '<-2<CR>gv-gv", opts)

-- Better indenting
keymap.set("v", "<", "<gv", opts)
keymap.set("v", ">", ">gv", opts)

-- [[ Splits ]]
-- keymap.set("n", "<leader>sv", vim.cmd.vsplit, opts)
-- keymap.set("n", "<leader>sh", vim.cmd.split, opts)
-- open splits with new buffers
keymap.set("n", "-ss", ":new<CR>", opts)
keymap.set("n", "-vv", ":vnew<CR>", opts)
keymap.set("n", "-tb", ":tabnew %<CR>", opts)
keymap.set("n", "-tt", ":tabnew<CR>", opts)

-- Commenting
-- FIXME: This doesn't work properly. It's supposed to map Ctrl-/ to comment/uncomment
-- keymap.set("n", "<C-_>", "gcc", { noremap = false })
-- keymap.set("v", "<C-_>", "gcc", { noremap = false })

-- Reformat code
vim.keymap.set("n", "<leader>rf", "<cmd>lua vim.lsp.buf.format({async=true})<CR>")

-- Resize splits with ctrl keys
keymap.set("n", "<C-Up>", ":resize -2<CR>", opts)
keymap.set("n", "<C-Down>", ":resize +2<CR>", opts)
keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", opts)
