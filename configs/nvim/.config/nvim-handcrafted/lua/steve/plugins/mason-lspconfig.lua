-- mason-lspconfig: Bridge between Mason and nvim-lspconfig
-- Automatically installs LSP servers and ensures they're properly configured
-- Handles the connection between Mason's package management and LSP setup

return {
  "mason-org/mason-lspconfig.nvim",
  dependencies = { "mason-org/mason.nvim" },
  opts = {
    ensure_installed = {},
    automatic_installation = true,
  }
}
