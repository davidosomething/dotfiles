" ============================================================================
" DKO
" A dark truecolor Vim colorscheme
" ============================================================================

if !has('termguicolors') || !&termguicolors | finish | endif
hi clear
if exists('syntax_on') | syntax reset | endif

let g:colors_name = 'dko'
set background=dark

" Override vim-pandoc-syntax highlighting
augroup colorsdko
  autocmd!
  autocmd Syntax *pandoc* colorscheme dko
augroup END

" ============================================================================
" My colors
" ============================================================================

hi! dkoBgAlt          guibg=#24252a
hi! dkoLight          guibg=#303135

hi! dkoCommentDoc                   guifg=#707a8a gui=NONE
hi! dkoDecorations                  guifg=#505a6a
hi! dkoRegex                        guifg=#77aa88
hi! dkoReturn                       guifg=#cc8877 gui=italic
hi! dkoQuote                        guifg=#77aa88 gui=italic
hi! dkoStatus         guibg=#303033               gui=NONE

" JavaDoc
hi! link dkoJavaDocTag     dkoCommentDoc
hi! link dkoJavaDocType    dkoCommentDoc
hi! link dkoJavaDocKey     dkoCommentDoc

" Signs
hi! dkoSignError      guibg=#5a2a2a guifg=#cc4444
hi! dkoSignChanged    guibg=#2c2b2a guifg=#7f6030
hi! link  dkoSignAdded    DiffAdd
hi! link  dkoSignRemoved  DiffDelete

" ============================================================================
" Vim base
" ============================================================================

hi! Boolean                         guifg=#cccccc gui=italic
hi! Comment                         guifg=#50586a gui=italic
hi! Constant                        guifg=#aaaaaa gui=italic
hi! Delimiter                       guifg=#6688cc
hi! DiffAdd           guibg=#2a332a guifg=#668844
hi! DiffChange        guibg=#2c2b2a guifg=#7f6030
hi! DiffDelete        guibg=#4a2a2a guifg=#aa6666
hi! DiffText          guibg=#4a2a2a
hi! Error             guibg=#ee7777 guifg=#4a2a2a
hi! Function                        guifg=#aaaaaa
hi! Identifier                      guifg=#dddddd
hi! IncSearch         guibg=#dd77cc guifg=#202022 gui=NONE
hi! Label                           guifg=#dddddd
hi! Noise                           guifg=#888888
hi! NonText                         guifg=#334455
hi! Normal            guibg=#202022 guifg=#aaaaaa
hi! Number                          guifg=#ee7777
hi! Operator                        guifg=#888888
hi! PreProc                         guifg=#dddddd
hi! Search            guibg=#dd99ff guifg=#202022
hi! Special                         guifg=#dd7766
hi! SpecialKey                      guifg=#772222
hi! Statement                       guifg=#777777 gui=NONE
hi! String                          guifg=#88aabb
hi! Title                           guifg=#dddddd
hi! Todo              guibg=#303033 guifg=#ddaa66 gui=bold
hi! Type                            guifg=#dddddd gui=NONE
hi! Underlined                      guifg=#88aaee gui=underline
hi! Visual            guibg=#afa08f guifg=#1f1f1f
hi! WarningMsg                      guifg=#ccaa88
hi! Whitespace        guibg=#221f1f guifg=#552222

hi! link Character    Normal
hi! link Conditional  Normal
hi! link Directory    Identifier
hi! link Folded       dkoLight
hi! link Include      Normal
hi! link Keyword      Normal

" ============================================================================
" Line backgrounds
" ============================================================================

" fg is thin line
hi! VertSplit           guibg=#222226 guifg=#222226
hi! LineNr              guibg=#222226 guifg=#404044
hi! CursorLineNr        guibg=#303033 guifg=#a0a0aa
hi! link FoldColumn     LineNr
hi! link SignColumn     LineNr

hi! link ColorColumn    dkoBgAlt
hi! link CursorColumn   dkoBgAlt
hi! link CursorLine     dkoBgAlt

" ============================================================================
" Status and tab line
" ============================================================================

" Statusline uses fg as bg
hi! StatusLineNC        guibg=#26262a               gui=NONE
hi! link StatusLine     dkoStatus
hi! link TabLine        dkoStatus
hi! link TabLineFill    dkoStatus
hi! link TabLineSel     dkoStatus

