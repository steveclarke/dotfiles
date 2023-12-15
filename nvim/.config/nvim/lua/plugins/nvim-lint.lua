local keymap_options = require("utils.core").keymap_options

return {
  "mfussenegger/nvim-lint",
  enabled = true,
  event = {
    "BufReadPre",
    "BufNewFile",
  },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      markdown = { "markdownlint" },
      fish = { "fish" },
      -- css = { "stylelint" },
      -- javascript = { "eslint_d" },
      -- json = { "jsonlint" },
      -- less = { "stylelint" },
      -- lua = { "luacheck" },
      -- ruby = { "standardrb" },
      -- sass = { "stylelint" },
      -- scss = { "stylelint" },
      -- typescript = { "eslint_d" },
      -- vue = { "eslint_d" },
      -- yaml = { "yamllint" },
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
    end, keymap_options({ desc = "Trigger linting for current buffer" }))
  end,
}
