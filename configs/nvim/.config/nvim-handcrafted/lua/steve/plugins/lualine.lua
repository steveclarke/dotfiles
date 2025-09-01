return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("lualine").setup({
      sections = {
        lualine_x = {
          {
            function()
              local lazy = require("lazy.status")
              return lazy.updates()
            end,
            cond = function()
              local lazy = require("lazy.status")
              return lazy.has_updates()
            end,
          },
          "encoding",
          "fileformat", 
          "filetype"
        },
      },
    })
  end,
}
