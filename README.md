# Beakr Labs Dotfiles
(Based on Doctor B. Honeydew's Dotfiles)

This is a collection of my config files to help me get each of my
computers quickly bootstrapped. It's a work in progress and is
specifically tweaked with lots of assumptions about where I like
to place things.

## Pre-requisites

* Repository lives at `~/src/dotfiles`
* [Homebrew](http://mxcl.github.com/homebrew/) is configured
* Vim with Python support compiled in [(see here)](http://www.andrewvos.com/2011/07/23/upgrading-vim-on-os-x-with-homebrew/) - required for UltiSnips and Sparkup.
* Rake is installed

## Installation

Run `rake:install`.

`rake --tasks` to see other stuff you can do.

## TODO:
* Create bootstrap file to get brew, rbenv, etc. installed before
  we run the rakefile
* Tweak my prompt
