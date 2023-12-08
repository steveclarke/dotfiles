require("core.globals")
require("core.options")
require("core.keymaps")
require("core.autocmds")

-- [[ Lazy plugin manager ]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local opts = {
  defaults = {
    -- lazy = true,
  },
  install = {
    colorscheme = { "nightfly" },
  },
  rtp = {
    disabled_plugins = {
      -- "gzip",
      -- "matchit",
      -- "matchparen",
      "netrwPlugin",
      -- "tarPlugin",
      -- "tohtml",
      -- "tutor",
      -- "zipPlugin",
    },
  },
  change_detection = {
    notify = false,
  },
}

require("lazy").setup("plugins", opts)
