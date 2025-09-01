-- BufferLine: A snazzy buffer line for Neovim
-- Provides a tabline showing open buffers with file icons, LSP diagnostics,
-- and advanced buffer management features like pinning and directional closing.
-- Integrates with file explorers and other sidebar plugins.
--
-- NOTE: Only non-default options are configured. Bufferline defaults:
--   close_command = "bdelete! %d", right_mouse_command = "bdelete! %d",
--   diagnostics = false, always_show_bufferline = true

return {
  "akinsho/bufferline.nvim",
  
  -- Plugin Configuration
  version = "*",
  dependencies = "nvim-tree/nvim-web-devicons",
  event = "VeryLazy",
  -- Keybindings (LazyVim compatible)
  keys = {
    -- Buffer navigation (quick switching between buffers)
    { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },      -- Shift+h
    { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },      -- Shift+l  
    { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },         -- Bracket style
    { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },         -- Bracket style
    { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },     -- Move buffer position left
    { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },     -- Move buffer position right
    
    -- Core buffer management (works with/without bufferline)
    { "<leader>bb", "<cmd>e #<cr>", desc = "Switch to Other Buffer" },      -- Jump to last buffer
    { "<leader>bd", "<cmd>bdelete<cr>", desc = "Delete Buffer" },           -- Close current buffer
    { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete Other Buffers" }, -- Close all except current
    { "<leader>bD", "<cmd>bdelete|quit<cr>", desc = "Delete Buffer and Window" },      -- Close buffer + window
    
    -- BufferLine specific features (requires bufferline plugin)
    { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },             -- Pin/unpin buffer
    { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" }, -- Keep only pinned
    { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },        -- Close right side
    { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },          -- Close left side
  },
  opts = {
    options = {
      diagnostics = "nvim_lsp",           -- Enable LSP diagnostics (default: false)
      always_show_bufferline = false,     -- Show only with multiple buffers (default: true)
      
      -- Reserve space for sidebar plugins (no default)
      offsets = {
        {
          filetype = "neo-tree",
          text = "Neo-tree", 
          highlight = "Directory",
          text_align = "left",
        },
      },
      
      -- TODO: Add when icon system is ready
      -- diagnostics_indicator = function(count, level, diagnostics_dict, context) ... end,
      -- get_element_icon = function(element) ... end,
    },
  },
}
