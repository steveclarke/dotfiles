#!/usr/bin/env ruby

GIT_BUNDLES = [
  "git://github.com/mileszs/ack.vim.git",
  "git://github.com/vim-scripts/Color-Sampler-Pack.git",
  "git://github.com/tpope/vim-fugitive.git",
  "git://github.com/tpope/vim-git.git",
  "git://github.com/tpope/vim-haml.git",
  "git://github.com/michaeljsmith/vim-indent-object.git",
  "git://github.com/pangloss/vim-javascript.git",
  "git://github.com/wycats/nerdtree.git",
  "git://github.com/ddollar/nerdcommenter.git",
  "git://github.com/tpope/vim-surround.git",
  "git://github.com/tpope/vim-repeat.git",
  "git://github.com/vim-scripts/taglist.vim.git",
  "git://github.com/tpope/vim-vividchalk.git",
  "git://github.com/altercation/vim-colors-solarized.git",
  "git://github.com/ervandew/supertab.git",
  "git://github.com/tpope/vim-cucumber.git",
  "git://github.com/timcharper/textile.vim.git",
  "git://github.com/tpope/vim-rails.git",
  "git://github.com/taq/vim-rspec.git",
  "git://github.com/vim-scripts/ZoomWin.git",
  "git://github.com/tpope/vim-markdown.git",
  "git://github.com/tsaleh/vim-align.git",
  "git://github.com/tpope/vim-unimpaired.git",
  "git://github.com/vim-scripts/searchfold.vim.git",
  "git://github.com/tpope/vim-endwise.git",
  "git://github.com/wgibbs/vim-irblack.git",
  "git://github.com/kchmck/vim-coffee-script.git",
  "git://github.com/scrooloose/syntastic.git",
  "git://github.com/bdd/vim-scala.git",
  "git://github.com/mattn/gist-vim.git",
  "git://git.wincent.com/command-t.git",
  "git://github.com/godlygeek/csapprox.git",
  "git://github.com/rygwdn/vim-conque.git",
  "git://github.com/Townk/vim-autoclose.git",
  "git://github.com/tpope/vim-ragtag.git",
  "git://github.com/Vladimiroff/vim-sparkup.git",
  "git@github.com:doctorbh/snipmate.vim.git",
]

require 'fileutils'

HOME_DIR    = File.expand_path('~')
BUNDLES_DIR = File.join(HOME_DIR, 'src/vim/bundles')

if !File.directory?(BUNDLES_DIR)
  puts "*** Oops looks like you're missing the bundles directory."
  puts "*** Maybe you didn't run bootsrap.rb from your dotfiles root?"
  puts "*** ABORTING UNTIL YOU STRAIGHTEN OUT THIS MESS YOUNG MAN!"
  exit
end

FileUtils.cd(BUNDLES_DIR)

GIT_BUNDLES.each do |url|
  dir = url.split('/').last.sub(/\.git$/, '')
  puts "unpacking #{url} into #{dir}"
  `git clone #{url} #{dir}`
end

puts "--> Done. Go and configure Command-t bundle now."
puts "    You're a big boy. I'm sure you'll remember how."
puts "    Hint: 'rbenv shell system', 'rake make'"
