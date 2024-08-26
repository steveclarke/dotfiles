-- <leader> key is <space>
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.keymap.set("n", "<space>", "<nop>")

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
require("lazy").setup("plugins", lazy_opts)

-- [[ OPTIONS ]]
--
-- Use system clipboard
vim.opt.clipboard = "unnamedplus"

vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.hlsearch = true

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

-- add more space in the command line for displaying messages
-- opt.cmdheight = 1

vim.opt.errorbells = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.mouse:append("a")
vim.opt.encoding = "UTF-8"

-- scrolloff
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 8

-- folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false
vim.opt.foldlevel = 99

-- Allow the block to expand into lines where there are no characters
vim.opt.virtualedit = "block"

-- Show partial off-screen substitute results in a preview window
-- i.e. :%s/foo/bar results will show in preview window, so that
-- if substitutions are spread through the fille we can see them
-- consolidated before accepting the change.
vim.opt.inccommand = "split"

-- Use ripgrep if available
if vim.fn.executable("rg") == 1 then
vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case"
end

-- Allow loading from a local .exrc, .nvimrc, .nvim.lua
vim.opt.exrc = true

-- Don't automatically add comment on newline above/below.
-- Has to be done in an autocmd because Neovim sets it in
-- after/ftplugin/lua.lua So not only is it the most annoying default ever
-- (well aside from the bell in vim) but it was hell to figure out how to
-- unset it.
-- See: https://www.reddit.com/r/neovim/comments/sqld76/stop_automatic_newline_continuation_of_comments/
vim.api.nvim_create_autocmd("FileType", { command = "set formatoptions-=cro" })
