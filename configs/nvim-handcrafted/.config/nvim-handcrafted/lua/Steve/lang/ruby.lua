return {
  -- Extend mason-tool-installer with Ruby tools
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "ruby_lsp",
        "standardrb", 
        "solargraph",
      },
    },
  },
}
