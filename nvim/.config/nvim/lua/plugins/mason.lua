local mason_opts = {
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
}

local lsp_config_opts = {
  ensure_installed = {
    "cssls",
    "docker_compose_language_service",
    "dockerls",
    "emmet_ls",
    "html",
    "lua_ls",
    "standardrb",
    "tailwindcss",
    "tsserver",
  },
}

return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
  },
  lazy = false,
  config = function()
    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")
    mason.setup(mason_opts)
    mason_lspconfig.setup(lsp_config_opts)
  end,
}
