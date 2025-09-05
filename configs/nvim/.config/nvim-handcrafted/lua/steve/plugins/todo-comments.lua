return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local todo = require("todo-comments")
    todo.setup()

    vim.keymap.set("n", "]t", function()
      todo.jump_next()
    end, { desc = "Jump to next todo comment" })
    vim.keymap.set("n", "[t", function()
      todo.jump_prev()
    end, { desc = "Jump to previous todo comment" })
  end
}
