local keymap = vim.keymap

local config = function()
  local telescope = require("telescope")
  local actions = require("telescope.actions")

  telescope.setup({
    defaults = {
      mappings = {
        i = {
          ["<C-j>"] = "move_selection_next",
          ["<C-k>"] = "move_selection_previous",
          ["<esc>"] = actions.close,
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
  })
end

return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.5",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  lazy = false,
  config = config,
  keys = {
    keymap.set("n", "<C-p>", ":Telescope git_files<CR>", { desc = "Find files (Git-aware)" }),
    keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Find files" }),
    keymap.set("n", "<leader>fb", ":Telescope buffers<CR>", { desc = "Find buffers" }),
    keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>", { desc = "Find in files (grep)" }),
    keymap.set("n", "<leader>fk", ":Telescope keymaps<CR>", { desc = "Find keymaps" }),
    keymap.set("n", "<leader>fh", ":Telescope help_tags<CR>", { desc = "Find help tags" }),
    keymap.set("n", "<leader>fa", ":Telescope <CR>", { desc = "Find all" }),
  },
}
