-- Treesitter provides better syntax highlighting, code understanding, and text objects
-- by building abstract syntax trees for different programming languages

return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  -- Automatically update all installed language parsers when plugin updates
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      -- Automatically install missing parsers when entering buffer
      auto_install = true,

      -- Enable improved syntax highlighting based on treesitter
      highlight = { enable = true, },

      indent = { enable = true, },

      ensure_installed = {
        "bash",
        "c",
        "diff",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "printf",
        "python",
        "query",
        "regex",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
      },

      
      -- Incremental Selection: Expand/shrink selection by syntax node
      --   <C-space>: Start selection and expand to next node
      --   <bs>: Shrink selection to previous node
      --   scope_incremental: Disabled (set to false)
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",      -- Start selection
          node_incremental = "<C-space>",   -- Expand to next node
          scope_incremental = false,        -- Disable scope-based expansion
          node_decremental = "<bs>",        -- Shrink to previous node
        },
      },
    })
  end,
}