" Statusline Symbols
" See mine/vim-dko-line/
hi! dkoLineImportant    guibg=#ddaa66 guifg=#303033
hi! link dkoLineModeReplace       dkoLineImportant
hi! link dkoLineNeomakeRunning    dkoLineImportant

" ============================================================================
" Popup menu
" ============================================================================

hi! link Pmenu dkoLight
hi! PmenuSel            guibg=#404044
" popup menu scrollbar
hi! link PmenuSbar PmenuSel
hi! PmenuThumb          guibg=#505055

" ============================================================================
" Plugin provided signs
" ============================================================================

" w0rp/ale
hi! link ALEErrorSign             dkoSignError
" tomtom/quickfixsigns_vim
hi! link QuickFixSignsDiffAdd     dkoSignAdded
hi! link QuickFixSignsDiffChange  dkoSignChanged
hi! link QuickFixSignsDiffDelete  dkoSignRemoved
" airblade/vim-gitgutter
hi! link GitGutterAdd             dkoSignAdded
hi! link GitGutterChange          dkoSignChanged
hi! link GitGutterChangeDelete    dkoSignChanged
hi! link GitGutterDelete          dkoSignRemoved
" mhinz/vim-signify
hi! link SignifySignAdd           dkoSignAdded
hi! link SignifySignChange        dkoSignChanged
hi! link SignifySignChangeDelete  dkoSignChanged
hi! link SignifySignDelete        dkoSignRemoved
" chrisbra/changesPlugin
hi! link ChangesSignTextAdd       dkoSignAdded
hi! link ChangesSignTextCh        dkoSignChanged
hi! link ChangesSignTextDel       dkoSignRemoved

" the head in <head></head>
hi! MatchParen        guibg=#225588 guifg=#ddddcc
" the <> in <head>
hi! ParenMatch        guibg=#994433 guifg=#ddddcc gui=NONE

" ============================================================================
" Diff
" ============================================================================

hi! link diffFile       Normal
hi! link diffIndexLine  Normal
hi! link diffLine       Normal
hi! link diffNewFile    Normal

hi! link diffAdded      DiffAdd
hi! link diffRemoved    DiffDelete

" ============================================================================
" Git (committia)
" ============================================================================

hi! link gitKeyword         Identifier
hi! link gitDate            String
hi! link gitHash            Normal

" ============================================================================
" vim-indentguides
" ============================================================================

hi! IndentGuidesOdd   guibg=#252527

" ============================================================================
" JavaScript
" ============================================================================

hi! link jsRegexpCharClass    dkoRegex
hi! link jsRegexpString       dkoRegex

hi! link jsGlobalObjects      Normal
hi! link jsGlobalNodeObjects  Normal
hi! link jsFuncArgOperator    Operator
hi! link jsModuleKeyword      String
hi! link jsNull               Constant
hi! link jsReturn             dkoReturn
hi! link jsStorageClass       Statement
hi! link jsTemplateBraces     dkoRegex
hi! link jsThis               Identifier
"hi! link jsVariableDef        Identifier

" group {Event} e
" token Event
hi! link jsDocType            dkoJavaDocType
hi! link jsDocTypeNoParam     dkoJavaDocType
" token { }
hi! link jsDocTypeBrackets    dkoDecorations

hi! link jsDocTags            dkoJavaDocTag
hi! link jsDocParam           dkoJavaDocKey

" group 'class InlineEditors extends Component'
hi! link jsClassDefinition    Identifier
hi! link jsClassKeyword       Identifier
hi! link jsExtendsKeyword     Identifier

" group 'editorInstances = {};'
hi! link jsClassProperty      Normal

" token 'componentWillMount'
hi! link jsClassFuncName      Normal

hi! link jsFuncCall           Function
hi! link jsFuncArgs           Identifier

hi! link jsBracket            Identifier
hi! link jsSpreadExpression   Identifier
hi! link jsDestructuringBlock Identifier

hi! link jsObject             Identifier
hi! link jsObjectKey          Identifier
hi! link jsObjectKeyComputed  String
hi! link jsObjectProp         Normal

" ============================================================================
" JSON
" ============================================================================

