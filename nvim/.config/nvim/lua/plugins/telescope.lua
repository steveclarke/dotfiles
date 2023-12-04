local keymap = vim.keymap

local config = {
  defaults = {
    mappings = {
      i = {
        ["<C-j>"] = "move_selection_next",
        ["<C-k>"] = "move_selection_previous",
      },
    },
  },
  pickers = {
    find_files = {
      theme = "dropdown",
      previewer = true,
    },
    buffers = {
      theme = "dropdown",
      previewer = true,
    },
    live_grep = {
      theme = "dropdown",
      previewer = true,
    },
    keymaps = {
      theme = "dropdown",
      previewer = true,
    },
    help_tags = {
      theme = "dropdown",
      previewer = true,
    },
  },
}

return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.5",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  lazy = false,
  config = config,
  keys = {
    keymap.set("n", "<leader>ff", ":Telescope find_files<CR>"),
    keymap.set("n", "<leader>fb", ":Telescope buffers<CR>"),
    keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>"),
    keymap.set("n", "<leader>fk", ":Telescope keymaps<CR>"),
    keymap.set("n", "<leader>fh", ":Telescope help_tags<CR>"),
    keymap.set("n", "<leader>fa", ":Telescope <CR>"),
  },
}

