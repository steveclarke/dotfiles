-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = highlight_group,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- StandardRb LSP for Ruby files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "ruby",
  group = vim.api.nvim_create_augroup("RubyLSP", { clear = true }),
  callback = function()
    vim.lsp.start({
      name = "standard",
      cmd = { "standardrb", "--lsp" },
      on_attach = function() end,
    })
  end,
})

-- Automatically format ruby code on save
vim.api.nvim_create_autocmd("BufWrite", {
  pattern = "*.rb, *.jbuilder, *.rake, Gemfile, Rakefile, *.gemspec, *.ru, *.erb",
  group = vim.api.nvim_create_augroup("RubyFormat", { clear = true }),
  callback = function()
    vim.lsp.buf.format({ async = true })
  end,
})

-- 4 spaces for fish files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "fish",
  group = vim.api.nvim_create_augroup("FishIndent", { clear = true }),
  callback = function()
    vim.bo.tabstop = 4
    vim.bo.softtabstop = 4
    vim.bo.shiftwidth = 4
    vim.bo.expandtab = true
  end,
})
