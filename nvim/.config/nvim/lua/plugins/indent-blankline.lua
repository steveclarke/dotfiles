-- This plugin adds indentation guides to Neovim. It uses Neovim's virtual text
-- feature and no conceal

return {
  "lukas-reineke/indent-blankline.nvim",
  enabled = true,
  main = "ibl",
  opts = {
    indent = {
      char = "│",
      tab_char = "│",
    },
    scope = { enabled = false },
    exclude = {
      filetypes = {
        "help",
        "alpha",
        "dashboard",
        "neo-tree",
        "Trouble",
        "trouble",
        "lazy",
        "mason",
        "notify",
        "toggleterm",
        "lazyterm",
      },
    },
  },
  lazy = false,
}
