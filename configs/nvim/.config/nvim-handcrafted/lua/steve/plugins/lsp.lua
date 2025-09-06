return {
  -- LSP Config: Language Server Protocol configuration for Neovim
  -- Provides autocomplete, diagnostics, go-to-definition, and other IDE features
  -- for various programming languages. Works with Mason to manage LSP servers.
  --
  -- NOTE: This is just the base plugin - actual LSP servers are configured
  --   via mason-lspconfig.nvim and language-specific files in steve.lang/

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    }
  },
  -- mason.nvim: Package manager for LSP servers, DAP servers, linters, and formatters
  -- Provides a unified interface to install and manage development tools within neovim
  -- Simplifies setup of language servers and other tools without manual installation
  {
    "mason-org/mason.nvim",
    opts = { ui = { border = "rounded" } },
  },

  -- mason-lspconfig: Bridge between Mason and nvim-lspconfig
  -- Automatically installs LSP servers and ensures they're properly configured
  -- Handles the connection between Mason's package management and LSP setup
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = {},
      automatic_installation = true,
    }
  },

  -- mason-tool-installer: Automatically install tools managed by Mason
  -- Ensures that specified LSP servers, formatters, linters, and DAP servers are installed
  -- Extends the base ensure_installed list with tools defined in lang/* files

  {
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
  },
}

