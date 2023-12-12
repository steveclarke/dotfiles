return {
  "mfussenegger/nvim-lint",
  event = {
    "BufReadPre",
    "BufNewFile",
  },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      css = { "stylelint" },
      javascript = { "eslint_d" },
      json = { "jsonlint" },
      less = { "stylelint" },
      lua = { "luacheck" },
      markdown = { "markdownlint" },
      -- ruby = { "standardrb" },
      sass = { "stylelint" },
      scss = { "stylelint" },
      typescript = { "eslint_d" },
      vue = { "eslint_d" },
      yaml = { "yamllint" },
    }

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
    -- local events = { "BufEnter", "BufWritePost", "InsertLeave", "TextChanged" }
    local events = { "BufEnter", "BufWritePost", "InsertLeave" }
    vim.api.nvim_create_autocmd(events, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })

    vim.keymap.set("n", "<leader>l", function()
      lint.try_lint()
    end, { desc = "Trigger linting for current buffer" })
  end,
}