hi! link jsonBoolean          Boolean
hi! link jsonEscape           Operator

" ============================================================================
" Pandoc
" ============================================================================

hi! link pandocAtxHeader                Function
hi! link pandocAtxStart                 dkoDecorations
hi! link pandocAutomaticLink            Underlined
hi! link pandocBlockQuote               dkoQuote
hi! link pandocDelimitedCodeBlockStart  Normal
hi! link pandocDelimitedCodeBlock       String
hi! link pandocDelimitedCodeBlockEnd    Normal
hi! link pandocHRule                    dkoDecorations
hi! link pandocPipeTableDelims          dkoDecorations
hi! link pandocReferenceURL             Underlined
hi! link pandocUListItemBullet          Normal

" ============================================================================
" PHP
" ============================================================================

hi! link phpType            Normal
hi! link phpDocTags         dkoJavaDocTag
hi! link phpDocParam        dkoJavaDocType
hi! link phpDocIdentifier   dkoJavaDocKey

" ============================================================================
" Ruby
" ============================================================================

hi! link rubyInterpolation  PreProc

" ============================================================================
" Sh
" ============================================================================

hi! link shCommandSub       Function
" token: '-f' and '--flag'
hi! link shOption           Normal

" ============================================================================
" vim-plug
" ============================================================================

hi! link plug1              Normal
hi! link plug2              dkoDecorations
hi! link plugDash           dkoDecorations
hi! link plugSha            dkoCommentDoc

" ============================================================================
" VimL
" ============================================================================

" ----------------------------------------------------------------------------
" Highlighting
" ----------------------------------------------------------------------------

" the word 'highlight' or 'hi'
hi! link vimHighlight   Normal
" the word 'clear'
" First thing after 'hi'
hi! link vimGroup       Normal
hi! link vimHiLink      String
hi! link vimHiGroup     Normal
" Don't highlight this one or it will override vim-css-colors
"hi! link vimHiGuiFgBg  Normal

" ----------------------------------------------------------------------------
" Lang
" ----------------------------------------------------------------------------

hi! link vimCommentTitle  dkoCommentDoc
hi! link vimCommentString Identifier
hi! link vimContinue      dkoDecorations
hi! link vimOption        Normal
" token '=utf-8' but broken on things like '=dark'
hi! link vimSet           String
hi! link vimSetEqual      String
" group
" e.g. has()
hi! link vimFunc          Normal
hi! link vimFuncName      Normal
" token 'ThisFunction' in 'dko#ThisFunction()'
"hi          link vimUserFunc    String
" the word 'let'
hi! link vimLet           Normal
" '=' in let x = y
" parens
hi! link vimParenSep      dkoDecorations
hi! link vimString        String
" the word 'syntax'
hi! link vimSyntax        Normal
hi! link vimSynType       Normal

" ============================================================================
" vim help
" ============================================================================

hi! link helpExample          String
hi! link helpHeader           Normal
hi! link helpHeadline         String
hi! link helpHyperTextEntry   Function
hi! link helpHyperTextJump    Identifier
hi! link helpNote             Normal
hi! link helpOption           Function
hi! link helpSectionDelim     Normal
hi! link helpSpecial          Identifier
hi! link helpURL              String
hi! link helpVim              String
hi! link helpWarning          Normal

" ============================================================================
" zsh
" ============================================================================

hi! link zshCommands          Identifier
hi! link zshOperator          Operator
hi! link zshOptStart          Identifier
hi! link zshOption            Normal

" ============================================================================
" QuickFix
" ============================================================================

hi! qfError                                 guifg=#772222
hi! link QuickFixLine dkoLight
hi! link qfFileName   dkoCommentDoc
hi! link qfLineNr     Comment
hi! link qfSeparator  dkoDecorations

" ============================================================================
" Neomake
" ============================================================================

hi! NeomakeError              guibg=#5a2a2a
hi! NeomakeInfo               guibg=#2a332a
hi! NeomakeMessage            guibg=#2a332a
hi! NeomakeWarning            guibg=#2c2b2a

" ============================================================================
" netrw
" ============================================================================

hi link netrwTreeBar  dkoDecorations
hi link netrwClassify Delimiter
hi link netrwExe      Normal
