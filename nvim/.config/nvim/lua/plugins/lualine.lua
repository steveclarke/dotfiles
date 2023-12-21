local config = function()
  -- local daily_focus = require("daily-focus")

  require("lualine").setup({
    options = {
      theme = "catppuccin",
      globalstatus = true,
      -- section_separators = { left = "", right = "" },
      -- component_separators = { left = "", right = "" },
    },
    sections = {
      -- lualine_c = { daily_focus.tip },
      -- Show @recording messages here because Noice supresses it
      lualine_x = {
        {
          require("noice").api.statusline.mode.get,
          cond = require("noice").api.statusline.mode.has,
          color = { fg = "#ff9e64" },
        },
        "hostname",
        "encoding",
        "fileformat",
        "filetype",
      },
    },
  })
end

return {
  "nvim-lualine/lualine.nvim",
  lazy = false,
  config = config,
}
