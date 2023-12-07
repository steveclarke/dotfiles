local opt = vim.opt

-- [[ Tabs / Indentation ]]
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true
opt.wrap = false

-- [[ Line numbers ]]
opt.number = true
opt.relativenumber = true
opt.numberwidth = 2

-- [[ Window splitting ]]
opt.splitbelow = true
opt.splitright = true

-- [[ Search ]]
opt.incsearch = true
-- Case insensitive searching unless /C or capitilization is used in search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true

-- enable 24-bit color
opt.termguicolors = true

opt.colorcolumn = "100"

-- always show the sign column, otherwise it would shift the text each time
opt.signcolumn = "yes"

-- highlight the current line
opt.cursorline = true

-- add more space in the command line for displaying messages
-- opt.cmdheight = 1

-- minimal number of screen lines to keep above and below the cursor.
opt.scrolloff = 8
--  The minimal number of screen columns to keep to the left and to the right
--  of the cursor if 'nowrap' is set.
opt.sidescrolloff = 8

opt.errorbells = false
opt.swapfile = false
opt.backup = false
opt.mouse:append("a")
opt.clipboard:append("unnamedplus")
opt.encoding = "UTF-8"

-- [[ Undo ]]
-- opt.undodir = vim.fn.expand("~/.vim/undodir")
-- opt.undofile = true

-- opt.autochdir = false
-- opt.iskeyword:append("-")
-- opt.hidden = true
-- opt.backspace = "indent,eol,start"
-- opt.modifiable = true

-- opt.completeopt = "menu,preview"
-- opt.completeopt = "menuone,noinsert,noselect"

-- opt.guicursor =	"n-v-c:block,i-ci-ve:block,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"

-- Don't automatically add comment on newline above/below
-- FIXME: Get this working. Doesn't seem to work.
opt.formatoptions:remove({ "c", "r", "o" })
