local vscode = vim.g.vscode

--
-- [[ PLUGINS ]]
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

local lazy_opts = {
  ui = { border = "rounded" }
}
-- NOTE: Add enabled = not vscode to skip loading a plugin if in vscode
require("lazy").setup({
  {
    "kylechui/nvim-surround",
    version = "*",
    config = function()
      require("nvim-surround").setup({})
    end
  },
  {
    "catppuccin/nvim",
    enable = not vscode,
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({ })
      vim.cmd.colorscheme("catppuccin")
    end
  }
}, lazy_opts)

-- <leader> key is <space>
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.keymap.set("n", "<space>", "<nop>")

-- Open init.lua with <leader>i
vim.cmd("nmap <leader>i :e ~/.config/nvim/init.lua<cr>")

--
-- [[ OPTIONS ]]
--
-- Use system clipboard
vim.opt.clipboard = "unnamedplus"

vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.hlsearch = true

if not vscode then
  -- tabs / indentation
  vim.opt.tabstop = 2
  vim.opt.shiftwidth = 2
  vim.opt.softtabstop = 2
  vim.opt.expandtab = true
  vim.opt.smartindent = true
  vim.opt.wrap = false

  -- line numbers
  vim.opt.number = true
  vim.opt.relativenumber = false
  vim.opt.numberwidth = 2

  -- window splitting
  vim.opt.splitbelow = true
  vim.opt.splitright = true

  -- enable 24-bit color
  vim.opt.termguicolors = true

  vim.opt.colorcolumn = "100"

  -- always show the sign column, otherwise it would shift the text each time
  vim.opt.signcolumn = "yes"

  -- highlight the current line
  vim.opt.cursorline = true
end

--
-- [[ KEYMAPS ]]
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
