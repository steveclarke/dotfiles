return {
  "kylechui/nvim-surround",
  event = "VeryLazy",
  version = "*",
  config = function()
    local surround = require("nvim-surround")
    surround.setup({})
  end,
}
