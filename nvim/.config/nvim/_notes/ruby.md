# Ruby

Still trying to figure out the best Ruby configuration to use for diagnostics,
formatting and linting.

I've currently settled on just using:

* custom autocmd for formatting. standardrb doesn't work properly with conform.
* standardrb as LSP for linting
* no diagnostics

## Ruby LSP

This document from the Ruby LSP documentation says that there is currently an issue
with pre-0.10 Neovim and provides a workaround:
<https://shopify.github.io/ruby-lsp/EDITORS_md.html>

## Solargraph

Here is a thread discussing getting Solargraph to work:
<https://www.reddit.com/r/neovim/comments/18g4ya0/solargraph_rubocop_issues_in_lazyvim/?share_id=Ea8-xOHUDOkvPuo0YeRtE&utm_content=2&utm_medium=ios_app&utm_name=iossmf&utm_source=share&utm_term=22>

Specifically it mentions a conflict between Solargraph and Rubocop

A GH issue re: solargraph through mason.nvim
<https://github.com/williamboman/mason.nvim/issues/1292>
