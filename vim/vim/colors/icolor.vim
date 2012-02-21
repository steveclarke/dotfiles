set background=light
highlight clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "iColor"

" Show syntax highlighting groups for word under cursor
nmap <C-S-P> :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc


" Parans
highlight vimSep guifg=#75D962 guibg=#A7FFF9 gui=NONE
highlight vimParenSep guifg=#ffffff guibg=#A7FFF9 gui=NONE
