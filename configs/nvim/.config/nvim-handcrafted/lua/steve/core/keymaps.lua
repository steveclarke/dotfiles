local opts = { noremap = true, silent = true }

-- Make sure to setup `mapleader` and `maplocalleader` before loading lazy.nvim
-- so that mappings are correct.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Helper function to merge additional options with default opts
local function merge_opts(additional_opts)
  return vim.tbl_extend("force", opts, additional_opts or {})
end

-- Disable space key
vim.keymap.set("n", "<space>", "<nop>")

vim.keymap.set("i", "jj", "<Esc>", { desc = "Exit insert mode with jj" })

-- Clear search highlights automatically on escape (LazyVim style)
vim.keymap.set({ "i", "n", "s" }, "<esc>", function()
  vim.cmd("noh")
  return "<esc>"
end, { expr = true, desc = "Escape and Clear hlsearch" })

-- Scroll and center
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })

-- Center search results
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result and center" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result and center" })

-- Move lines up and down with Alt+j/k (LazyVim style)
vim.keymap.set("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
vim.keymap.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
vim.keymap.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- Reselect visual block after indenting left or right in visual mode
vim.keymap.set("v", "<", "<gv", merge_opts({ desc = "Re-select visual block after indenting left" }))
vim.keymap.set("v", ">", ">gv", merge_opts({ desc = "Re-select visual block after indenting right" }))

-- Delete single character without yanking to register 
vim.keymap.set("n", "x", '"_x', opts)

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight on yank",
  group = highlight_group,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Window management (LazyVim style)
vim.keymap.set("n", "<leader>-", "<C-w>s", { desc = "Split Window Below" }) -- horizontal split
vim.keymap.set("n", "<leader>|", "<C-w>v", { desc = "Split Window Right" }) -- vertical split
vim.keymap.set("n", "<leader>we", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
vim.keymap.set("n", "<leader>wd", "<cmd>close<CR>", { desc = "Delete Window" }) -- close current split window

-- Navigate between vim splits and tmux panes
-- NOTE: this is handled by the vim-tmux-navigator plugin

-- Paste without yanking
-- vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste over without yanking" })
-- vim.keymap.set("v", "p", '"_dp', merge_opts({ desc = "Paste over without yanking" }))

-- Uses the black-hole register so your last yank stays intact.
-- vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- System/Config operations with backslash
vim.keymap.set("n", "\\c", ":edit ~/.config/nvim/init.lua<cr>", merge_opts({ desc = "Edit config" }))
vim.keymap.set("n", "\\r", ":source %<cr>", merge_opts({ desc = "Reload current file" }))
vim.keymap.set("n", "\\w", ":set wrap!<cr>", merge_opts({ desc = "Toggle wrap" }))
vim.keymap.set("n", "\\n", ":set number!<cr>", merge_opts({ desc = "Toggle line numbers" }))

-- Quit all without saving
vim.keymap.set("n", "<leader>qq", ":qa!<CR>", merge_opts({ desc = "Quit all without saving" }))
