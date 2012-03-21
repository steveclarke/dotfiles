#!/usr/bin/env ruby
#  Thanks to https://github.com/noprompt/vic for the awesome Colorscheme writing Ruby library for Vim.
#

require 'vic'

scheme = Vic::Colorscheme.new 'Dull-Pastel' do

  info = {
    :author => 'Chris Clarke',
    :URL    => 'https://www.github.com/Beakr'
  }

  cl = {
    # Comments
    :gray => '#767676',

    # Primary colors
    :red  => '#ed7265',
    :blue => '#b2d0e7',
    :yellow => '#e7af56',
    
    # Strings
    :green => '#9ec176',
    :dgreen => '#778844', # Dark green for quotes

    # Keywords & Functions
    :purple => '#cdc4f0',

    # Only used for background of invalid text!
    :invalid => '#c94f5a',

    # Background & Foreground
    :bg => '#242521',
    :fg => '#d7d7d7',
    
    # Selections and current line stuff
    :sl => '#30312C',
    :mp => '#7D93A6' # Matching parens
  }

  # General highlights

  hi "Normal", guifg: cl[:fg], guibg: cl[:bg]

  # Character under cursor
  hi "Cursor", guifg: cl[:bg]

  # Line numbers
  hi "LineNr", guifg: cl[:gray]

  # Change that big red bar
  hi "ColorColumn", guifg: cl[:sl], guibg: cl[:sl]

  # Visual Line selection
  
 
  # Directory names
  hi "Directory", guifg: cl[:gray]
  
  # Code folds
  hi "Folded", guibg: cl[:sl]
  hi "FoldColumn", guibg: cl[:sl]

  # Matching Parenthisis
  hi "MatchParen", guibg: cl[:mp]

  hi "SignColumn", guibg: cl[:sl]

  # Overall messages that involve bad stuff (errors, invalid, etc.)
  hi "ErrorMsg", guifg: cl[:red], guibg: cl[:sl]
  hi "WarningMsg", guifg: cl[:red]
  hi "Invalid", guibg: cl[:red] # NOTE: This is a code attribute

  # Change the weird and ugly neon '/' that's visible in the File Tree
  hi "TreeDirSlash", guifg: cl[:gray]
  

  # Searches
  hi "Search", guibg: cl[:sl]

  # '~' and '@' at the end of windows
  hi 'NonText', guifg: cl[:gray]


  hi "CursorLine", guibg: cl[:sl] # NOT specified in cl {}
  hi "CursorColumn", guibg: cl[:sl]

  #############
  # Diff Mode #
  #############
  
  hi "DiffAdd", guifg: cl[:green]
  hi "DiffDelete", guifg: cl[:red]
  hi "DiffChange", guifg: cl[:yellow]


  #############
  # Help Docs #
  #############

  # I'm anti-neon
  hi "helpSectionDelim", guifg: cl[:blue]
  hi "helpHyperTextJump", guifg: cl[:red]
  hi "helpOption", guifg: cl[:green], gui: 'bold'
  hi "helpExample", guifg: cl[:red]
  hi "helpVim", guifg: cl[:yellow]
  hi "helpHeader", guifg: cl[:yellow] 
  

  ################################
  # Standard Highlighting Groups #
  ################################

  hi "Comment", guifg: cl[:gray]
  hi "String", guifg: cl[:green]
  hi "StringDelimiter", guifg: cl[:dgreen]
  hi "Operator", guifg: cl[:purple]
  hi "Keyword", guifg: cl[:purple]
  hi "Conditional", guifg: cl[:purple]
  hi "Function", guifg: cl[:red]
  hi "Define", guifg: cl[:purple]
  hi "Constant", guifg: cl[:yellow]
  hi "Statement", guifg: cl[:purple]
  hi "Repeat", guifg: cl[:purple]
  hi "Option", guifg: cl[:yellow]
  hi "Special", guifg: cl[:blue]
  hi "Delimiter", guifg: cl[:fg]

  # Only real constant highlight for Ruby that'll work
  hi "rubyConstant", guifg: cl[:yellow] 
  
  # The word 'TODO' in comments
  hi 'Todo', gui: 'bold'


  #############
  # Vimscript #
  #############

  language :vim do
    
    hi "Command", guifg: cl[:purple]
    hi "Option", guifg: cl[:yellow]
    hi "FuncName", guifg: cl[:yellow]
    hi "NotFunc", guifg: cl[:purple]

    hi "Map", guifg: cl[:purple]
    hi "Highlight", guifg: cl[:blue]
    hi "CommentTitle", guifg: cl[:blue], gui: 'bold'
    hi "SynType", guifg: cl[:yellow]
    
  end
  

  ########
  # Ruby #
  ########

  language :ruby do 
    hi "Symbol", guifg: cl[:red]

    hi "Todo", gui: 'bold'

    hi "Control", guifg: cl[:blue]
    hi "Include", guifg: cl[:purple]

    # Ruby variables
    hi "InstanceVariable", guifg: cl[:yellow]
    hi "ClassVariable", guifg: cl[:yellow]

    # do block ||'s
    hi "BlockParameter", guifg: cl[:yellow]
  end


  ##########
  # Python #
  ##########

  language :python do
   
  # Def statements, classes, etc. 
  hi "Statement", guifg: cl[:purple]

  # While/for loops
  hi "Repeat", guifg: cl[:purple] 

  end

  #####
  # C #
  #####

  language :c do
  
  hi "Include", guifg: cl[:purple]
  hi "Type", guifg: cl[:purple]
  hi "Repeat", guifg: cl[:purple] 

  end

  #######
  # C++ #
  #######

  language :cpp do # C++

  hi "Structure", guifg: cl[:purple]

  end

  ########
  # Java #
  ########

  language :java do

  hi "ClassDecl", guifg: cl[:purple]
  hi "ScopeDecl", guifg: cl[:blue]

  end
  
  

  #########
  # Scala #
  #########

  language :scala do
  
    # Blue isn't as nice for classes
    hi "Constructor", guifg: cl[:yellow]
    hi "ClassName", guifg: cl[:yellow] 
  
  end


  ########
  # HTML #
  ########

  language :html do
    
    hi "Tag", guifg: cl[:purple]
    hi "EndTag", guifg: cl[:blue]
    hi "TagName", guifg: cl[:purple]
    hi "Arg", guifg: cl[:yellow]

    # Make bold, italic, etc. tags actually their style
    hi "Bold", gui: 'bold'
    hi "Italic", gui: 'italic'

    hi "H1", guifg: cl[:fg], gui: 'bold'
    hi "H2", guifg: cl[:fg], gui: 'bold'
    hi "H3", guifg: cl[:fg], gui: 'bold'
    hi "H4", guifg: cl[:fg], gui: 'bold'
    hi "H5", guifg: cl[:fg], gui: 'bold'
    hi "H6", guifg: cl[:fg], gui: 'bold'

  end

  
  #######
  # Lua #
  #######
  
  language :lua do

  hi "Table", guifg: cl[:fg]
  hi "Func", guifg: cl[:purple]

  end
  

  ###############
  # Common Lisp #
  ###############

  language :lisp do

  # 'Def's
  hi "Decl", guifg: cl[:purple]

  # Functions (eq, print, etc.)
  hi "Func", guifg: cl[:purple]

  # Lisp data (text string with ' )
  hi "Atom", guifg: cl[:blue]

  # Earmuffs (*) and others
  hi "EscapeSpecial", guifg: cl[:yellow]

  end

  ###########
  # Clojure #
  ###########

  language :clojure do

  

  end

  ##########
  # Scheme #
  ##########

  language :scheme do

  hi "Syntax", guifg: cl[:purple] 

  end
  
  

end

# Auto-save file edits
File.open('dull-pastel.vim', 'w') do |file|
  file.write(scheme.write)
end
