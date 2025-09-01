-- Lualine: A blazing fast and easy to configure statusline for Neovim
-- Displays file information, git status, LSP diagnostics, and other useful info
-- in the bottom status bar. Configured to show pending lazy.nvim plugin updates.
--
-- NOTE: Only non-default sections are configured. Lualine defaults include:
--   file name, git branch, file type, cursor position, and more

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
