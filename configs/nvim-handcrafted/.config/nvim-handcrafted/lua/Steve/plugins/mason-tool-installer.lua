return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  dependencies = { "mason-org/mason.nvim" },
  opts = {
    ensure_installed = {
      "ruby_lsp",
      "lua_ls",
      "stylua",
    },
    auto_update = true,
    run_on_start = true,
    start_delay = 3000,
    debounce_hours = 12,
  }
}
