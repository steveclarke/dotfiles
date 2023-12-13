local M = {}

function M.keymap_options(options)
  options = options or {}
  local default_options = { noremap = true, silent = true }
  return vim.tbl_extend("force", default_options, options)
end

return M
