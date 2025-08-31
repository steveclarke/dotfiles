-- Enable editorconfig support
vim.g.editorconfig = true

-- Configure netrw to use tree style directory listing
vim.g.netrw_liststyle = 3

-- Hide the banner in netrw file explorer for cleaner interface
-- vim.cmd("let g:netrw_banner = 0")

-- Use block cursor in all modes instead of thin line cursor
vim.opt.guicursor = ""

-- Use system clipboard for all yank/delete/put operations
vim.opt.clipboard:append("unnamedplus")

-- Show search matches incrementally as you type the search pattern
vim.opt.incsearch = true

-- Make searches case-insensitive by default
vim.opt.ignorecase = true

-- Override ignorecase when search pattern contains uppercase letters (unless you use \C)
vim.opt.smartcase = true

-- Highlight all matches of the current search pattern
vim.opt.hlsearch = true

-- Set tab width to 2 spaces when displaying existing tabs
vim.opt.tabstop = 2

-- Set indentation width to 2 spaces for auto-indent operations
vim.opt.shiftwidth = 2

-- Make Tab key insert 2 spaces in insert mode
vim.opt.softtabstop = 2

-- Convert tabs to spaces when inserting new indentation
vim.opt.expandtab = true

-- Enable smart auto-indenting for new lines based on syntax
vim.opt.smartindent = true

-- Disable line wrapping - long lines extend beyond screen width
vim.opt.wrap = false

-- Show absolute line numbers in the left gutter
vim.opt.number = true

-- Disable relative line numbers (distances from current line)
vim.opt.relativenumber = false

-- Set minimum width of line number column to 2 characters
vim.opt.numberwidth = 2

-- Open horizontal splits below the current window instead of above
vim.opt.splitbelow = true

-- Open vertical splits to the right of the current window instead of left
vim.opt.splitright = true

-- Enable 24-bit RGB color support in terminal for better colorscheme display
vim.opt.termguicolors = true

-- Show vertical line at column 100 as a visual guide for line length
vim.opt.colorcolumn = "100"

-- Always show the sign column to prevent text shifting when signs appear
vim.opt.signcolumn = "yes"

-- Highlight the current line where the cursor is located
vim.opt.cursorline = true

-- Disable audible error bells and visual flashing
vim.opt.errorbells = false

-- Disable swap file creation for better performance and fewer temp files
vim.opt.swapfile = false

-- Disable automatic backup file creation
vim.opt.backup = false

vim.opt.undofile = true

-- Enable mouse support in all modes (normal, visual, insert, command)
vim.opt.mouse:append("a")

-- Set file encoding to UTF-8 for proper unicode character support
vim.opt.encoding = "UTF-8"

-- Keep n lines visible above/below cursor when scrolling
vim.opt.scrolloff = 8

-- Keep n columns visible left/right of cursor when side scrolling
vim.opt.sidescrolloff = 8

-- Allow visual block mode to extend beyond end of lines
vim.opt.virtualedit = "block"

-- Show partial off-screen substitute results in a preview window
-- i.e. :%s/foo/bar results will show in preview window, so that
-- if substitutions are spread through the fille we can see them
-- consolidated before accepting the change.
vim.opt.inccommand = "split"

-- Use ripgrep as the default grep program if available
if vim.fn.executable("rg") == 1 then
  vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case"
end

-- Allow loading project-specific configuration files (.exrc, .nvimrc, .nvim.lua)
vim.opt.exrc = true

-- Use tree-sitter for intelligent code folding based on syntax
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

-- Start with all folds open instead of closed
vim.opt.foldenable = false

-- Set maximum fold level to 99 (essentially unlimited nesting)
vim.opt.foldlevel = 99

-- Allow backspace to delete across line breaks, indentation, and insert start point
vim.opt.backspace = {"start", "eol", "indent"}

-- Prevent automatic comment continuation when pressing Enter on comment lines
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  desc = "Disable comment continuation on newline",
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- Set command line height to 1 line for displaying messages
-- vim.opt.cmdheight = 1

-- Make @ count as a filename character, so Neovim doesn't split on it when
-- detecting or completing filenames.
vim.opt.isfname:append("@-@")

-- Set the minimum time (ms) of inactivity before CursorHold and CursorHoldI events fire
vim.opt.updatetime = 50
