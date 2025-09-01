-- oil.nvim: Buffer-based file manager for neovim
-- Allows editing directories like text buffers - rename files by editing text,
-- create/delete files with normal vim operations, and navigate directories seamlessly
-- Replaces netrw as the default file explorer with a more intuitive editing experience

return {
  'stevearc/oil.nvim',
  dependencies = { { "nvim-mini/mini.icons", opts = {} } },
  enabled = false,
  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  lazy = false,
  config = function()
    require("oil").setup({
      default_file_explorer = true,
      delete_to_trash = false,
      view_options = {
        show_hidden = true,
      },
    })
  end,
}
