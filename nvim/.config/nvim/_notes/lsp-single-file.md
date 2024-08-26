# Using a LSP for single file mode

## Problem

When running some LSPs it looks for a root directory for the presence of an eslint
config file, for example. I want to be able to use the language server for single
files as well.

Apparently there is a way to run LSPs in single file mode. There is a thread
[here](https://www.reddit.com/r/neovim/comments/18geeh1/should_i_switch_to_lazyvim_or_other_premade/)
with some hints.

One commenter says:

> In single file use cases you still have to say to Eslint what rules should be
> applied if no eslintrc is present.

<http://foo.bar.com>
