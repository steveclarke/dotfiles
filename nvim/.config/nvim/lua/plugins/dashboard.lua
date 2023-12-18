-- https://fsymbols.com/generators/carty/

local logo = [[
░██████╗███████╗██╗░░░██╗███████╗███╗░░██╗██╗░░░██╗██╗███████╗░██╗░░░░░░░██╗
██╔════╝██╔════╝██║░░░██║██╔════╝████╗░██║██║░░░██║██║██╔════╝░██║░░██╗░░██║
╚█████╗░█████╗░░╚██╗░██╔╝█████╗░░██╔██╗██║╚██╗░██╔╝██║█████╗░░░╚██╗████╗██╔╝
░╚═══██╗██╔══╝░░░╚████╔╝░██╔══╝░░██║╚████║░╚████╔╝░██║██╔══╝░░░░████╔═████║░
██████╔╝███████╗░░╚██╔╝░░███████╗██║░╚███║░░╚██╔╝░░██║███████╗░░╚██╔╝░╚██╔╝░
╚═════╝░╚══════╝░░░╚═╝░░░╚══════╝╚═╝░░╚══╝░░░╚═╝░░░╚═╝╚══════╝░░░╚═╝░░░╚═╝░░

N e o v i m   D e v e l o p e r   S t u d i o
]]

logo = string.rep("\n", 8) .. logo .. "\n\n"

return {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  dependencies = {
    "nvim-tree/nvim-web-devicons"
  },
  config = function()
    require("dashboard").setup({
      theme = "doom",
      hide = {
        -- this is taken care of by lualine
        -- enabling this messes up the actual laststatus setting after loading a file
        statusline = false,
      },
      config = {
        header = vim.split(logo, "\n"),
        center = {
          { action = "Telescope find_files", desc = " Find file", icon = " ", key = "f" },
          { action = "ene | startinsert", desc = " New file", icon = " ", key = "n" },
          { action = "Telescope oldfiles", desc = " Recent files", icon = " ", key = "r" },
          { action = "Telescope live_grep", desc = " Find text", icon = " ", key = "g" },
          { action = 'lua require("persistence").load()', desc = " Restore Session", icon = " ", key = "s" },
          { action = "qa", desc = " Quit", icon = " ", key = "q" },
        },
        footer = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
        end,
      }
    })
  end
}
