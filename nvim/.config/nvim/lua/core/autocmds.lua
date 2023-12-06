-- [[ Highlight on yank ]]
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })

vim.api.nvim_create_autocmd(
  "TextYankPost",
  {
    group = highlight_group,
    pattern = "*",
    callback = function()
      vim.highlight.on_yank()
    end,
  }
)
