" A vim port of the excellent Twilight.tmtheme
"
" I've commented each color declaration with the elements it highilghts.
" Learn, tweak, and perfect. Please enjoy.
"  - JW

" Name: twinkle.vim
" Maintainer: Justin Woodbridge, jwoodbridge@me.com
" License: GPL


set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "twinkle"


" White text, black background
hi Normal guifg=white guibg=black
hi Cursor guibg=#FFFFFF

" Line Numbers
hi LineNr guifg=#666666

" Strings
hi String guifg=#8f9d6a
hi! link Number String
hi! link rubyStringDelimiter String

" Comments
hi Comment guifg=#5f5a60
hi! link Todo Comment

" nil, self, symbols
hi Constant guifg=#cf6a4c

" def, end, include, load, require, alias, super, yield, lambda, proc
hi Define guifg=#cda869
hi! link Include Define
hi! link Keyword Define
hi! link Macro Define

" #{foo}, <%= bar %>
hi Delimiter guifg=#ddf2a4

" function name
hi Function guifg=#9b703f

" @foo, @@foo, $foo
hi Identifier guifg=#7587a6 gui=NONE

" case, begin , do, for, if, unless, while, until, else
hi Statement guifg=#9b703f gui=NONE
hi! link PreProc Statement
hi! link PreCondit Statement

" SomeClassName
hi Type guifg=NONE gui=NONE

" normal item in popup.  Taken from railscasts.vim
hi Pmenu guifg=#F6F3E8 guibg=#444444 gui=NONE
" selected item in popup
hi PmenuSel guifg=#000000 guibg=#A5C160 gui=NONE
" scrollbar in popup
hi PMenuSbar guibg=#5A647E gui=NONE
" thumb of the scrollbar in the popup
hi PMenuThumb guibg=#AAAAAA gui=NONE
