-- :ConformInfo to view configured and available formatters, as well as log file

local config = function()
  local conform = require("conform")

  conform.setup({
    formatters_by_ft = {
      javascript = { "prettier" },
      json = { "prettier" },
      -- ruby = { "standardrb" }, --currently broken, see autocmds.lua for workaround
      vue = { "prettier" },
      lua = { "stylua" },
      markdown = { "markdownlint" },
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
