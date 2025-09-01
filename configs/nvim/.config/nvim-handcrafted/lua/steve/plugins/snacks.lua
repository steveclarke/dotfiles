return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    -- Only enable the picker for now - other features can be enabled later as needed
    -- The picker provides fast file/buffer/recent file searching with telescope-like functionality
    picker = { enabled = true },
  },

  keys = {
    -- Essential file picker keymaps with explicit follow = true
    { "<leader>ff", function() require("snacks").picker.files({ follow = true }) end, desc = "Find Files" },
    { "<leader>fg", function() require("snacks").picker.git_files() end, desc = "Find Git Files" },
    { "<leader>fr", function() require("snacks").picker.recent() end, desc = "Recent Files" },
    { "<leader>fb", function() require("snacks").picker.buffers() end, desc = "Find Buffers" },
    
    -- Grep/search functionality
    { "<leader>/", function() require("snacks").picker.grep({ follow = true }) end, desc = "Live Grep (Root Dir)" },
    { "<leader>sg", function() require("snacks").picker.grep({ follow = true }) end, desc = "Live Grep (Root Dir)" },
    { "<leader>sG", function() require("snacks").picker.grep({ follow = true, root = false }) end, desc = "Live Grep (cwd)" },
    { "<leader>sw", function() require("snacks").picker.grep_word({ follow = true }) end, desc = "Visual selection or word", mode = { "n", "x" } },
    { "<leader>sB", function() require("snacks").picker.grep_buffers() end, desc = "Grep Open Buffers" },
    { "<leader>sb", function() require("snacks").picker.lines() end, desc = "Buffer Lines" },
    
    -- UI/Utility
    { "<leader>uC", function() require("snacks").picker.colorschemes() end, desc = "Colorschemes" },
  },
}
