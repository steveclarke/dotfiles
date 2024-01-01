return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    config = function()
      require("catppuccin").setup({
        dim_inactive = {
          enabled = true,
          shade = "latte",
          percentage = 0.35,
        },
        integrations = {
          -- cmp = true,
          -- gitsigns = true,
          nvimtree = true,
          treesitter = true,
        },
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  {
    "maxmx03/dracula.nvim",
    priority = 1000,
    lazy = false,
    config = function()
      -- local dracula = require("dracula")
      -- dracula.setup()
      -- vim.cmd.colorscheme("dracula")
    end,
  },
  {
    "miikanissi/modus-themes.nvim",
    priority = 1000,
  },
  {
    "bluz71/vim-nightfly-guicolors",
    priority = 1000,
    lazy = false,
    config = function()
      -- vim.cmd.colorscheme("nightfly")
    end,
  },
  {
    "folke/tokyonight.nvim",
    priority = 1000,
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
    priority = 1000,
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
    priority = 1000,
    config = function()
      -- vim.cmd.colorscheme("nightfox")
    end,
  },
}
