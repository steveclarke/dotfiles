return {
  "folke/which-key.nvim",
  lazy = false,
  config = {},
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
}