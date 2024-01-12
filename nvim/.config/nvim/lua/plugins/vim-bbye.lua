return {
  "moll/vim-bbye",
  keys = {
    { "<leader>bd", ":Bdelete<CR>", desc = "Delete buffer (preserving windows)", silent = true },
    { "<leader>bw", ":Bwipeout<CR>", desc = "Wipeout buffer (preserving windows)", silent = true },
  },
}
