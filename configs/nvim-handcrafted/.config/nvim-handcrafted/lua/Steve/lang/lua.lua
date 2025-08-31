return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "lua_ls",  -- lspconfig server name (mapped to lua-language-server in Mason)
        "stylua",  -- Mason package name (no lspconfig server equivalent)
      },
    },
  },
}
