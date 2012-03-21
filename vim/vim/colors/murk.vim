" Vim color file
" Converted from Textmate theme murk using Coloration v0.3.2 (http://github.com/sickill/coloration)

set background=dark
highlight clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "murk"

hi Cursor ctermfg=NONE ctermbg=253 cterm=NONE guifg=NONE guibg=#d9dadc gui=NONE
hi Visual ctermfg=NONE ctermbg=153 cterm=NONE guifg=NONE guibg=#afd3ff gui=NONE
hi CursorLine ctermfg=NONE ctermbg=144 cterm=NONE guifg=NONE guibg=#ada490 gui=NONE
hi CursorColumn ctermfg=NONE ctermbg=144 cterm=NONE guifg=NONE guibg=#ada490 gui=NONE
hi ColorColumn ctermfg=NONE ctermbg=144 cterm=NONE guifg=NONE guibg=#ada490 gui=NONE
hi LineNr ctermfg=187 ctermbg=144 cterm=NONE guifg=#cbc6a7 guibg=#ada490 gui=NONE
hi VertSplit ctermfg=144 ctermbg=144 cterm=NONE guifg=#bbb49b guibg=#bbb49b gui=NONE
hi MatchParen ctermfg=189 ctermbg=NONE cterm=bold guifg=#d5e7ff guibg=NONE gui=bold
hi StatusLine ctermfg=230 ctermbg=144 cterm=bold guifg=#f0f0c4 guibg=#bbb49b gui=bold
hi StatusLineNC ctermfg=230 ctermbg=144 cterm=NONE guifg=#f0f0c4 guibg=#bbb49b gui=NONE
hi Pmenu ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi PmenuSel ctermfg=NONE ctermbg=153 cterm=NONE guifg=NONE guibg=#afd3ff gui=NONE
hi IncSearch ctermfg=NONE ctermbg=249 cterm=NONE guifg=NONE guibg=#b6b5b1 gui=NONE
hi Search ctermfg=NONE ctermbg=249 cterm=NONE guifg=NONE guibg=#b6b5b1 gui=NONE
hi Directory ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi Folded ctermfg=188 ctermbg=144 cterm=NONE guifg=#d9d8cd guibg=#a69c8a gui=NONE

