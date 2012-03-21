" Vim color file

set background=dark
hi clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name="Dull-Pastel"

hi Normal guibg=#242521 guifg=#d7d7d7
hi Cursor guifg=#242521
hi LineNr guifg=#767676
hi ColorColumn guibg=#30312C guifg=#30312C
hi Directory guifg=#767676
hi Folded guibg=#30312C
hi FoldColumn guibg=#30312C
hi MatchParen guibg=#7D93A6
hi SignColumn guibg=#30312C
hi ErrorMsg guibg=#30312C guifg=#ed7265
hi WarningMsg guifg=#ed7265
hi Invalid guibg=#ed7265
hi TreeDirSlash guifg=#767676
hi Search guibg=#30312C
hi NonText guifg=#767676
hi CursorLine guibg=#30312C
hi CursorColumn guibg=#30312C
hi DiffAdd guifg=#9ec176
hi DiffDelete guifg=#ed7265
hi DiffChange guifg=#e7af56
hi helpSectionDelim guifg=#b2d0e7
hi helpHyperTextJump guifg=#ed7265
hi helpOption gui=bold guifg=#9ec176
hi helpExample guifg=#ed7265
hi helpVim guifg=#e7af56
hi helpHeader guifg=#e7af56
hi Comment guifg=#767676
hi String guifg=#9ec176
hi StringDelimiter guifg=#778844
hi Operator guifg=#cdc4f0
hi Keyword guifg=#cdc4f0
hi Conditional guifg=#cdc4f0
hi Function guifg=#ed7265
hi Define guifg=#cdc4f0
hi Constant guifg=#e7af56
hi Statement guifg=#cdc4f0
hi Repeat guifg=#cdc4f0
hi Option guifg=#e7af56
hi Special guifg=#b2d0e7
hi Delimiter guifg=#d7d7d7
hi rubyConstant guifg=#e7af56
hi Todo gui=bold
hi vimCommand guifg=#cdc4f0
hi vimFuncName guifg=#e7af56
hi vimNotFunc guifg=#cdc4f0
hi vimMap guifg=#cdc4f0
hi vimHighlight guifg=#b2d0e7
hi vimCommentTitle gui=bold guifg=#b2d0e7
hi vimSynType guifg=#e7af56
hi rubySymbol guifg=#ed7265
hi rubyControl guifg=#b2d0e7
hi rubyInclude guifg=#cdc4f0
hi rubyInstanceVariable guifg=#e7af56
hi rubyClassVariable guifg=#e7af56
hi rubyBlockParameter guifg=#e7af56
hi cInclude guifg=#cdc4f0
hi cType guifg=#cdc4f0
hi cppStructure guifg=#cdc4f0
hi javaClassDecl guifg=#cdc4f0
hi javaScopeDecl guifg=#b2d0e7
hi scalaConstructor guifg=#e7af56
hi scalaClassName guifg=#e7af56
hi htmlTag guifg=#cdc4f0
hi htmlEndTag guifg=#b2d0e7
hi htmlTagName guifg=#cdc4f0
hi htmlArg guifg=#e7af56
hi htmlBold gui=bold
hi htmlItalic gui=italic
hi htmlH1 gui=bold guifg=#d7d7d7
hi htmlH2 gui=bold guifg=#d7d7d7
hi htmlH3 gui=bold guifg=#d7d7d7
hi htmlH4 gui=bold guifg=#d7d7d7
hi htmlH5 gui=bold guifg=#d7d7d7
hi htmlH6 gui=bold guifg=#d7d7d7
hi luaTable guifg=#d7d7d7
hi luaFunc guifg=#cdc4f0
hi lispDecl guifg=#cdc4f0
hi lispFunc guifg=#cdc4f0
hi lispAtom guifg=#b2d0e7
hi lispEscapeSpecial guifg=#e7af56
hi schemeSyntax guifg=#cdc4f0