-- neo-tree.nvim: Modern file explorer for Neovim
-- Provides a highly configurable sidebar tree for navigating and managing files,
-- buffers, and git status. Replaces netrw and offers features like fuzzy finding,
-- file operations, and integration with devicons for a rich UI experience.

return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  lazy = false, -- load immediately to replace netrw when opening directories
  config = function()
    require("neo-tree").setup({
      filesystem = {
        -- hijack_netrw_behavior options:
        -- "open_default" - netrw disabled, opening a directory opens neo-tree
        --                  in whatever position is specified in window.position
        -- "open_current" - netrw disabled, opening a directory opens within the
        --                  window like netrw would, regardless of window.position
        -- "disabled"     - netrw left alone, neo-tree does not handle opening dirs
        hijack_netrw_behavior = "open_default",
        -- follow_current_file: automatically highlight and reveal the currently open file
        -- in the neo-tree when switching between buffers (disabled for manual control)
        follow_current_file = { enabled = false },
        window = {
          -- fuzzy_finder_mappings: custom key mappings for neo-tree's fuzzy finder
          -- when searching for files within the tree (triggered by "/" key)
          fuzzy_finder_mappings = {
            ["<down>"] = "move_cursor_down",  -- arrow key navigation
            ["<C-j>"] = "move_cursor_down",   -- vim-style down movement
            ["<up>"] = "move_cursor_up",      -- arrow key navigation  
            ["<C-k>"] = "move_cursor_up",     -- vim-style up movement
          },
        },
      },
    })

    -- File explorer keymaps following <leader>e* pattern
    vim.keymap.set("n", "<leader>ee", "<cmd>Neotree filesystem toggle left<cr>", { desc = "Toggle file explorer" })
    vim.keymap.set("n", "<leader>ef", "<cmd>Neotree filesystem focus left<cr>", { desc = "Focus file explorer" })
    vim.keymap.set("n", "<leader>er", "<cmd>Neotree filesystem reveal left<cr>", { desc = "Reveal current file in explorer" })
    vim.keymap.set("n", "<leader>eg", "<cmd>Neotree git_status toggle float<cr>", { desc = "Toggle git explorer" })
    vim.keymap.set("n", "<leader>eb", "<cmd>Neotree buffers toggle float<cr>", { desc = "Toggle buffer explorer" })
  end,
}
