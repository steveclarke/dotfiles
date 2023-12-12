return {
  "stevearc/conform.nvim",
  enabled = true,
  event = { "BufRead", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        css = { "prettierd" },
        javascript = { "prettierd" },
        json = { "prettierd" },
        -- ruby = { "standardrb" }, -- see autocmds.lua
        vue = { "prettierd" },
        lua = { "stylua" },
      },

      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 500,
      },
    })

    -- FIXME: This doesn't work properly in visual mode
    vim.keymap.set({ "n", "v" }, "<leader>mp", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 500,
      })
    end, { desc = "Format file or range" })
  end,
}