hi Normal ctermfg=230 ctermbg=144 cterm=NONE guifg=#f0f0c4 guibg=#a69c8a gui=NONE
hi Boolean ctermfg=221 ctermbg=NONE cterm=NONE guifg=#eccf71 guibg=NONE gui=NONE
hi Character ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi Comment ctermfg=188 ctermbg=NONE cterm=NONE guifg=#d9d8cd guibg=NONE gui=NONE
hi Conditional ctermfg=189 ctermbg=NONE cterm=bold guifg=#d5e7ff guibg=NONE gui=bold
hi Constant ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi Define ctermfg=189 ctermbg=NONE cterm=bold guifg=#d5e7ff guibg=NONE gui=bold
hi ErrorMsg ctermfg=NONE ctermbg=137 cterm=NONE guifg=NONE guibg=#a58073 gui=NONE
hi WarningMsg ctermfg=NONE ctermbg=137 cterm=NONE guifg=NONE guibg=#a58073 gui=NONE
hi Float ctermfg=121 ctermbg=NONE cterm=NONE guifg=#94ec9f guibg=NONE gui=NONE
hi Function ctermfg=223 ctermbg=NONE cterm=NONE guifg=#faccb8 guibg=NONE gui=NONE
hi Identifier ctermfg=230 ctermbg=NONE cterm=NONE guifg=#f0f0c4 guibg=NONE gui=NONE
hi Keyword ctermfg=189 ctermbg=NONE cterm=bold guifg=#d5e7ff guibg=NONE gui=bold
hi Label ctermfg=121 ctermbg=NONE cterm=NONE guifg=#94ec9f guibg=NONE gui=NONE
hi NonText ctermfg=144 ctermbg=144 cterm=NONE guifg=#a69c8a guibg=#aaa08d gui=NONE
hi Number ctermfg=121 ctermbg=NONE cterm=NONE guifg=#94ec9f guibg=NONE gui=NONE
hi Operator ctermfg=230 ctermbg=NONE cterm=NONE guifg=#f0f0c4 guibg=NONE gui=NONE
hi PreProc ctermfg=189 ctermbg=NONE cterm=bold guifg=#d5e7ff guibg=NONE gui=bold
hi Special ctermfg=230 ctermbg=NONE cterm=NONE guifg=#f0f0c4 guibg=NONE gui=NONE
hi SpecialKey ctermfg=144 ctermbg=144 cterm=NONE guifg=#a69c8a guibg=#ada490 gui=NONE
hi Statement ctermfg=189 ctermbg=NONE cterm=bold guifg=#d5e7ff guibg=NONE gui=bold
hi StorageClass ctermfg=230 ctermbg=NONE cterm=NONE guifg=#f0f0c4 guibg=NONE gui=NONE
hi String ctermfg=121 ctermbg=NONE cterm=NONE guifg=#94ec9f guibg=NONE gui=NONE
hi Tag ctermfg=230 ctermbg=NONE cterm=NONE guifg=#f0f0c4 guibg=NONE gui=NONE
hi Title ctermfg=230 ctermbg=NONE cterm=bold guifg=#f0f0c4 guibg=NONE gui=bold
hi Todo ctermfg=188 ctermbg=NONE cterm=inverse,bold guifg=#d9d8cd guibg=NONE gui=inverse,bold
hi Type ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi Underlined ctermfg=NONE ctermbg=NONE cterm=underline guifg=NONE guibg=NONE gui=underline
hi rubyClass ctermfg=189 ctermbg=NONE cterm=bold guifg=#d5e7ff guibg=NONE gui=bold
hi rubyFunction ctermfg=223 ctermbg=NONE cterm=NONE guifg=#faccb8 guibg=NONE gui=NONE
hi rubyInterpolationDelimiter ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi rubySymbol ctermfg=223 ctermbg=NONE cterm=NONE guifg=#faccb8 guibg=NONE gui=NONE
hi rubyConstant ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi rubyStringDelimiter ctermfg=121 ctermbg=NONE cterm=NONE guifg=#94ec9f guibg=NONE gui=NONE
hi rubyBlockParameter ctermfg=230 ctermbg=NONE cterm=NONE guifg=#f0f0c4 guibg=NONE gui=NONE
hi rubyInstanceVariable ctermfg=189 ctermbg=NONE cterm=NONE guifg=#dccff4 guibg=NONE gui=NONE
hi rubyInclude ctermfg=189 ctermbg=NONE cterm=bold guifg=#d5e7ff guibg=NONE gui=bold
hi rubyGlobalVariable ctermfg=189 ctermbg=NONE cterm=NONE guifg=#dccff4 guibg=NONE gui=NONE
hi rubyRegexp ctermfg=121 ctermbg=NONE cterm=NONE guifg=#94ec9f guibg=NONE gui=NONE
hi rubyRegexpDelimiter ctermfg=121 ctermbg=NONE cterm=NONE guifg=#94ec9f guibg=NONE gui=NONE
hi rubyEscape ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi rubyControl ctermfg=189 ctermbg=NONE cterm=bold guifg=#d5e7ff guibg=NONE gui=bold
hi rubyClassVariable ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi rubyOperator ctermfg=230 ctermbg=NONE cterm=NONE guifg=#f0f0c4 guibg=NONE gui=NONE
hi rubyException ctermfg=189 ctermbg=NONE cterm=bold guifg=#d5e7ff guibg=NONE gui=bold
hi rubyPseudoVariable ctermfg=189 ctermbg=NONE cterm=NONE guifg=#dccff4 guibg=NONE gui=NONE
hi rubyRailsUserClass ctermfg=221 ctermbg=NONE cterm=NONE guifg=#eccf71 guibg=NONE gui=NONE
hi rubyRailsARAssociationMethod ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi rubyRailsARMethod ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi rubyRailsRenderMethod ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi rubyRailsMethod ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi erubyDelimiter ctermfg=222 ctermbg=NONE cterm=NONE guifg=#f0c88b guibg=NONE gui=NONE
hi erubyComment ctermfg=188 ctermbg=NONE cterm=NONE guifg=#d9d8cd guibg=NONE gui=NONE
hi erubyRailsMethod ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi htmlTag ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi htmlEndTag ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi htmlTagName ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi htmlArg ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi htmlSpecialChar ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi javaScriptFunction ctermfg=230 ctermbg=NONE cterm=NONE guifg=#f0f0c4 guibg=NONE gui=NONE
hi javaScriptRailsFunction ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi javaScriptBraces ctermfg=223 ctermbg=NONE cterm=bold guifg=#faccb8 guibg=NONE gui=bold
hi yamlKey ctermfg=230 ctermbg=NONE cterm=NONE guifg=#f0f0c4 guibg=NONE gui=NONE
hi yamlAnchor ctermfg=189 ctermbg=NONE cterm=NONE guifg=#dccff4 guibg=NONE gui=NONE
hi yamlAlias ctermfg=189 ctermbg=NONE cterm=NONE guifg=#dccff4 guibg=NONE gui=NONE
hi yamlDocumentHeader ctermfg=121 ctermbg=NONE cterm=NONE guifg=#94ec9f guibg=NONE gui=NONE
hi cssURL ctermfg=230 ctermbg=NONE cterm=NONE guifg=#f0f0c4 guibg=NONE gui=NONE
hi cssFunctionName ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi cssColor ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi cssPseudoClassId ctermfg=221 ctermbg=NONE cterm=NONE guifg=#eccf71 guibg=NONE gui=NONE
hi cssClassName ctermfg=221 ctermbg=NONE cterm=NONE guifg=#eccf71 guibg=NONE gui=NONE
hi cssValueLength ctermfg=121 ctermbg=NONE cterm=NONE guifg=#94ec9f guibg=NONE gui=NONE
hi cssCommonAttr ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi cssBraces ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
