local mason_opts = {
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
    border = "rounded",
  },
}

local ensure_installed = {
  "cssls",
  "docker_compose_language_service",
  "dockerls",
  "emmet_ls",
  "html",
  "jsonls",
  "lua_ls",
  "standardrb",
  "tailwindcss",
  "tsserver",
  "volar",
}

local config = function()
  local mason = require("mason")
  local mason_lspconfig = require("mason-lspconfig")
  local lspconfig = require("lspconfig")

  local default_setup = function(server)
    lspconfig[server].setup({})
  end

  -- Setup Mason
  mason.setup(mason_opts)
  mason_lspconfig.setup({
    ensure_installed = ensure_installed,
    handlers = {
      default_setup,

      -- Lua
      lua_ls = function()
        lspconfig.lua_ls.setup({
          Lua = {
            runtime = {
              version = "LuaJIT",
            },
          },
        })
      end,
    },
  })

  -- Setup LSP
  -- lspconfig.lua_ls.setup({})
  -- lspconfig.jsonls.setup({})
  -- lspconfig.cssls.setup({})
  -- lspconfig.ruby_ls.setup({})
  -- lspconfig.html.setup({})
  -- lspconfig.tsserver.setup({})
  -- lspconfig.emmet_ls.setup({})
end

return {
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
    },
    lazy = false,
    config = config,
  },
}
