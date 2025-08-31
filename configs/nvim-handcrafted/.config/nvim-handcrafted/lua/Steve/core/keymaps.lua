local opts = { noremap = true, silent = true }

-- Helper function to merge additional options with default opts
local function merge_opts(additional_opts)
  return vim.tbl_extend("force", opts, additional_opts or {})
end

-- Disable space key
vim.keymap.set("n", "<space>", "<nop>")

-- Clear search highlights
vim.keymap.set("n", "<leader>/", "<cmd>nohlsearch<cr>", { desc = "Clear search highlights" })

-- Scroll and center
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })

-- Center search results
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result and center" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result and center" })

-- Move lines up and down in visual mode
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move the current line up in visual mode" })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move the current line down in visual mode" })

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

-- Paste without yanking
-- vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste over without yanking" })
-- vim.keymap.set("v", "p", '"_dp', merge_opts({ desc = "Paste over without yanking" }))

-- Uses the black-hole register so your last yank stays intact.
-- vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])
