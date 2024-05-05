return {
  "catppuccin/nvim",
  enable = not vscode,
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({ })
    vim.cmd.colorscheme("catppuccin")
  end
}
