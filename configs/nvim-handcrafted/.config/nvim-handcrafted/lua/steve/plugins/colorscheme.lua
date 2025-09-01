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
