local keymap = vim.keymap
local keymap_options = require("utils.core").keymap_options

local opts = {
  options = {
    always_show_bufferline = false,
    offsets = {
      {
        filetype = "neo-tree",
        text = "Neo-tree",
        highlight = "Directory",
        text_align = "left",
      },
    },
  },
}

return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    -- Note: I'm using a function with manual keymaps because when I use the "keys" lazy plugin
    -- option, the bufferlines don't show when I restore sessions using the Persistence plugin.
    -- I notice that in:
    --   https://github.com/LazyVim/LazyVim/blob/879e29504d43e9f178d967ecc34d482f902e5a91/lua/lazyvim/plugins/ui.lua
    -- Folke has a workaround for this but it doesn't work for me.
    local bufferline = require("bufferline")

    bufferline.setup(opts)

    keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", keymap_options({ desc = "Prev buffer" }))
    keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", keymap_options({ desc = "Next buffer" }))
    keymap.set("n", "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", keymap_options({ desc = "Toggle buffer pin" }))
    keymap.set(
      "n",
      "<leader>bP",
      "<Cmd>BufferLineGroupClose ungrouped<CR>",
      keymap_options({ desc = "Delete non-pinned buffers" })
    )
    keymap.set("n", "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", keymap_options({ desc = "Delete other buffers" }))
    keymap.set(
      "n",
      "<leader>br",
      "<Cmd>BufferLineCloseRight<CR>",
      keymap_options({ desc = "Delete buffers to the right" })
    )
    keymap.set(
      "n",
      "<leader>bl",
      "<Cmd>BufferLineCloseLeft<CR>",
      keymap_options({ desc = "Delete buffers to the left" })
    )
    keymap.set("n", "[b", "<cmd>BufferLineCyclePrev<cr>", keymap_options({ desc = "Prev buffer" }))
    keymap.set("n", "]b", "<cmd>BufferLineCycleNext<cr>", keymap_options({ desc = "Next buffer" }))
  end,
}
