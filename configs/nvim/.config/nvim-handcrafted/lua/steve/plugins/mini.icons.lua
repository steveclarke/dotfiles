
-- Icon provider - required for full which-key icon support
-- Provides icons for various file types, git status, and more
return {
  "nvim-mini/mini.icons",
  lazy = true,
  opts = {},
  init = function()
    package.preload["nvim-web-devicons"] = function()
      require("mini.icons").mock_nvim_web_devicons()
      return package.loaded["nvim-web-devicons"]
    end
  end,
}
