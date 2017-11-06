" ============================================================================
" DKO
" A dark truecolor Vim colorscheme
" ============================================================================

if !has('termguicolors') || !&termguicolors | finish | endif

hi! clear
set background=dark
syntax reset

let g:colors_name = 'dko'

" ============================================================================
" My colors
" ============================================================================

hi! dkoBgDarkest     guibg=#1f2120
hi! dkoBgDarker      guibg=#222423
hi! dkoBgDarkerAlt   guibg=#292b2a
hi! dkoUnimportant                  guifg=#666677
hi! dkoUnimportant2                 guifg=#9999bb
hi! dkoFinal                        guifg=#aa6666
hi! dkoInvalid                      guifg=#cc4444
hi! dkoImportant                    guifg=#cc4444
hi! dkoString                       guifg=#eeddbb
hi! dkoOperator                     guifg=#eeeecc
hi! dkoStatement                    guifg=#8888aa
hi! dkoFunctionName                 guifg=#9999bb
hi! dkoComment                      guifg=#666677  gui=italic
hi! dkoEmComment     guibg=#323232  guifg=#ddaa66  gui=bold
hi! link dkoIdentifier dkoStatement

" JavaDoc
hi! link dkoJavaDocTag            dkoUnimportant2
hi! link dkoJavaDocType           dkoUnimportant2
hi! link dkoJavaDocKey            dkoUnimportant2

" Statusline Symbols
hi!      dkoLineImportant         guibg=#ff8888     guifg=#242424
hi! link dkoLineModeReplace       dkoLineImportant
hi! link dkoLineNeomakeRunning    dkoLineImportant

" Signs
hi!       dkoSignError            guibg=#5a2a2a     guifg=#cc4444
hi!       dkoSignAdded            guibg=#2a332a     guifg=#668844
hi!       dkoSignDeleted          guibg=#332a2a     guifg=#cc4444
hi!       dkoSignChanged          guibg=#2c2b2a     guifg=#ffddaa

" ============================================================================
" Vim base
" ============================================================================

hi! normal          guibg=#222423   guifg=#aaaa99
hi! Folded          guibg=#333333   guifg=#aaaa99
" ~ markers before and after buffer and some other ui
hi! NonText                         guifg=#334455
hi! Visual          guibg=#afa08f   guifg=#1f1f1f
" e.g. <C-v> symbols
hi! SpecialKey                      guifg=#772222
" e.g. 'search hit BOTTOM' messages
hi! WarningMsg                      guifg=#ccaa88
hi! Whitespace      guibg=#22222f   guifg=#444466
hi! Delimiter                       guifg=#778899
hi! Number                          guifg=#ee7777

hi! link Comment      dkoComment
hi! link Conditional  normal
hi! link Constant     normal
hi! link Function     dkoFunctionName
hi! link Identifier   dkoIdentifier
hi! link Include      normal
hi! link Keyword      normal
hi! link Label        dkoIdentifier
hi! link Noise        dkoUnimportant
hi! link Operator     dkoOperator
hi! link PreProc      dkoString
hi! link Special      Delimiter
hi! link Statement    dkoStatement
hi! link String       dkoString
hi! link Title        dkoString
hi! link Todo         dkoEmComment
hi! link Type         dkoIdentifier

" ============================================================================
" Line backgrounds
" ============================================================================

" fg is thin line
hi! VertSplit           guibg=#252726   guifg=#252726

hi! SignColumn          guibg=#252726
hi! LineNr              guibg=#252726   guifg=#454746
hi! CursorLineNr        guibg=#353736   guifg=#555756

hi! link ColorColumn    dkoBgDarkerAlt
hi! link CursorColumn   dkoBgDarkerAlt
hi! link CursorLine     dkoBgDarkerAlt

" ============================================================================
" Status and tab line
" ============================================================================

" Statusline uses fg as bg
hi! StatusLine          guibg=#353736 guifg=#888899 gui=NONE
hi! StatusLineNC        guibg=#272928 guifg=#2f2f2f gui=NONE
hi! TabLine             guibg=#353736 guifg=#888899 gui=NONE
hi! link TabLineFill    TabLine
hi! link TabLineSel     TabLine

