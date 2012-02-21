" Vim color file
" Converted from Textmate theme Dust using Coloration v0.3.2 (http://github.com/sickill/coloration)

set background=dark
highlight clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "Dust"

hi Cursor ctermfg=NONE ctermbg=15 cterm=NONE guifg=NONE guibg=#ffffff gui=NONE
hi Visual ctermfg=NONE ctermbg=153 cterm=NONE guifg=NONE guibg=#a7c9ff gui=NONE
hi CursorLine ctermfg=NONE ctermbg=16 cterm=NONE guifg=NONE guibg=#191917 gui=NONE
hi CursorColumn ctermfg=NONE ctermbg=16 cterm=NONE guifg=NONE guibg=#191917 gui=NONE
hi ColorColumn ctermfg=NONE ctermbg=16 cterm=NONE guifg=NONE guibg=#191917 gui=NONE
hi LineNr ctermfg=102 ctermbg=16 cterm=NONE guifg=#807c74 guibg=#191917 gui=NONE
hi VertSplit ctermfg=238 ctermbg=238 cterm=NONE guifg=#4a4843 guibg=#4a4843 gui=NONE
hi MatchParen ctermfg=187 ctermbg=NONE cterm=bold guifg=#d8d4ab guibg=NONE gui=bold
hi StatusLine ctermfg=230 ctermbg=238 cterm=bold guifg=#fff7e8 guibg=#4a4843 gui=bold
hi StatusLineNC ctermfg=230 ctermbg=238 cterm=NONE guifg=#fff7e8 guibg=#4a4843 gui=NONE
hi Pmenu ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi PmenuSel ctermfg=NONE ctermbg=153 cterm=NONE guifg=NONE guibg=#a7c9ff gui=NONE
hi IncSearch ctermfg=NONE ctermbg=59 cterm=NONE guifg=NONE guibg=#474638 gui=NONE
hi Search ctermfg=NONE ctermbg=59 cterm=NONE guifg=NONE guibg=#474638 gui=NONE
hi Directory ctermfg=223 ctermbg=NONE cterm=NONE guifg=#ffdca4 guibg=NONE gui=NONE
hi Folded ctermfg=102 ctermbg=0 cterm=NONE guifg=#948f81 guibg=#000000 gui=NONE

