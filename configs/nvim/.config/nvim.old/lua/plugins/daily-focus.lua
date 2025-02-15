return {
  "steveclarke/daily-focus.nvim",
  -- dir = "/home/steve/src/daily-focus.nvim",
  enabled = true,
  -- dev = true,
  -- lazy = false
  opts = {},
  config = function()
    local daily_focus = require("daily-focus")
    daily_focus.setup()
    vim.print(daily_focus.current_tip())
  end,
}
