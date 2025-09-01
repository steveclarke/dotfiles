-- catppuccin.nvim: Soothing pastel color scheme for Neovim
-- Provides a highly customizable and visually appealing colorscheme
-- with support for multiple "flavors" (mocha, latte, etc.), dimming of inactive windows,
-- and integrations with popular plugins. Designed for a modern, cohesive look.

return { 
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  lazy = false,
  config = function()
    require("catppuccin").setup({
      flavor = "mocha",
      dim_inactive = {
        enabled = true,
        shade = "latte",
        percentage = 0.35,
      },
      integrations = {}
    })
    vim.cmd.colorscheme("catppuccin")
  end,
}
