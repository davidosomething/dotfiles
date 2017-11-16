scriptencoding utf-8
" plugin/plug-vim-eclim.vim
" for eclim vim plugin (provided by dansomething/vim-eclim instead of upstream)

" Use neomake
let g:EclimFileTypeValidate = 0

" Disable everything non-java
let g:EclimCValidate                = 0
let g:EclimCssValidate              = 0
let g:EclimDtdValidate              = 0
let g:EclimHtmlValidate             = 0
let g:EclimJavaValidate             = 0
let g:EclimJavascriptValidate       = 0
let g:EclimPhpHtmlValidate          = 0
let g:EclimPhpValidate              = 0
let g:EclimPythonValidate           = 0
let g:EclimRubyValidate             = 0
let g:EclimXmlValidate              = 0
let g:EclimXsdValidate              = 0

let g:EclimCssIndentDisabled        = 1
let g:EclimDtdIndentDisabled        = 1
let g:EclimHtmlIndentDisabled       = 1
let g:EclimHtmldjangoIndentDisabled = 1
let g:EclimHtmljinjaIndentDisabled  = 1
let g:EclimJavascriptIndentDisabled = 1
let g:EclimPhpIndentDisabled        = 1
let g:EclimXmlIndentDisabled        = 1

let g:EclimHighlightDebug      = 'EclimDebug'
let g:EclimHighlightError      = 'EclimError'
let g:EclimHighlightInfo       = 'EclimInfo'
let g:EclimHighlightSuccess    = 'EclimSuccess'
let g:EclimHighlightWarning    = 'EclimWarning'
let g:EclimHighlightUserSign   = 'EclimUserSign'
let g:EclimLoclistSignText     = '⚑'
let g:EclimQuickfixSignText    = '⚑'
