return {
  dir = "/home/steve/src/daily-focus.nvim",
  enabled = false,
  -- dev = true,
  -- lazy = false
  opts = {},
  config = function()
    local daily_focus = require("daily-focus")
    daily_focus.setup({ data_path = "/foo/bar" })
    vim.print(daily_focus.tip())
  end
}
