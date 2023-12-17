return {
  "folke/which-key.nvim",
  lazy = false,
  config = function()
    local which_key = require("which-key")

    which_key.register({ ["<leader>f"] = { name = "finder/file commands" } })
    which_key.register({ ["<leader>r"] = { name = "reformat commands" } })
    which_key.register({ ["<leader>s"] = { name = "split commands" } })
    which_key.register({ ["<leader>y"] = { name = "yank commands" } })
    which_key.register({ ["<leader>q"] = { name = "quit commands" } })
    which_key.register({ ["<leader>b"] = { name = "buffer commands" } })
    which_key.register({ [",t"] = { name = "tab commands" } })
    which_key.register({ ["-s"] = { name = "split commands" } })
    which_key.register({ ["-t"] = { name = "tab commands" } })
    which_key.register({ ["-v"] = { name = "vertical commands" } })
    which_key.setup({})
  end,
}
