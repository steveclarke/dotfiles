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
    event = {
      "BufReadPre",
      "BufNewFile",
    },
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
    incremental_selection = {
      enable = true,
      -- keymaps = {
      --   init_selection = "<C-space>",
      --   node_incremental = "<C-space>",
      --   scope_incremental = false,
      --   node_decremental = "<bs>",
      -- },
    },
  })
end

return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  event = { "BufReadPre", "BufNewFile" },
  config = config,
}
