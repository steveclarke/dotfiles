return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    -- Only enable the picker for now - other features can be enabled later as needed
    -- The picker provides fast file/buffer/recent file searching with telescope-like functionality
    picker = { enabled = true },
    -- Enable zen functionality which includes zoom (window maximize)
    zen = { enabled = true },
    -- Enable toggle functionality for window maximize/zoom
    toggle = { enabled = true },
  },

  keys = {
    -- Smart picker (LazyVim style)
    { "<leader><space>", function() require("snacks").picker.smart({ follow = true }) end, desc = "Smart Find Files" },
    
    -- Essential file picker keymaps with explicit follow = true
    { "<leader>ff", function() require("snacks").picker.files({ follow = true }) end, desc = "Find Files" },
    { "<leader>fg", function() require("snacks").picker.git_files() end, desc = "Find Git Files" },
    { "<leader>fr", function() require("snacks").picker.recent() end, desc = "Recent Files" },
    { "<leader>fb", function() require("snacks").picker.buffers() end, desc = "Find Buffers" },
    
    -- Grep/search functionality
    { "<leader>/", function() require("snacks").picker.grep({ follow = true }) end, desc = "Grep (Root Dir)" },
    { "<leader>sg", function() require("snacks").picker.grep({ follow = true }) end, desc = "Grep (Root Dir)" },
    { "<leader>sG", function() require("snacks").picker.grep({ follow = true, root = false }) end, desc = "Grep (cwd)" },
    { "<leader>sw", function() require("snacks").picker.grep_word({ follow = true }) end, desc = "Visual selection or word (Root Dir)", mode = { "n", "x" } },
    { "<leader>sW", function() require("snacks").picker.grep_word({ follow = true, root = false }) end, desc = "Visual selection or word (cwd)", mode = { "n", "x" } },
    { '<leader>s"', function() require("snacks").picker.registers() end, desc = "Registers" },
    { "<leader>sB", function() require("snacks").picker.grep_buffers() end, desc = "Grep Open Buffers" },
    { "<leader>sb", function() require("snacks").picker.lines() end, desc = "Buffer Lines" },
    
    -- UI/Utility
    { "<leader>uC", function() require("snacks").picker.colorschemes() end, desc = "Colorschemes" },
    
    -- Window management
    { "<leader>wm", function() require("snacks").zen.zoom() end, desc = "Toggle Window Maximize" },
  },
}
