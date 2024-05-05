return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("oil").setup()
    vim.keymap.set("n", "\\\\", "<cmd>Oil<cr>", { noremap = true, silent = true })
  end,
}
