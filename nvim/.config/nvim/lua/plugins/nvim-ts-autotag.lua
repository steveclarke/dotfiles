-- Use treesitter to auto close and auto rename html tag

return {
  "windwp/nvim-ts-autotag",
  config = function()
    require("nvim-ts-autotag").setup({
      autotag = {
        enable = true,
      },
    })
  end,
}
