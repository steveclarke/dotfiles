-- :ConformInfo to view configured and available formatters, as well as log file
local config = function()
  local conform = require("conform")

  conform.setup({
    formatters_by_ft = {
      javascript = { "prettierd", "eslint_d" },
      typescript = { "prettierd", "eslint_d" },
      javascriptreact = { "prettierd" },
      typescriptreact = { "prettierd" },
      json = { "prettierd" },
      vue = { "prettierd", "eslint_d" },
      lua = { "stylua" },
      markdown = { "markdownlint" },
      fish = { "fish_indent" },
      sh = { "shfmt" },
      yaml = { "yamlfmt" },
      -- ruby = { "standardrb" }, --currently broken, see autocmds.lua for workaround
    },

    format_on_save = {
      lsp_fallback = true,
      async = false,
      timeout_ms = 500,
    },
  })
end

return {
  "stevearc/conform.nvim",
  enabled = true,
  event = { "BufWritePre" },
  config = config,
  cmd = { "ConformInfo" },
}
