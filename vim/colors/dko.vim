hi clear
syntax reset

let g:colors_name = 'dko'

" ============================================================================
" My colors
" ============================================================================

hi dkoBgDarkest     guibg=#1f1f1f
hi dkoBgDarker      guibg=#242424
hi dkoBgDark        guibg=#323232
hi dkoBgLight       guibg=#333333
hi dkoUnimportant   guifg=#666677
hi dkoImportant     guifg=#cc4444
hi dkoString        guifg=#eeddbb
hi dkoIdentifier    guifg=#bab080
hi dkoOperator      guifg=#eeeecc
hi dkoStatement     guifg=#80888f
hi dkoFunctionName  guifg=#bbbbcc

hi dkoComment                      guifg=#666677  gui=italic
hi dkoEmComment     guibg=#323232  guifg=#ddaa66  gui=bold

" JavaDoc
hi dkoJavaDocTag    guifg=#7788aa
hi dkoJavaDocType   guifg=#aa8877
hi dkoJavaDocKey    guifg=#bbccee

" Statusline
hi  dkoLineImportant              guibg=#ff8888     guifg=#242424
hi  link dkoLineModeReplace       dkoLineImportant
hi  link dkoLineNeomakeRunning    dkoLineImportant

" ============================================================================
" Vim base
" ============================================================================

hi  normal          guibg=#242424   guifg=#999988
hi  Folded          guibg=#333333   guifg=#999988
" ~ markers before and after buffer and some other ui
hi  NonText                         guifg=#334455
hi  Visual          guibg=#afa08f   guifg=#1f1f1f
" e.g. <C-v> symbols
hi  SpecialKey                      guifg=#772222
" e.g. 'search hit BOTTOM' messages
hi  WarningMsg                      guifg=#ccaa88
hi  Whitespace      guibg=#22222f   guifg=#444466
hi  Delimiter                       guifg=#778899
hi  Number                          guifg=#ee7777

hi! link Comment      dkoComment
hi  link Conditional  normal
hi! link Constant     normal
hi  link Function     dkoFunctionName
hi! link Identifier   dkoIdentifier
hi  link Include      normal
hi  link Keyword      normal
hi  link Label        dkoIdentifier
hi  link Noise        dkoUnimportant
hi  link Operator     dkoOperator
hi! link PreProc      dkoString
hi! link Special      Delimiter
hi! link Statement    dkoStatement
hi  link String       dkoString
hi  link Title        dkoString
hi! link Todo         dkoEmComment
hi! link Type         dkoIdentifier

" ============================================================================
" Line backgrounds
" ============================================================================

hi  ColorColumn         guibg=#2a2a2a
hi! link CursorColumn   ColorColumn
hi! link CursorLine     ColorColumn
hi  LineNr              guibg=#2a2a2a   guifg=#444433
hi! link CursorLineNr   ColorColumn
hi  CursorLineNr                        guifg=#555544
hi! link SignColumn     ColorColumn
" uses fg as bg
hi  VertSplit                           guifg=#202020

" ============================================================================
" Status and tab line
" ============================================================================

" Statusline uses fg as bg
hi! StatusLine          guibg=#333333 guifg=#888899 gui=NONE
hi! StatusLineNC        guifg=#1f1f1f gui=NONE
hi! TabLine             guibg=#333333 guifg=#888899 gui=NONE
hi! link TabLineFill    TabLine
hi! link TabLineSel     TabLine

" ============================================================================
" Command mode
" ============================================================================

hi! link Directory dkoUnimportant

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
" JavaScript
" ============================================================================

hi  link jsModuleKeyword    dkoString
hi  link jsStorageClass     normal
hi  link jsReturn           dkoImportant
hi  link jsNull             dkoImportant
hi  link jsThis             dkoStatement

" group {Event} e
" token Event
hi  link jsDocType          dkoJavaDocType
" token { }
hi  link jsDocTypeBrackets  dkoUnimportant

hi  link jsDocTags          dkoJavaDocTag
hi  link jsDocParam         dkoJavaDocKey

hi  link jsVariableDef      dkoIdentifier

" group 'class InlineEditors extends Component'
hi  link jsClassDefinition    dkoIdentifier
hi  link jsClassKeyword       dkoStatement
hi  link jsExtendsKeyword     dkoStatement

" group 'editorInstances = {};'
hi  link jsClassProperty      normal

" token 'componentWillMount'
hi  link jsClassFuncName      normal

hi  link jsFuncCall           dkoFunctionName
hi  link jsFuncArgs           dkoIdentifier
hi  link jsParen              dkoIdentifier

hi  link jsBracket            dkoIdentifier
hi  link jsSpreadExpression   dkoIdentifier
hi  link jsDestructuringBlock dkoIdentifier

hi  link jsObject             dkoIdentifier
hi  link jsObjectKey          dkoIdentifier
hi  link jsObjectKeyComputed  dkoString
hi  link jsObjectProp         dkoIdentifier

" ============================================================================
" JSON
" ============================================================================

hi  link jsonEscape           dkoOperator

" ============================================================================
" PHP
" ============================================================================

hi  link phpType            Delimiter
hi  link phpDocTags         dkoJavaDocTag
hi  link phpDocParam        dkoJavaDocType
hi  link phpDocIdentifier   dkoJavaDocKey

" ============================================================================
" Sh
" ============================================================================

hi  link shCommandSub       dkoFunctionName
" token: '-f' and '--flag'
hi  link shOption           normal

" ============================================================================
" VimL
" ============================================================================

" ----------------------------------------------------------------------------
" Highlighting
" ----------------------------------------------------------------------------

" the word 'highlight' or 'hi'
hi! link vimHighlight  normal
" the word 'clear'
" First thing after 'hi'
"hi! link vimGroup      normal
"hi! link vimHiLink      dkoString
hi! link vimHiGroup    normal
" Don't highlight this one or it will override vim-css-colors
"hi! link vimHiGuiFgBg  normal

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
hi! link vimSetEqual    dkoString

" group
" e.g. has()
hi  default link vimFunc        normal
hi          link vimFuncName    normal
hi          link vimUserFunc    dkoString

" the word 'let'
hi! link vimLet         normal
" '=' in let x = y
hi! link vimOper        normal
" parens
hi! link vimParenSep    dkoUnimportant
hi! link vimString      dkoString
" the word 'syntax'
hi! link vimSyntax      normal
hi! link vimSynType     normal
"hi  vimVar                          guifg=#ccccaa

" ============================================================================
" vim help
" ============================================================================

hi! link helpExample          dkoString
hi! link helpHeader           dkoUnimportant
hi! link helpHeadline         dkoString
hi! link helpHyperTextEntry   dkoUnimportant
hi  link helpHyperTextJump    dkoIdentifier
hi! link helpNote             dkoUnimportant
hi  link helpOption           dkoIdentifier
hi! link helpSectionDelim     dkoUnimportant
hi! link helpSpecial          helpOption
hi! link helpURL              dkoString
hi! link helpVim              dkoString
hi! link helpWarning          dkoUnimportant
