return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  cmd = "Neotree",
  lazy = false, -- load so it takes over netrw when `nvim .` is invoked
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
    -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  opts = {
    filesystem = {
      hijack_netrw_behavior = "open_current",
      follow_current_file = { enabled = true },
      window = {
        -- mappings = {
        --   ["O"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
        --   ["Oc"] = { "order_by_created", nowait = false },
        --   ["Od"] = { "order_by_diagnostics", nowait = false },
        --   ["Og"] = { "order_by_git_status", nowait = false },
        --   ["Om"] = { "order_by_modified", nowait = false },
        --   ["On"] = { "order_by_name", nowait = false },
        --   ["Os"] = { "order_by_size", nowait = false },
        --   ["Ot"] = { "order_by_type", nowait = false },
        --   ["o"] = { "open", nowait = true },
        -- },
        fuzzy_finder_mappings = {
          ["<down>"] = "move_cursor_down",
          ["<C-j>"] = "move_cursor_down",
          ["<up>"] = "move_cursor_up",
          ["<C-k>"] = "move_cursor_up",
        },
      },
    },
  },
}
