local opts = {
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
}

return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
  },
  lazy = false,
  opts = opts,
  -- FIXME: ensure_installed complains about naming the ensure_installed correctly
  -- config = function()
  --   local mason = require("mason")
  --   local mason_lspconfig = require("mason-lspconfig")
  --
  --   mason_lspconfig.setup({
  --     ensure_installed = {
  --       "standardrb"
  --     }
  --   })
  -- end,
}
