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
hi! dkoLight         guibg=#303033

hi! dkoAlt                          guifg=#aaaaaa

hi! dkoCommentDoc                   guifg=#707a8a gui=NONE
hi! dkoDecorations                  guifg=#505a6a
hi! dkoQuote                        guifg=#77aa88 gui=italic
hi! dkoStatus        guibg=#303033                gui=NONE

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

hi! Normal          guibg=#202022 guifg=#aaaaaa
hi! Comment                       guifg=#50585f gui=italic
hi! Delimiter                     guifg=#cc6622
hi! DiffAdd         guibg=#2a332a guifg=#668844
hi! DiffChange      guibg=#2c2b2a guifg=#7f6030
hi! DiffDelete      guibg=#4a2a2a guifg=#aa6666
hi! DiffText        guibg=#4a2a2a
hi! Function                      guifg=#aaaaaa
hi! Identifier                    guifg=#aaaaaa
hi! IncSearch       guibg=#dd77cc guifg=#202022 gui=NONE
" ~ markers before and after buffer and some other ui
hi! NonText                       guifg=#334455
hi! Number                        guifg=#ee7777
hi! Visual          guibg=#afa08f guifg=#1f1f1f
hi! Search          guibg=#dd99ff guifg=#202022
" e.g. <C-v> symbols
hi! SpecialKey                    guifg=#772222
hi! String                        guifg=#77aa88
hi! Todo            guibg=#303033 guifg=#ddaa66 gui=bold
" e.g. 'search hit BOTTOM' messages
hi! WarningMsg                    guifg=#ccaa88
hi! Whitespace      guibg=#221f1f guifg=#552222
hi! Underlined                    guifg=#88aaee gui=underline

hi! link Conditional  Normal
hi! link Constant     Normal
hi! link Folded       dkoLight
hi! link Include      Normal
hi! link Keyword      Normal
hi! link Label        Identifier
hi! link Noise        Normal
hi! link Operator     Function
hi! link PreProc      String
hi! link Special      Delimiter
hi! link Statement    Identifier
hi! link Title        String
hi! link Type         Identifier

" ============================================================================
" Line backgrounds
" ============================================================================

" fg is thin line
hi! VertSplit           guibg=#222226   guifg=#222226
hi! LineNr              guibg=#222226   guifg=#404044
hi! CursorLineNr        guibg=#303033   guifg=#a0a0aa
hi! link FoldColumn     LineNr
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

" Statusline Symbols
" See mine/vim-dko-line/
hi! dkoLineImportant  guibg=#ddaa66 guifg=#303033
hi! link dkoLineModeReplace       dkoLineImportant
hi! link dkoLineNeomakeRunning    dkoLineImportant

" ============================================================================
" Command mode
" ============================================================================

hi! link Directory Identifier

" ============================================================================
" Popup menu
" ============================================================================

hi! link Pmenu dkoLight
hi! PmenuSel       guibg=#404044
" popup menu scrollbar
hi! link PmenuSbar PmenuSel
hi! PmenuThumb     guibg=#505055

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
hi! MatchParen    guibg=#225588   guifg=#ddddcc
" the <> in <head>
hi! ParenMatch    guibg=#ee4433   guifg=#ddddcc gui=NONE

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
" JavaScript
" ============================================================================

hi! link jsModuleKeyword    String
hi! link jsStorageClass     Normal
hi! link jsReturn           Delimiter
hi! link jsNull             Delimiter
hi! link jsThis             Identifier

" group {Event} e
" token Event
hi! link jsDocType          dkoJavaDocType
hi! link jsDocTypeNoParam   dkoJavaDocType
" token { }
hi! link jsDocTypeBrackets  Normal

hi! link jsDocTags          dkoJavaDocTag
hi! link jsDocParam         dkoJavaDocKey

hi! link jsVariableDef      Identifier

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
hi! link jsParen              Identifier

hi! link jsBracket            Identifier
hi! link jsSpreadExpression   Identifier
hi! link jsDestructuringBlock Identifier

hi! link jsObject             Identifier
hi! link jsObjectKey          Identifier
hi! link jsObjectKeyComputed  String
hi! link jsObjectProp         dkoAlt

" ============================================================================
" JSON
" ============================================================================

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
" Sh
" ============================================================================

hi! link shCommandSub       Function
" token: '-f' and '--flag'
hi! link shOption           Normal

" ============================================================================
" vim-plug
" ============================================================================

hi! link plugName           Identifier
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

hi! link vimCommentString Identifier
hi! link vimContinue      Operator
hi! link vimNotFunc       Normal
" group for 'set encoding=utf-8'
hi! link vimSet           String
" token 'encoding'
hi! link vimOption        Normal
" token '=utf-8' but broken on things like '=dark'
"hi! link vimSetEqual    String
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
hi! link vimParenSep      Normal
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
hi! link qfFileName dkoCommentDoc

" ============================================================================
" Neomake
" ============================================================================

hi! NeomakeError              guibg=#5a2a2a
hi! NeomakeInfo               guibg=#2a332a
hi! NeomakeMessage            guibg=#2a332a
hi! NeomakeWarning            guibg=#2c2b2a
