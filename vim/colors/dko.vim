" ============================================================================
" DKO
" A dark truecolor Vim colorscheme
" ============================================================================

if !has('termguicolors') || !&termguicolors | finish | endif
if exists('syntax_on') | syntax reset | endif
hi clear

let g:colors_name = 'dko'

" Override vim-pandoc-syntax highlighting
augroup colorsdko
  autocmd!
  autocmd Syntax *pandoc* colorscheme dko
augroup END

" ============================================================================
" My colors
" ============================================================================

hi! dkoBgAlt         guibg=#222226
hi! dkoLight         guibg=#303033  guifg=#bbbbbb

hi! dkoNormal        guibg=#202022  guifg=#aaaaaa
hi! dkoAlt                          guifg=#eeeeee

hi! dkoComment                      guifg=#505a6a gui=italic
hi! dkoCommentDoc                   guifg=#707a8a gui=NONE
hi! dkoDiffAdded     guibg=#2a332a  guifg=#668844
hi! dkoDiffRemoved   guibg=#4a2a2a  guifg=#aa6666
hi! dkoEm                           guifg=#ddaa66 gui=italic
hi! dkoEmComment     guibg=#303033  guifg=#ddaa66 gui=bold
hi! dkoFunctionName                 guifg=#99bbaa
hi! dkoLink                         guifg=#99bbaa gui=underline
hi! dkoImportant                    guifg=#cc6622
hi! dkoStatement                    guifg=#bbbbbb
hi! dkoStatus        guibg=#303033                gui=NONE
hi! dkoString                       guifg=#eeddcc
hi! link dkoOperator    dkoFunctionName
hi! link dkoUnimportant dkoNormal

" JavaDoc
hi! link dkoJavaDocTag     dkoCommentDoc
hi! link dkoJavaDocType    dkoCommentDoc
hi! link dkoJavaDocKey     dkoCommentDoc

" Statusline Symbols
hi! dkoLineImportant guibg=#ddaa66 guifg=#303033
hi! link dkoLineModeReplace       dkoLineImportant
hi! link dkoLineNeomakeRunning    dkoLineImportant

" Signs
hi! dkoSignError guibg=#5a2a2a guifg=#cc4444
hi! link  dkoSignAdded    dkoDiffAdded
hi! link  dkoSignRemoved  dkoDiffRemoved
hi! dkoSignChanged guibg=#2c2b2a guifg=#7f6030

" ============================================================================
" Vim base
" ============================================================================

hi! link normal dkoNormal

" ~ markers before and after buffer and some other ui
hi! NonText                         guifg=#334455
hi! Visual          guibg=#afa08f   guifg=#1f1f1f
" e.g. <C-v> symbols
hi! SpecialKey                      guifg=#772222
" e.g. 'search hit BOTTOM' messages
hi! WarningMsg                      guifg=#ccaa88
hi! Whitespace      guibg=#221f1f   guifg=#552222
hi! Number                          guifg=#ee7777

hi! link Comment      dkoComment
hi! link Conditional  dkoNormal
hi! link Constant     dkoNormal
hi! link Delimiter    dkoImportant
hi! link Folded       dkoLight
hi! link Function     dkoFunctionName
hi! link Identifier   dkoStatement
hi! link Include      dkoNormal
hi! link Keyword      dkoNormal
hi! link Label        dkoStatement
hi! link Noise        dkoUnimportant
hi! link Operator     dkoOperator
hi! link PreProc      dkoString
hi! link Special      Delimiter
hi! link Statement    dkoStatement
hi! link String       dkoString
hi! link Title        dkoString
hi! link Todo         dkoEmComment
hi! link Type         dkoStatement
hi! link Underlined   dkoLink

" ============================================================================
" Line backgrounds
" ============================================================================

" fg is thin line
hi! VertSplit           guibg=#222226   guifg=#222226
hi! LineNr              guibg=#222226   guifg=#404044
hi! CursorLineNr        guibg=#303033   guifg=#a0a0aa
hi! link SignColumn     LineNr

hi! link ColorColumn    dkoBgAlt
hi! link CursorColumn   dkoBgAlt
hi! link CursorLine     dkoBgAlt

" ============================================================================
" Status and tab line
" ============================================================================

" Statusline uses fg as bg
hi! StatusLineNC        guibg=#26262a gui=NONE
hi! link StatusLine     dkoStatus
hi! link TabLine        dkoStatus
hi! link TabLineFill    dkoStatus
hi! link TabLineSel     dkoStatus

" ============================================================================
" Command mode
" ============================================================================

hi! link Directory dkoStatement

" ============================================================================
" Popup menu
" ============================================================================

hi! link Pmenu dkoLight
hi! PmenuSel       guibg=#404044
" popup menu scrollbar
hi! link PmenuSbar PmenuSel
hi! PmenuThumb     guibg=#505055

" ============================================================================
" Search
" ============================================================================

hi! Search         guibg=#ee9966   guifg=#202022

" ============================================================================
" Plugin provided signs
" ============================================================================

hi! link ALEErrorSign             dkoSignError
hi! link QuickFixSignsDiffAdd     dkoSignAdded
hi! link QuickFixSignsDiffChange  dkoSignChanged
hi! link QuickFixSignsDiffDelete  dkoSignRemoved
hi! link GitGutterAdd             dkoSignAdded
hi! link GitGutterChange          dkoSignChanged
hi! link GitGutterChangeDelete    dkoSignChanged
hi! link GitGutterDelete          dkoSignRemoved
hi! link SignifySignAdd           dkoSignAdded
hi! link SignifySignChange        dkoSignChanged
hi! link SignifySignChangeDelete  dkoSignChanged
hi! link SignifySignDelete        dkoSignRemoved

