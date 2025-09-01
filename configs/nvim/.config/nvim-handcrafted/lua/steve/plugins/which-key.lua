return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
  config = function()
    local which_key = require("which-key")

    -- Register key group descriptions 
    which_key.add({
      { "<leader>", group = "Leader Key (Space)"},
      { "<leader>e", group = "File Explorer", icon = "󰉋" },
      { "<leader>f", group = "File Picker", icon = "󰈞" },
      { "<leader>s", group = "Search & Grep", icon = "󰍉" },
      { "<leader>u", group = "UI/Utility", icon = "󰙵" },
      { "<leader>w", group = "Window Management", icon = "󰕮" },
      { "<leader>q", group = "Quit", icon = "󰗼" },
      { "\\", group = "System Operations"},
    })

    which_key.setup({
      preset = "helix",  -- LazyVim's vertical layout style
    })
  end,
}
