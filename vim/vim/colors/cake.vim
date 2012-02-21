set background=light
highlight clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "Cake"

" Show syntax highlighting groups for word under cursor
nmap <C-S-P> :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" -------------------------------------------------------------------------
"                      Vim commands and maintainence                      |
" -------------------------------------------------------------------------

" Cursor
highlight Cursor guifg=#000000 guibg=NONE gui=NONE
highlight CursorIM guifg=#ffffff guibg=NONE gui=NONE
highlight CursorColumn guifg=#94E9FF guibg=NONE gui=NONE
highlight Cursor guifg=white guibg=black
highlight iCursor guifg=white guibg=lightBlue
set guicursor=n-v-c:block-Cursor
set guicursor+=i:ver25-iCursor
set guicursor+=n-v-c:blinkon2
set guicursor+=i:blinkwait10
" Command line
highlight ErrorMsg guibg=#D52A2A guifg=NONE gui=NONE

" Interface
highlight NonText guifg=#00FFEF guibg=NONE gui=NONE
highlight MatchParen guibg=lightBlue guifg=NONE gui=NONE
highlight Tooltip guibg=#E0BA6D


" -------------------------------------------------------------------------
"                   Code and sytax-related highlighting                   |
" -------------------------------------------------------------------------


" Comments
highlight Comment guibg=#938C8C guibg=NONE gui=NONE

" Strings
highlight stringDelimiter guibg=#FF02DA guibg=NONE gui=NONE
highlight String guibg=#FF02DA guibg=NONE gui=NONE


