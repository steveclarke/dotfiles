return {
  "kylechui/nvim-surround",
  version = "*",
  config = function()
    require("nvim-surround").setup({
      surrounds = {
        ["h"] = {
          add = function()
            return  { { "{{ " }, { " }}" } }
          end,
        }
      }
    })
  end
}
