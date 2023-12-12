return {
  "stevearc/conform.nvim",
  enabled = true,
  event = { "BufRead", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        javascript = { "prettier" },
        json = { "prettier" },
        -- ruby = { "standardrb" }, --currently broken, see autocmds.lua for workaround
        vue = { "prettier" },
        lua = { "stylua" },
      },

      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 500,
      },
    })

    -- FIXME: This doesn't work properly in visual mode
    -- vim.keymap.set({ "n", "v" }, "<leader>mp", function()
    --   conform.format({
    --     lsp_fallback = true,
    --     async = false,
    --     timeout_ms = 500,
    --   })
    -- end, { desc = "Format file or range" })
  end,
}
