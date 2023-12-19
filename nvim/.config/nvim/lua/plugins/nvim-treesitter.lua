local config = function()
  local treesitter = require("nvim-treesitter.configs")

  treesitter.setup({
    indent = {
      enable = true,
    },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    autotag = {
      enable = true,
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["af"] = { query = "@function.outer", desc = "outer function" },
          ["if"] = { query = "@function.inner", desc = "inner function" },
          ["aa"] = { query = "@parameter.outer", desc = "outer argument/parameter" },
          ["ia"] = { query = "@parameter.inner", desc = "inner argument/parameter" },
          ["ac"] = { query = "@class.outer", desc = "outer class" },
          ["ic"] = { query = "@class.inner", desc = "inner class" },
        },
      },
    },
    -- incremental_selection = {
    --   enable = true,
    --   keymaps = {
    --     init_selection = "<leader>ss",
    --     node_incremental = "<leader>si",
    --     scope_incremental = "<leader>sc",
    --     node_decremental = "<leader>sd",
    --   },
    -- },
    ensure_installed = {
      "bash",
      "css",
      "dockerfile",
      "gitignore",
      "html",
      "javascript",
      "json",
      "lua",
      "markdown",
      "python",
      "ruby",
      "typescript",
      "vue",
      "yaml",
    },
    auto_install = true,
  })
end

return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects"
  },
  lazy = false,
  build = ":TSUpdate",
  event = { "BufReadPre", "BufNewFile" },
  config = config,
}
