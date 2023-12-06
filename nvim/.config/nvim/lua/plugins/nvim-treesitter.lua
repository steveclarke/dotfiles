local opts = {
  build = ":TSUpdate",
  indent = {
    enable = true,
  },
  autotag = {
    enable = true,
  },
  event = {
    "BufReadPre",
    "BufNewFile",
  },
  ensure_installed = {
    "markdown",
    "json",
    "javascript",
    "typescript",
    "yaml",
    "html",
    "css",
    "bash",
    "lua",
    "dockerfile",
    "gitignore",
    "python",
    "vue",
    "ruby"
  },
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}

return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  opts = opts,
}
