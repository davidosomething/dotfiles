" ============================================================================
" javascript-libraries-syntax
" ============================================================================

" the jquery lib causes funky highlighting in selectors
" e.g. in $('.ad-native-code'); the word native gets highlighted
"let g:used_javascript_libs = 'jquery,underscore,backbone,chai,handlebars'

let g:used_javascript_libs = 'underscore,backbone,chai,handlebars'

" ============================================================================
" vim-jsdoc
" ============================================================================

let g:jsdoc_return = 0

" @public, @private
let g:jsdoc_underscore_private = 1
"let g:jsdoc_access_descriptions = 2

let g:jsdoc_enable_es6 = 1

" This needs to be recursive map
autocmd vimrc FileType javascript
      \ nmap <buffer> <silent> <Leader>pd <Plug>(jsdoc)

