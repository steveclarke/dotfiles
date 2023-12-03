require("core")

local opt = vim.opt

-- [[ Indentation ]]
opt.shiftwidth = 2
opt.tabstop = 2
opt.expandtab = true
opt.smartindent = true

-- [[ Line numbers ]]
opt.number = true
opt.relativenumber = true
opt.numberwidth = 2

-- [[ Window splitting ]]
opt.splitbelow = true
opt.splitright = true

-- highlight the current line
opt.cursorline = true

-- always show the sign column, otherwise it would shift the text each time
opt.signcolumn = "yes"

-- enable 24-bit color
opt.termguicolors = true