hi Normal ctermfg=230 ctermbg=0 cterm=NONE guifg=#fff7e8 guibg=#000000 gui=NONE
hi Boolean ctermfg=223 ctermbg=NONE cterm=NONE guifg=#ffdca4 guibg=NONE gui=NONE
hi Character ctermfg=223 ctermbg=NONE cterm=NONE guifg=#ffdca4 guibg=NONE gui=NONE
hi Comment ctermfg=102 ctermbg=NONE cterm=NONE guifg=#948f81 guibg=NONE gui=NONE
hi Conditional ctermfg=187 ctermbg=NONE cterm=bold guifg=#d8d4ab guibg=NONE gui=bold
hi Constant ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi Define ctermfg=187 ctermbg=NONE cterm=bold guifg=#d8d4ab guibg=NONE gui=bold
hi ErrorMsg ctermfg=196 ctermbg=NONE cterm=NONE guifg=#ff0000 guibg=NONE gui=NONE
hi WarningMsg ctermfg=196 ctermbg=NONE cterm=NONE guifg=#ff0000 guibg=NONE gui=NONE
hi Float ctermfg=215 ctermbg=NONE cterm=NONE guifg=#ffbc6a guibg=NONE gui=NONE
hi Function ctermfg=137 ctermbg=NONE cterm=bold guifg=#c28f3e guibg=NONE gui=bold
hi Identifier ctermfg=144 ctermbg=NONE cterm=NONE guifg=#b8b590 guibg=NONE gui=NONE
hi Keyword ctermfg=187 ctermbg=NONE cterm=bold guifg=#d8d4ab guibg=NONE gui=bold
hi Label ctermfg=222 ctermbg=NONE cterm=NONE guifg=#ffe894 guibg=NONE gui=NONE
hi NonText ctermfg=250 ctermbg=232 cterm=NONE guifg=#bfbfbf guibg=#0d0c0c gui=NONE
hi Number ctermfg=215 ctermbg=NONE cterm=NONE guifg=#ffbc6a guibg=NONE gui=NONE
hi Operator ctermfg=187 ctermbg=NONE cterm=bold guifg=#d8d4ab guibg=NONE gui=bold
hi PreProc ctermfg=187 ctermbg=NONE cterm=bold guifg=#d8d4ab guibg=NONE gui=bold
hi Special ctermfg=230 ctermbg=NONE cterm=NONE guifg=#fff7e8 guibg=NONE gui=NONE
hi SpecialKey ctermfg=250 ctermbg=16 cterm=NONE guifg=#bfbfbf guibg=#191917 gui=NONE
hi Statement ctermfg=187 ctermbg=NONE cterm=bold guifg=#d8d4ab guibg=NONE gui=bold
hi StorageClass ctermfg=144 ctermbg=NONE cterm=NONE guifg=#b8b590 guibg=NONE gui=NONE
hi String ctermfg=222 ctermbg=NONE cterm=NONE guifg=#ffe894 guibg=NONE gui=NONE
hi Tag ctermfg=137 ctermbg=NONE cterm=NONE guifg=#a48e49 guibg=NONE gui=NONE
hi Title ctermfg=230 ctermbg=NONE cterm=bold guifg=#fff7e8 guibg=NONE gui=bold
hi Todo ctermfg=102 ctermbg=NONE cterm=inverse,bold guifg=#948f81 guibg=NONE gui=inverse,bold
hi Type ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi Underlined ctermfg=NONE ctermbg=NONE cterm=underline guifg=NONE guibg=NONE gui=underline
hi rubyClass ctermfg=187 ctermbg=NONE cterm=bold guifg=#d8d4ab guibg=NONE gui=bold
hi rubyFunction ctermfg=137 ctermbg=NONE cterm=bold guifg=#c28f3e guibg=NONE gui=bold
hi rubyInterpolationDelimiter ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi rubySymbol ctermfg=223 ctermbg=NONE cterm=NONE guifg=#ffdca4 guibg=NONE gui=NONE
hi rubyConstant ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi rubyStringDelimiter ctermfg=222 ctermbg=NONE cterm=NONE guifg=#ffe894 guibg=NONE gui=NONE
hi rubyBlockParameter ctermfg=58 ctermbg=NONE cterm=NONE guifg=#65490c guibg=NONE gui=NONE
hi rubyInstanceVariable ctermfg=209 ctermbg=NONE cterm=NONE guifg=#ff766b guibg=NONE gui=NONE
hi rubyInclude ctermfg=187 ctermbg=NONE cterm=bold guifg=#d8d4ab guibg=NONE gui=bold
hi rubyGlobalVariable ctermfg=209 ctermbg=NONE cterm=NONE guifg=#ff766b guibg=NONE gui=NONE
hi rubyRegexp ctermfg=222 ctermbg=NONE cterm=NONE guifg=#ffe894 guibg=NONE gui=NONE
hi rubyRegexpDelimiter ctermfg=222 ctermbg=NONE cterm=NONE guifg=#ffe894 guibg=NONE gui=NONE
hi rubyEscape ctermfg=223 ctermbg=NONE cterm=NONE guifg=#ffdca4 guibg=NONE gui=NONE
hi rubyControl ctermfg=187 ctermbg=NONE cterm=bold guifg=#d8d4ab guibg=NONE gui=bold
hi rubyClassVariable ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi rubyOperator ctermfg=187 ctermbg=NONE cterm=bold guifg=#d8d4ab guibg=NONE gui=bold
hi rubyException ctermfg=187 ctermbg=NONE cterm=bold guifg=#d8d4ab guibg=NONE gui=bold
hi rubyPseudoVariable ctermfg=209 ctermbg=NONE cterm=NONE guifg=#ff766b guibg=NONE gui=NONE
hi rubyRailsUserClass ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi rubyRailsARAssociationMethod ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi rubyRailsARMethod ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi rubyRailsRenderMethod ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi rubyRailsMethod ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi erubyDelimiter ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi erubyComment ctermfg=102 ctermbg=NONE cterm=NONE guifg=#948f81 guibg=NONE gui=NONE
hi erubyRailsMethod ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi htmlTag ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi htmlEndTag ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi htmlTagName ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi htmlArg ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi htmlSpecialChar ctermfg=223 ctermbg=NONE cterm=NONE guifg=#ffdca4 guibg=NONE gui=NONE
hi javaScriptFunction ctermfg=144 ctermbg=NONE cterm=NONE guifg=#b8b590 guibg=NONE gui=NONE
hi javaScriptRailsFunction ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi javaScriptBraces ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi yamlKey ctermfg=137 ctermbg=NONE cterm=NONE guifg=#a48e49 guibg=NONE gui=NONE
hi yamlAnchor ctermfg=209 ctermbg=NONE cterm=NONE guifg=#ff766b guibg=NONE gui=NONE
hi yamlAlias ctermfg=209 ctermbg=NONE cterm=NONE guifg=#ff766b guibg=NONE gui=NONE
hi yamlDocumentHeader ctermfg=222 ctermbg=NONE cterm=NONE guifg=#ffe894 guibg=NONE gui=NONE
hi cssURL ctermfg=58 ctermbg=NONE cterm=NONE guifg=#65490c guibg=NONE gui=NONE
hi cssFunctionName ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi cssColor ctermfg=223 ctermbg=NONE cterm=NONE guifg=#ffdca4 guibg=NONE gui=NONE
hi cssPseudoClassId ctermfg=221 ctermbg=NONE cterm=NONE guifg=#ffe167 guibg=NONE gui=NONE
hi cssClassName ctermfg=221 ctermbg=NONE cterm=NONE guifg=#ffe167 guibg=NONE gui=NONE
hi cssValueLength ctermfg=215 ctermbg=NONE cterm=NONE guifg=#ffbc6a guibg=NONE gui=NONE
hi cssCommonAttr ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi cssBraces ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
