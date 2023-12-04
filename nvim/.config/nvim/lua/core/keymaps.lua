local keymap = vim.keymap

local opts = { noremap = true, silent = true }

-- [[ Directory Navigation ]]
keymap.set("n", "<leader>m", vim.cmd.NvimTreeFocus, opts)
keymap.set("n", "<leader>e", vim.cmd.NvimTreeToggle, opts)

-- Map Ctrl-l to move to the window on the right
keymap.set("n", "<C-l>", "<C-w>l", opts)
keymap.set("n", "<C-h>", "<C-w>h", opts)
keymap.set("n", "<C-j>", "<C-w>j", opts)
keymap.set("n", "<C-k>", "<C-w>k", opts)

-- Redo with opposite of undo
keymap.set("n", "U", "<C-r>", opts)

-- Clear search highlight
keymap.set("n", "<leader>/", "<cmd>noh<CR>", opts)

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

