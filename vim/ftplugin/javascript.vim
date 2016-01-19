" ftplugin/javascript
"
" Settings for plugins that need to be available before plug loads
"

" matchit
" from https://github.com/romainl/dotvim/blob/efb9257da7b0d1c6e5d9cfb1e7331040fd90b6c1/bundle/lang-javascript/after/ftplugin/javascript.vim#L10
let b:match_words = '\<function\>:\<return\>,'
  \ . '\<do\>:\<while\>,'
  \ . '\<switch\>:\<case\>:\<default\>,'
  \ . '\<if\>:\<else\>,'
  \ . '\<try\>:\<catch\>:\<finally\>'

" ============================================================================
" javascript-libraries-syntax
" ============================================================================
if exists("g:plugs['javascript-libraries-syntax.vim']")
  " the jquery lib causes funky highlighting in selectors
  " e.g. in $('.ad-native-code'); the word native gets highlighted
  "let g:used_javascript_libs = 'jquery,underscore,backbone,chai,handlebars'

  let g:used_javascript_libs = 'underscore'
  let g:used_javascript_libs .= ',backbone'
  let g:used_javascript_libs .= ',chai'
  let g:used_javascript_libs .= ',handlebars'
  let g:used_javascript_libs .= ',jquery'
endif


" ============================================================================
" vim-jsdoc
" ============================================================================
if exists("g:plugs['vim-jsdoc']")
  let g:jsdoc_return = 0

  " @public, @private
  let g:jsdoc_underscore_private = 1
  "let g:jsdoc_access_descriptions = 2

  let g:jsdoc_enable_es6 = 1


  " Add param type when documenting args
  " key is regex to match param name
  " The match is done via matchstr() (so magic mode is on -- escape ?)
  let g:jsdoc_custom_args_regex_only = 1
  let g:jsdoc_custom_args_hook = {
        \   '^\$': {
        \     'type': '{jQuery}'
        \   },
        \   '\(callback\|cb\|done\)$': {
        \     'type': '{Function}',
        \     'description': 'Callback function'
        \   },
        \   'data': {
        \     'type': '{Object}'
        \   },
        \   '\(description\|message\|title\|url\)': {
        \     'type': '{String}'
        \   },
        \   'messages': {
        \     'type': '{String[]}'
        \   },
        \   '^\(e\|evt\|event\)$': {
        \     'type': '{Event}'
        \   },
        \   'el$': {
        \     'type': '{Element}'
        \   },
        \   '\(err\|error\)$': {
        \     'type': '{ErrorEvent}'
        \   },
        \   'handler$': {
        \     'type': '{Function}'
        \   },
        \   'handlers$': {
        \     'type': '{Function[]}'
        \   },
        \   '^i$': {
        \     'type': '{Number}'
        \   },
        \   '^_\?is': {
        \     'type': '{Boolean}'
        \   },
        \   '^on': {
        \     'type': '{Function}'
        \   },
        \   'options$': {
        \     'type': '{Object}'
        \   },
        \   'promise$': {
        \     'type': '{Promise}'
        \   },
        \ }

  " This needs to be recursive map
  nmap <buffer> <silent> <Leader>pd <Plug>(jsdoc)
endif
