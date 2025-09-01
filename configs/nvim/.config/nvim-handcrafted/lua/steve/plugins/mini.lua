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

  -- Icon provider - required for full which-key icon support
  -- Provides icons for various file types, git status, and more
  {
    "nvim-mini/mini.icons",
    lazy = true,
    opts = {},
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
}
