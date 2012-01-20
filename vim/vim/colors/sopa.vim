" Vim color file
" Converted from Textmate theme SOPA using Coloration v0.3.2 (http://github.com/sickill/coloration)

set background=dark
highlight clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "sopa"

hi Cursor ctermfg=NONE ctermbg=0 cterm=NONE guifg=NONE guibg=#000000 gui=NONE
hi Visual ctermfg=NONE ctermbg=0 cterm=NONE guifg=NONE guibg=#000000 gui=NONE
hi CursorLine ctermfg=NONE ctermbg=0 cterm=NONE guifg=NONE guibg=#000000 gui=NONE
hi CursorColumn ctermfg=NONE ctermbg=0 cterm=NONE guifg=NONE guibg=#000000 gui=NONE
hi ColorColumn ctermfg=NONE ctermbg=0 cterm=NONE guifg=NONE guibg=#000000 gui=NONE
hi LineNr ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi VertSplit ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi MatchParen ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi StatusLine ctermfg=0 ctermbg=0 cterm=bold guifg=#000000 guibg=#000000 gui=bold
hi StatusLineNC ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi Pmenu ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi PmenuSel ctermfg=NONE ctermbg=0 cterm=NONE guifg=NONE guibg=#000000 gui=NONE
hi IncSearch ctermfg=NONE ctermbg=0 cterm=NONE guifg=NONE guibg=#000000 gui=NONE
hi Search ctermfg=NONE ctermbg=0 cterm=NONE guifg=NONE guibg=#000000 gui=NONE
hi Directory ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi Folded ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE

hi Normal ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi Boolean ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi Character ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi Comment ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi Conditional ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi Constant ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi Define ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi ErrorMsg ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi WarningMsg ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi Float ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi Function ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi Identifier ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi Keyword ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi Label ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi NonText ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi Number ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi Operator ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi PreProc ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi Special ctermfg=0 ctermbg=NONE cterm=NONE guifg=#000 guibg=NONE gui=NONE
hi SpecialKey ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi Statement ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi StorageClass ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi String ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi Tag ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi Title ctermfg=0 ctermbg=NONE cterm=bold guifg=#000000 guibg=NONE gui=bold
hi Todo ctermfg=0 ctermbg=0 cterm=inverse,bold guifg=#000000 guibg=#000000 gui=inverse,bold
hi Type ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi Underlined ctermfg=NONE ctermbg=NONE cterm=underline guifg=NONE guibg=NONE gui=underline
hi rubyClass ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi rubyFunction ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi rubyInterpolationDelimiter ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi rubySymbol ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi rubyConstant ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi rubyStringDelimiter ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi rubyBlockParameter ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi rubyInstanceVariable ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi rubyInclude ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi rubyGlobalVariable ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi rubyRegexp ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi rubyRegexpDelimiter ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi rubyEscape ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi rubyControl ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi rubyClassVariable ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi rubyOperator ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi rubyException ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi rubyPseudoVariable ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi rubyRailsUserClass ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi rubyRailsARAssociationMethod ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi rubyRailsARMethod ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi rubyRailsRenderMethod ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi rubyRailsMethod ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi erubyDelimiter ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi erubyComment ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi erubyRailsMethod ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi htmlTag ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi htmlEndTag ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi htmlTagName ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi htmlArg ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi htmlSpecialChar ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi javaScriptFunction ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi javaScriptRailsFunction ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi javaScriptBraces ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi yamlKey ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi yamlAnchor ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi yamlAlias ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi yamlDocumentHeader ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi cssURL ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi cssFunctionName ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi cssColor ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi cssPseudoClassId ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi cssClassName ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi cssValueLength ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi cssCommonAttr ctermfg=0 ctermbg=0 cterm=NONE guifg=#000000 guibg=#000000 gui=NONE
hi cssBraces ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
