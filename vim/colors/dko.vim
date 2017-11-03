hi clear
syntax reset

let g:colors_name = 'dko'

hi normal         guibg=#222222   guifg=#999988
" ~ markers before and after buffer and some other ui
hi NonText                        guifg=#334455
hi Visual         guibg=#333333
" E.g. <C-v> symbols
hi SpecialKey                     guifg=#772222
hi Whitespace     guibg=#2a2222   guifg=#772222

" ============================================================================
" Line backgrounds
" ============================================================================

hi  ColorColumn         guibg=#2a2a2a
hi! link CursorColumn   ColorColumn
hi! link CursorLine     ColorColumn
hi  LineNr                              guifg=#444433
hi! link CursorLineNr   ColorColumn
hi  CursorLineNr                        guifg=#555544
hi! link SignColumn     ColorColumn
" uses fg as bg
hi  VertSplit                           guifg=#202020

" ============================================================================
" Status and tab line
" ============================================================================

" Statusline uses fg as bg
hi! StatusLine          guifg=#333333
hi! StatusLineNC        guifg=#1f1f1f
hi! link TabLine        StatusLine
hi! link TabLineFill    StatusLine
hi! link TabLineSel     StatusLine

" ============================================================================
" Command mode
" ============================================================================

hi! link Directory Comment

" ============================================================================
" Popup menu
" ============================================================================

hi  Pmenu          guibg=#333333   guifg=#bbbbbb
hi  PmenuSel       guibg=#444444
" popup menu scrollbar
hi! link PmenuSbar PmenuSel
hi  PmenuThumb     guibg=#555555

" ============================================================================
" Search
" ============================================================================

hi Search         guibg=#aa8866   guifg=#222222

" ============================================================================
" Language generics
" ============================================================================

hi  Comment                         guifg=#556688
hi  Delimiter                       guifg=#778899
hi  Identifier                      guifg=#cc9999
hi  Number                          guifg=#ee7777
hi  String                          guifg=#ddddff
hi  Special                         guifg=#334466
hi! link Function   String
hi! link Type       Identifier
hi! link Constant   normal
hi! link Include    normal
hi! link Keyword    normal
hi! link PreProc    String
hi! link Statement  Identifier
hi! link Title      String

" ============================================================================
" JavaDoc
" ============================================================================

hi dkoJavaDocTag    guifg=#7788aa
hi dkoJavaDocType   guifg=#aa8877
hi dkoJavaDocKey    guifg=#bbccee

" ============================================================================
" JavaScript
" ============================================================================

hi  link jsModuleKeyword    String
hi  link jsStorageClass     normal

" group {Event} e
" token Event
hi  link jsDocType          dkoJavaDocType
" token { }
hi  link jsDocTypeBrackets  Comment

hi  link jsDocTags          dkoJavaDocTag
hi  link jsDocParam         dkoJavaDocKey

hi  link jsVariableDef      String

" ============================================================================
" PHP
" ============================================================================

hi  link phpType            Delimiter
hi  link phpDocTags         dkoJavaDocTag
hi  link phpDocParam        dkoJavaDocType
hi  link phpDocIdentifier   dkoJavaDocKey

" ============================================================================
" VimL
" ============================================================================

" ----------------------------------------------------------------------------
" Highlighting
" ----------------------------------------------------------------------------

" the word 'clear'
hi vimHiClear                     guifg=#cc8888
" First thing after 'hi'
hi! link vimGroup      normal
hi! link vimHiGroup    normal
hi! link vimHiGuiFgBg  normal
" the word 'highlight'
hi! link vimHighlight  normal

" ----------------------------------------------------------------------------
" Lang
" ----------------------------------------------------------------------------

" group 'function! dko#files#RefreshMru()' excluding abort
" vimFunction

" token
"hi vimCommand
hi vimIsCommand guifg=#cc8888

hi! link vimNotFunc     normal

" group for 'set encoding=utf-8'
hi! link vimSet         normal
" token 'encoding'
hi! link vimOption      normal
" token '=utf-8'
hi! link vimSetEqual    String

" group
" e.g. has()
hi  default link vimFunc        normal
hi          link vimFuncName    normal
hi          link vimUserFunc    String

" the word 'let'
hi! link vimLet         normal
" '=' in let x = y
hi! link vimOper        normal
" parens
hi! link vimParenSep    Comment
hi! link vimString      String
" the word 'syntax'
hi! link vimSyntax      normal
hi! link vimSynType     normal
"hi  vimVar                          guifg=#ccccaa

" ============================================================================
" vim help
" ============================================================================

hi! link helpExample          String
hi! link helpHeader           Comment
hi! link helpHeadline         String
hi! link helpHyperTextEntry   Comment
hi  helpHyperTextJump                       guifg=#88dd88
hi! link helpNote             Comment
hi  helpOption                              guifg=#cc8888
hi! link helpSectionDelim     Comment
hi! link helpSpecial          helpOption
hi! link helpURL              String
hi! link helpVim              String
hi! link helpWarning          Comment