" ============================================================================
" Command mode
" ============================================================================

hi! link Directory dkoUnimportant2

" ============================================================================
" Popup menu
" ============================================================================

hi! Pmenu          guibg=#333333   guifg=#bbbbbb
hi! PmenuSel       guibg=#444444
" popup menu scrollbar
hi! link PmenuSbar PmenuSel
hi! PmenuThumb     guibg=#555555

" ============================================================================
" Search
" ============================================================================

hi! Search         guibg=#aa8866   guifg=#222222

" ============================================================================
" Plugin provided signs
" ============================================================================

hi! link ALEErrorSign       dkoSignError
hi! link QuickFixSignsDiffAdd     dkoSignAdded
hi! link QuickFixSignsDiffChange  dkoSignChanged
hi! link QuickFixSignsDiffDelete  dkoSignDeleted

" ============================================================================
" JavaScript
" ============================================================================

hi! link jsModuleKeyword    dkoString
hi! link jsStorageClass     normal
hi! link jsReturn           dkoFinal
hi! link jsNull             dkoImportant
hi! link jsThis             dkoStatement

" group {Event} e
" token Event
hi! link jsDocType          dkoJavaDocType
hi! link jsDocTypeNoParam   dkoJavaDocType
" token { }
hi! link jsDocTypeBrackets  dkoUnimportant

hi! link jsDocTags          dkoJavaDocTag
hi! link jsDocParam         dkoJavaDocKey

hi! link jsVariableDef      dkoIdentifier

" group 'class InlineEditors extends Component'
hi! link jsClassDefinition    dkoIdentifier
hi! link jsClassKeyword       dkoStatement
hi! link jsExtendsKeyword     dkoStatement

" group 'editorInstances = {};'
hi! link jsClassProperty      normal

" token 'componentWillMount'
hi! link jsClassFuncName      normal

hi! link jsFuncCall           dkoFunctionName
hi! link jsFuncArgs           dkoIdentifier
hi! link jsParen              dkoIdentifier

hi! link jsBracket            dkoIdentifier
hi! link jsSpreadExpression   dkoIdentifier
hi! link jsDestructuringBlock dkoIdentifier

hi! link jsObject             dkoIdentifier
hi! link jsObjectKey          dkoIdentifier
hi! link jsObjectKeyComputed  dkoString
hi! link jsObjectProp         dkoIdentifier

" ============================================================================
" JSON
" ============================================================================

hi! link jsonEscape           dkoOperator

" ============================================================================
" PHP
" ============================================================================

hi! link phpType            Delimiter
hi! link phpDocTags         dkoJavaDocTag
hi! link phpDocParam        dkoJavaDocType
hi! link phpDocIdentifier   dkoJavaDocKey

" ============================================================================
" Sh
" ============================================================================

hi! link shCommandSub       dkoFunctionName
" token: '-f' and '--flag'
hi! link shOption           normal

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
hi! link vimGroup      normal
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
"hi vimIsCommand guifg=#cc8888

hi! link vimNotFunc     normal

" group for 'set encoding=utf-8'
hi! link vimSet         normal
" token 'encoding'
hi! link vimOption      normal
" token '=utf-8' but broken on things like '=dark'
"hi! link vimSetEqual    dkoString

" group
" e.g. has()
hi! default link vimFunc        normal
hi!         link vimFuncName    normal
" token 'ThisFunction' in 'dko#ThisFunction()'
"hi          link vimUserFunc    dkoString

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
hi! link helpHyperTextJump    dkoIdentifier
hi! link helpNote             dkoUnimportant
hi! link helpOption           dkoIdentifier
hi! link helpSectionDelim     dkoUnimportant
hi! link helpSpecial          helpOption
hi! link helpURL              dkoString
hi! link helpVim              dkoString
hi! link helpWarning          dkoUnimportant
