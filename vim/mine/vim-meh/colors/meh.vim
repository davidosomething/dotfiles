" ============================================================================
" MEH
" A dark truecolor Vim colorscheme
" ============================================================================

if !has('termguicolors') || !&termguicolors | finish | endif
hi clear
if exists('syntax_on') | syntax reset | endif

let g:colors_name = 'meh'
set background=dark

" ============================================================================
" Vim base
" ============================================================================

hi! Boolean                           guifg=#cccccc gui=italic
hi! Comment                           guifg=#50586a gui=italic
hi! Constant                          guifg=NONE    gui=italic
hi! Delimiter                         guifg=#cc99cc
hi! DiffAdd             guibg=#2a332a guifg=#668844
hi! DiffChange          guibg=#2c2b2a guifg=#7f6030
hi! DiffDelete          guibg=#4a2a2a guifg=#aa6666
hi! DiffText            guibg=#4a2a2a
hi! Error               guibg=#4a2a2a guifg=#ee7777
hi! Function                          guifg=NONE
hi! Identifier                        guifg=#dddddd
hi! Ignore                            guifg=#40485a
hi! IncSearch           guibg=#dd77cc guifg=bg      gui=NONE
hi! Label                             guifg=#dddddd
hi! MoreMsg                           guifg=#aa6666
hi! Noise                             guifg=#888888
hi! NonText                           guifg=#334455
hi! Normal              guibg=#202022 guifg=#aaaaaa
hi! Number                            guifg=#ee7777
hi! Operator                          guifg=#888888
hi! PreProc                           guifg=#dddddd
hi! Question                          guifg=#88aabb
hi! Search              guibg=#dd99ff guifg=bg
hi! Special                           guifg=#dd7766
hi! SpecialComment      guifg=#707a8a               gui=NONE
hi! SpecialKey                        guifg=#772222
hi! Statement                         guifg=#777777 gui=NONE
hi! StorageClass                      guifg=#777777
hi! String                            guifg=#88aabb
hi! Title                             guifg=#dddddd
hi! Todo                guibg=#303033 guifg=#ddaa66 gui=bold
hi! Type                              guifg=#dddddd gui=NONE
hi! Underlined                        guifg=#88aaee gui=underline
hi! Visual              guibg=#afa08f guifg=#1f1f1f
hi! WarningMsg                        guifg=#ccaa88
hi! Whitespace          guibg=#1c1c1c guifg=#333333

hi! link Character      Normal
hi! link Conditional    Normal
hi! link Directory      Identifier
hi! link Folded         dkoBgLight
hi! link Include        Normal
hi! link Keyword        Normal

" ============================================================================
" My colors
" ============================================================================

hi! dkoBgAlt            guibg=#24252a
hi! dkoBgLight          guibg=#303135

hi! dkoDecorations                    guifg=#505a6a
hi! dkoRegex                          guifg=#cc99cc
hi! dkoReturn                         guifg=#cc8877 gui=italic
hi! dkoQuote                          guifg=#77aa88 gui=italic
hi! dkoWarningText      guibg=#2c2b2a guifg=#ddaa66 gui=bold
hi! dkoNormalKey                      guifg=#ccccbb

" JavaDoc
hi! link dkoJavaDocTag  SpecialComment
hi! link dkoJavaDocType SpecialComment
hi! link dkoJavaDocKey  SpecialComment

" Signs
hi! dkoSignError        guibg=#5a2a2a guifg=#cc4444
hi! dkoSignWarning                    guifg=#ddaa66
hi! dkoSignInfo                       guifg=fg
hi! dkoSignMessage                    guifg=#77aa88
hi! link dkoSignAdded   DiffAdd
hi! link dkoSignRemoved DiffDelete

" ============================================================================
" Line backgrounds
" ============================================================================

" fg is thin line
hi! VertSplit           guibg=#262631 guifg=#262631
hi! LineNr              guibg=#222226 guifg=#404044
hi! CursorLineNr        guibg=#303033 guifg=#a0a0aa
hi! link FoldColumn     LineNr
hi! link SignColumn     LineNr

hi! link ColorColumn    dkoBgAlt
hi! link CursorColumn   dkoBgAlt

" current line
hi! link CursorLine     dkoBgLight

" ============================================================================
" Popup menu
" ============================================================================

hi! link Pmenu          dkoBgLight
hi! PmenuSel            guibg=#404044
" popup menu scrollbar
hi! link PmenuSbar      PmenuSel
hi! PmenuThumb          guibg=#505055

hi! link WildMenu       PmenuThumb

" ============================================================================
" Plugin provided signs
" ============================================================================

" w0rp/ale
"hi! link ALEErrorSign             dkoSignError
" tomtom/quickfixsigns_vim
hi! link QuickFixSignsDiffAdd     dkoSignAdded
hi! link QuickFixSignsDiffChange  DiffChange
hi! link QuickFixSignsDiffDelete  dkoSignRemoved
" airblade/vim-gitgutter
hi! link GitGutterAdd             dkoSignAdded
hi! link GitGutterChange          DiffChange
hi! link GitGutterChangeDelete    DiffChange
hi! link GitGutterDelete          dkoSignRemoved
" mhinz/vim-signify
hi! link SignifySignAdd           dkoSignAdded
hi! link SignifySignChange        DiffChange
hi! link SignifySignChangeDelete  DiffChange
hi! link SignifySignDelete        dkoSignRemoved
" chrisbra/changesPlugin
hi! link ChangesSignTextAdd       dkoSignAdded
hi! link ChangesSignTextCh        DiffChange
hi! link ChangesSignTextDel       dkoSignRemoved

