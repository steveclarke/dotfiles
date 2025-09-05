-- Collection of mini.nvim plugins
-- mini.pairs: Automatic bracket and quote pairing
-- mini.icons: Icon provider for Neovim plugins

return {
  -- Automatic bracket and quote pairing
  -- Automatically inserts closing brackets, parentheses, quotes, etc. when typing opening ones
  -- Provides smart deletion and navigation within paired characters
  {
    "nvim-mini/mini.pairs",
    event = "VeryLazy",
    opts = {},
  },
}
