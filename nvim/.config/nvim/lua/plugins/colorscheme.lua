return {
  {
    "bluz71/vim-nightfly-guicolors",
    priority = 999,
    lazy = false,
    config = function()
      vim.cmd.colorscheme("nightfly")
    end,
  },
  {
    "folke/tokyonight.nvim",
    priority = 999,
    lazy = false,
    config = function()
      local tokyonight = require("tokyonight")

      tokyonight.setup({
        style = "night",
        terminal_colors = true,
        dim_inactive = true,
      })

      -- vim.cmd.colorscheme("tokyonight")
    end,
  },
  {
    "loctvl842/monokai-pro.nvim",
    priority = 999,
    lazy = false,
    config = function()
      local mp = require("monokai-pro")

      mp.setup({
        devicions = true,
        -- filter = "octagon",
        filter = "pro",
      })

      -- vim.cmd.colorscheme("monokai-pro")
    end,
  },
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 999,
    config = function()
      -- vim.cmd.colorscheme("nightfox")
    end,
  },
}
