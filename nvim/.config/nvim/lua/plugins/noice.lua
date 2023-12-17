return {
  "folke/noice.nvim",
  event = "VeryLazy",
  enabled = false,
  dependencies = {
    "munifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  opts = {
    routes = {
      {
        view = "notify",
        filter = { event = "msg_showmode" },
      },
    },
  },
}
