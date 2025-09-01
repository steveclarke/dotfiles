-- mason-tool-installer: Automatically install tools managed by Mason
-- Ensures that specified LSP servers, formatters, linters, and DAP servers are installed
-- Extends the base ensure_installed list with tools defined in lang/* files

return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  dependencies = { "mason-org/mason.nvim" },
  -- opts_extend: Lazy.nvim feature added in v10.23.0 (June 2024)
  -- Allows specified keys to be EXTENDED (concatenated) instead of MERGED (replaced)
  -- This enables lang/* files to add tools to ensure_installed without complex functions
  -- Usage in lang files: just use opts = { ensure_installed = { "tool1", "tool2" } }
  -- Underdocumented but used extensively in LazyVim - see CHANGELOG.md
  opts_extend = { "ensure_installed" },
  opts = {
    -- configs in lang/* extends this table
    ensure_installed = {
      "lua_ls",
      "stylua",
    },
    auto_update = true,
    run_on_start = true,
  }
}
