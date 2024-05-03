local lazypath = vim.fn.stdpath("data") .. "/lazy-vscode/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local lazy_opts = {
  lockfile = vim.fn.stdpath("config") .. "/lazy-vscode.lock",
}
require("lazy").setup({
  {
    "kylechui/nvim-surround",
    version = "*",
    -- event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end,
  },
}, lazy_opts)
