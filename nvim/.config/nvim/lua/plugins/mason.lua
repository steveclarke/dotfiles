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
  local lspconfig = require("lspconfig")
  local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
  local mason = require("mason")
  local mason_lspconfig = require("mason-lspconfig")

  vim.api.nvim_create_autocmd("LspAttach", {
    desc = "Lsp Actions",
    callback = function(event)
      local opts = { buffer = event.buf }

      vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
      vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
      vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
      vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
      vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
      vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
      vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
      vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
      vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
      vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)

      vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>", opts)
      vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", opts)
      vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", opts)
    end,
  })

  -- Setup Mason
  mason.setup(mason_opts)
  mason_lspconfig.setup({ ensure_installed })

  -- [[ To automatically setup LSPs for each language, use the following ]]
  --
  -- local default_setup = function(server)
  --   lspconfig[server].setup({
  --     capabilities = lsp_capabilities,
  --   })
  -- end
  --
  -- mason_lspconfig.setup({
  --   ensure_installed = ensure_installed,
  --   handlers = {
  --     default_setup,
  --
  --     -- Lua
  --     lua_ls = function()
  --       lspconfig.lua_ls.setup({
  --         settings = {
  --           Lua = {
  --             diagnostics = {
  --               globals = { "vim" },
  --             },
  --           },
  --         },
  --       })
  --     end,
  --   },
  -- })
  -- [[ End of automatic setup ]]

  -- [[ Setup LSP ]]
  -- Ruby
  -- lspconfig.ruby_ls.setup({
  --   capabilities = lsp_capabilities,
  -- })
  lspconfig.standardrb.setup({
    capabilities = lsp_capabilities
  })
  -- Lua
  lspconfig.lua_ls.setup({
    capabilities = lsp_capabilities,
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
      },
    },
  })
  -- JSON
  lspconfig.jsonls.setup({
    capabilities = lsp_capabilities,
  })
  -- CSS
  lspconfig.cssls.setup({
    capabilities = lsp_capabilities,
  })
  -- HTML
  lspconfig.html.setup({
    capabilities = lsp_capabilities,
  })
  -- JavaScript / TypeScript
  lspconfig.tsserver.setup({
    capabilities = lsp_capabilities,
  })
  -- Emmet
  lspconfig.emmet_ls.setup({
    capabilities = lsp_capabilities,
  })

  local cmp = require("cmp")
  cmp.setup({
    sources = {
      { name = "nvim_lsp" },
    },
    mapping = cmp.mapping.preset.insert({
      -- Enter key confirms completion item
      ["<CR>"] = cmp.mapping.confirm({ select = false }),
      -- Ctrl + space triggers completion menu
      ["<C-Space>"] = cmp.mapping.complete(),
    }),
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },
  })
end

return {
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
    },
    lazy = false,
    config = config,
  },
}
