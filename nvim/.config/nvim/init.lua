local vscode = vim.g.vscode

--
-- [ PLUGINS ]
--
local lazypath = vim.fn.stdpath("data") .. "lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

-- NOTE: Add enabled = not vscode to skip loading a plugin if in vscode
require("lazy").setup({
  {
    "kylechui/nvim-surround",
    version = "*",
    config = function()
      require("nvim-surround").setup({})
    end
  }
})

-- <leader> key is <space>
vim.g.mapleader = " "

-- Open init.lua with <leader>i
vim.cmd("nmap <leader>i :e ~/.config/nvim/init.lua<cr>")

--
-- [ OPTIONS ]
--

-- Use system clipboard
vim.opt.clipboard = "unnamedplus"

vim.opt.ignorecase = true
vim.opt.smartcase = true

--
-- [ KEYMAPS ]
--

-- Redo with opposite of undo
vim.keymap.set("n", "U", "<C-r>")

-- Clear search highlights
vim.keymap.set("n", "<leader>/", "<cmd>nohlsearch<cr>")

-- Better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  group = highlight_group,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank()
  end,
})
