return {
  "kylechui/nvim-surround",
  version = "*",
  config = function()
    require("nvim-surround").setup({
      surrounds = {
        -- (h)andlebar tags
        ["h"] = {
          add = function()
            return  { { "{{ " }, { " }}" } }
          end,
        },
        -- Markdown (c)ode block
        ["c"] = {
          add = function()
            return  { { "```" }, { "```" } }
          end,
        }
      }
    })
  end
}
