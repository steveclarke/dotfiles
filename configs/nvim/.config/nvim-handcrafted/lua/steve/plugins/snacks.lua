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
  },
}