" the head in <head></head>
hi! MatchParen    guibg=#225588   guifg=#dddddd
" the <> in <head>
hi! ParenMatch    guibg=#ee4433   guifg=#eeeeee gui=NONE

" ============================================================================
" Diff
" ============================================================================

hi! link diffFile       dkoUnimportant
hi! link diffIndexLine  dkoUnimportant
hi! link diffLine       dkoUnimportant
hi! link diffNewFile    dkoUnimportant

hi! link diffAdded      dkoDiffAdded
hi! link diffRemoved    dkoDiffRemoved

" ============================================================================
" Git (committia)
" ============================================================================

hi! link gitKeyword         dkoStatement
hi! link gitDate            dkoString
hi! link gitHash            dkoUnimportant

" ============================================================================
" JavaScript
" ============================================================================

hi! link jsModuleKeyword    dkoString
hi! link jsStorageClass     dkoNormal
hi! link jsReturn           dkoImportant
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

hi! link jsVariableDef      dkoStatement

" group 'class InlineEditors extends Component'
hi! link jsClassDefinition    dkoStatement
hi! link jsClassKeyword       dkoStatement
hi! link jsExtendsKeyword     dkoStatement

" group 'editorInstances = {};'
hi! link jsClassProperty      dkoNormal

" token 'componentWillMount'
hi! link jsClassFuncName      dkoNormal

hi! link jsFuncCall           dkoFunctionName
hi! link jsFuncArgs           dkoStatement
hi! link jsParen              dkoStatement

hi! link jsBracket            dkoStatement
hi! link jsSpreadExpression   dkoStatement
hi! link jsDestructuringBlock dkoStatement

hi! link jsObject             dkoStatement
hi! link jsObjectKey          dkoStatement
hi! link jsObjectKeyComputed  dkoString
hi! link jsObjectProp         dkoAlt

" ============================================================================
" JSON
" ============================================================================

hi! link jsonEscape           dkoOperator

" ============================================================================
" Pandoc
" ============================================================================

hi! link pandocAutomaticLink            dkoLink
hi! link pandocBlockQuote               dkoEm
hi! link pandocDelimitedCodeBlockStart  dkoUnimportant
hi! link pandocDelimitedCodeBlock       dkoString
hi! link pandocDelimitedCodeBlockEnd    dkoUnimportant
hi! link pandocReferenceURL             dkoLink

" ============================================================================
" PHP
" ============================================================================

hi! link phpType            dkoNormal
hi! link phpDocTags         dkoJavaDocTag
hi! link phpDocParam        dkoJavaDocType
hi! link phpDocIdentifier   dkoJavaDocKey

" ============================================================================
" Sh
" ============================================================================

hi! link shCommandSub       dkoFunctionName
" token: '-f' and '--flag'
hi! link shOption           dkoNormal

" ============================================================================
" vim-plug
" ============================================================================

hi! link plugName           dkoStatement
hi! link plugSha            dkoCommentDoc

" ============================================================================
" VimL
" ============================================================================

" ----------------------------------------------------------------------------
" Highlighting
" ----------------------------------------------------------------------------

" the word 'highlight' or 'hi'
hi! link vimHighlight   dkoNormal
" the word 'clear'
" First thing after 'hi'
hi! link vimGroup       dkoNormal
hi! link vimHiLink      dkoString
hi! link vimHiGroup     dkoNormal
" Don't highlight this one or it will override vim-css-colors
"hi! link vimHiGuiFgBg  dkoNormal

" ----------------------------------------------------------------------------
" Lang
" ----------------------------------------------------------------------------

hi! link vimCommentString dkoStatement
hi! link vimContinue      dkoOperator
" group 'function! dko#files#RefreshMru()' excluding abort
" vimFunction
" token
"hi vimIsCommand guifg=#cc8888
hi! link vimNotFunc     dkoNormal
" group for 'set encoding=utf-8'
hi! link vimSet         dkoNormal
" token 'encoding'
hi! link vimOption      dkoNormal
" token '=utf-8' but broken on things like '=dark'
"hi! link vimSetEqual    dkoString
" group
" e.g. has()
hi! link vimFunc        dkoNormal
hi! link vimFuncName    dkoNormal
" token 'ThisFunction' in 'dko#ThisFunction()'
"hi          link vimUserFunc    dkoString
" the word 'let'
hi! link vimLet         dkoNormal
" '=' in let x = y
" parens
hi! link vimParenSep    dkoUnimportant
hi! link vimString      dkoString
" the word 'syntax'
hi! link vimSyntax      dkoNormal
hi! link vimSynType     dkoNormal
"hi  vimVar                          guifg=#ccccaa

" ============================================================================
" vim help
" ============================================================================

hi! link helpExample          dkoString
hi! link helpHeader           dkoUnimportant
hi! link helpHeadline         dkoString
hi! link helpHyperTextEntry   dkoFunctionName
hi! link helpHyperTextJump    dkoStatement
hi! link helpNote             dkoUnimportant
hi! link helpOption           dkoFunctionName
hi! link helpSectionDelim     dkoUnimportant
hi! link helpSpecial          dkoStatement
hi! link helpURL              dkoString
hi! link helpVim              dkoString
hi! link helpWarning          dkoUnimportant

" ============================================================================
" zsh
" ============================================================================

hi! link zshCommands          dkoStatement
hi! link zshOperator          dkoOperator
hi! link zshOptStart          dkoStatement
hi! link zshOption            dkoNormal
