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

-- [[ Scrolloff ]]
-- minimal number of screen lines to keep above and below the cursor.
opt.scrolloff = 10
-- opt.scrolloff = 999
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

opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldenable = false
opt.foldlevel = 99

-- Allow the block to expand into lines where there are no characters
opt.virtualedit = "block"

-- Show partial off-screen substitute results in a preview window
-- i.e. :%s/foo/bar results will show in preview window, so that
-- if substitutions are spread through the fille we can see them
-- consolidated before accepting the change.
opt.inccommand = "split"

-- Don't automatically add comment on newline above/below.
-- ** freaking annoying, don't know why this is default! **
-- Has to be done in an autocmd because Neovim sets it in after/ftplugin/lua.lua
-- So not only is it the most annoying default ever (well aside from the bell in vim)
-- but it was hell to figure out how to unset it.
-- See: https://www.reddit.com/r/neovim/comments/sqld76/stop_automatic_newline_continuation_of_comments/
vim.api.nvim_create_autocmd("FileType", { command = "set formatoptions-=cro" })

-- Use ripgrep if available
if vim.fn.executable("rg") == 1 then
  opt.grepprg = "rg --vimgrep --no-heading --smart-case"
end

-- Allow loading from a local .exrc, .nvimrc, .nvim.lua
opt.exrc = true
