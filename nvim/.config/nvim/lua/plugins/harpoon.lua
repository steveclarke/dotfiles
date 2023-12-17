local options = require("utils.core").keymap_options

return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  lazy = false,
  opts = {},
  config = function()
    local harpoon = require("harpoon")

    harpoon.setup({})

    vim.keymap.set("n", "<A-o>", function()
      harpoon.ui:toggle_quick_menu((harpoon:list()))
    end, options({ desc = "Toggle Harpoon Menu" }))

    vim.keymap.set("n", "<A-p>", function()
      harpoon:list():append()
    end, options({ desc = "Add Current File to Harpoon" }))

    vim.keymap.set("n", "<A-u>", function()
      harpoon:list():prev()
    end, options({ desc = "Navigate to Previous Harpoon Item" }))

    vim.keymap.set("n", "<A-i>", function()
      harpoon:list():next()
    end, options({ desc = "Navigate to Next Harpoon Item" }))

    vim.keymap.set("n", "<leader>1", function()
      harpoon:list():select(1)
    end, options({ desc = "Select Harpoon Item 1" }))

    vim.keymap.set("n", "<leader>2", function()
      harpoon:list():select(2)
    end, options({ desc = "Select Harpoon Item 2" }))

    vim.keymap.set("n", "<leader>3", function()
      harpoon:list():select(3)
    end, options({ desc = "Select Harpoon Item 3" }))

    vim.keymap.set("n", "<leader>4", function()
      harpoon:list():select(4)
    end, options({ desc = "Select Harpoon Item 4" }))
  end,
}
