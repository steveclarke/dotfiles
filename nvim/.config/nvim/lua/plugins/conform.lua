-- :ConformInfo to view configured and available formatters, as well as log file

local config = function()
  local conform = require("conform")

  conform.setup({
    formatters_by_ft = {
      javascript = { "prettierd" },
      typescript = { "prettierd" },
      javascriptreact = { "prettierd" },
      typescriptreact = { "prettierd" },
      json = { "prettierd" },
      vue = { "prettierd" },
      lua = { "stylua" },
      markdown = { "markdownlint" },
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
