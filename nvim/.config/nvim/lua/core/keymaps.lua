local keymap = vim.keymap

local opts = { noremap = true, silent = true }
--
-- [[ Directory Navigation ]]
keymap.set("n", "<leader>m", vim.cmd.NvimTreeFocus, opts)
keymap.set("n", "<leader>e", vim.cmd.NvimTreeToggle, opts)

