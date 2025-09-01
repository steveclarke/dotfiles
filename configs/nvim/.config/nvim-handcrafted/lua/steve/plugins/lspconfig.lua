-- LSP Config: Language Server Protocol configuration for Neovim
-- Provides autocomplete, diagnostics, go-to-definition, and other IDE features
-- for various programming languages. Works with Mason to manage LSP servers.
--
-- NOTE: This is just the base plugin - actual LSP servers are configured
--   via mason-lspconfig.nvim and language-specific files in steve.lang/

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "mason-org/mason.nvim",
    "mason-org/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  }
}
