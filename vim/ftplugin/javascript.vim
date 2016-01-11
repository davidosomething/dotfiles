" javascript

" ============================================================================
" javascript-libraries-syntax
" ============================================================================
if exists("g:plugs['javascript-libraries-syntax.vim']")
  " the jquery lib causes funky highlighting in selectors
  " e.g. in $('.ad-native-code'); the word native gets highlighted
  "let g:used_javascript_libs = 'jquery,underscore,backbone,chai,handlebars'

  let g:used_javascript_libs = 'underscore,backbone,chai,handlebars'
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
        \   'callback|cb|done': {
        \     'type': '{Function}',
        \     'description': 'Callback function'
        \   },
        \   'data': {
        \     'type': '{Object}'
        \   },
        \   'description|message|title|url': {
        \     'type': '{String}'
        \   },
        \   '^e$': {
        \     'type': '{Event}'
        \   },
        \   'el$': {
        \     'type': '{Element}'
        \   },
        \   'err$': {
        \     'type': '{ErrorEvent}'
        \   },
        \   'handler$': {
        \     'type': '{Function}'
        \   },
        \   '^i$': {
        \     'type': '{Number}'
        \   },
        \   '^_\?is': {
        \     'type': '{Boolean}'
        \   },
        \   'options$': {
        \     'type': '{Object}'
        \   },
        \ }

  " This needs to be recursive map
  nmap <buffer> <silent> <Leader>pd <Plug>(jsdoc)
endif
