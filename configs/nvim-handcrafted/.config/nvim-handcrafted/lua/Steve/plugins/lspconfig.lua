return {
  { "neovim/nvim-lspconfig" },

  {
    "mason-org/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },

  {
    "mason-org/mason-lspconfig.nvim" ,
    config = function()
      require("mason-lspconfig").setup()
    end
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason.nvim", "mason-lspconfig.nvim" },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          "lua_ls",
          "stylua",
          "ruby_lsp",
          "pyright"
        },
        run_on_start = true,
        start_delay = 3000
      })
    end
  }
}