" the head in <head></head>
hi! MatchParen        guibg=#225588 guifg=#ddddcc
" the <> in <head>
hi! ParenMatch        guibg=#994433 guifg=#ddddcc gui=NONE

" ============================================================================
" CSS
" ============================================================================

hi! link cssTagName     Delimiter
hi! link cssProp        StorageClass
hi! link lessVariable   Identifier

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

hi! link jsBuiltins           Identifier

hi! link jsRegexpCharClass    dkoRegex
hi! link jsRegexpString       dkoRegex

hi! link jsGlobalObjects      Normal
hi! link jsGlobalNodeObjects  dkoNormalKey
hi! link jsFuncArgOperator    Operator
hi! link jsModuleKeyword      String
hi! link jsNull               Constant
hi! link jsReturn             dkoReturn
hi! link jsSuper              dkoQuote
"hi! link jsStorageClass       Statement
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
hi! link jsDestructuringBlock dkoNormalKey

hi! link jsObject             Identifier
hi! link jsObjectKey          dkoNormalKey
hi! link jsObjectKeyComputed  String
hi! link jsObjectProp         Normal

hi! link jsxAttrib              dkoNormalKey
hi! link jsxAttributeBraces     Noise
hi! link jsxEqual               Noise

" ============================================================================
" JSON
" ============================================================================

hi! link jsonBoolean          Boolean
hi! link jsonEscape           Operator

" ============================================================================
" PHP
" ============================================================================

hi! link phpClass             Identifier
hi! link phpType              Normal
hi! link phpDocTags           dkoJavaDocTag
hi! link phpDocParam          dkoJavaDocType
hi! link phpDocIdentifier     dkoJavaDocKey
hi! link phpInclude           Statement
hi! link phpMemberSelector    Noise
hi! link phpVarSelector       Type

" ============================================================================
" Python
" ============================================================================

hi! link pythonQuotes         Noise
hi! link pythonTripleQuotes   Noise

" ============================================================================
" Ruby
" ============================================================================

hi! link rubyInterpolation    PreProc
hi! link rubyRegexp           dkoRegex
" rubyRegexpSpecial is not always part of rubyRegexp
hi! link rubyRegexpSpecial    dkoRegex
hi! link rubyStringDelimiter  Noise

" ============================================================================
" Sh
" ============================================================================

hi! link shCommandSub         Function
" token: '-f' and '--flag'
hi! link shOption             Normal

" ============================================================================
" vim-plug
" ============================================================================

hi! link plug1                Normal
hi! link plug2                dkoDecorations
hi! link plugDash             dkoDecorations
hi! link plugSha              SpecialComment

" ============================================================================
" VimL
" ============================================================================

" ----------------------------------------------------------------------------
" Highlighting
" ----------------------------------------------------------------------------

" the word 'highlight' or 'hi'
hi! link vimHighlight         Normal
" the word 'clear'
" First thing after 'hi'
hi! link vimGroup             Normal
hi! link vimHiLink            String
hi! link vimHiGroup           Normal
" Don't highlight this one or it will override vim-css-colors
"hi! link vimHiGuiFgBg  Normal

" ----------------------------------------------------------------------------
" Lang
" ----------------------------------------------------------------------------

hi! link vimCommentTitle      SpecialComment
hi! link vimCommentString     Identifier
hi! link vimContinue          dkoDecorations
hi! link vimOption            Normal
" token '=utf-8' but broken on things like '=dark'
hi! link vimSet               String
hi! link vimSetEqual          String
" group
" e.g. has()
hi! link vimFunc              Normal
hi! link vimFuncName          Normal
" token 'ThisFunction' in 'dko#ThisFunction()'
"hi          link vimUserFunc    String
" the word 'let'
hi! link vimLet               Normal
" '=' in let x = y
" parens
hi! link vimParenSep          dkoDecorations
hi! link vimString            String
" the word 'syntax'
hi! link vimSyntax            Normal
hi! link vimSynType           Normal

" ============================================================================
" vim help
" ============================================================================

hi! link helpExample          String
hi! link helpHeadline         Title
hi! link helpOption           Identifier
hi! link helpSectionDelim     Ignore
hi! link helpSpecial          dkoRegex
hi! link helpWarning          dkoWarningText

" ============================================================================
" yaml
" ============================================================================

hi! link yamlBool             Boolean

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
hi! link QuickFixLine dkoBgLight
hi! link qfFileName   SpecialComment
hi! link qfLineNr     Comment
hi! link qfSeparator  dkoDecorations

" ============================================================================
" Neomake
" ============================================================================

hi! NeomakeError                guibg=#5a2a2a
hi! NeomakeInfo                 guibg=#2a332a
hi! NeomakeMessage              guibg=#2a332a
hi! NeomakeWarning              guibg=#2c2b2a
hi! link NeomakeErrorSign       dkoSignError
hi! link NeomakeWarningSign     dkoSignWarning
hi! link NeomakeInfoSign        dkoSignInfo
hi! link NeomakeMessageSign     dkoSignMessage

" ============================================================================
" netrw
" ============================================================================

hi link netrwTreeBar  dkoDecorations
hi link netrwClassify Delimiter
hi link netrwExe      Normal

" ============================================================================
" Line
" ============================================================================

call meh#LineColors()
