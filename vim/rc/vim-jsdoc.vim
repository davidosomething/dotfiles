let g:jsdoc_return = 0

" @public, @private
let g:jsdoc_underscore_private = 1
"let g:jsdoc_access_descriptions = 2

let g:jsdoc_enable_es6 = 1

" This needs to be recursive map
autocmd vimrc FileType javascript
      \ nmap <buffer> <silent> <Leader>pd <Plug>(jsdoc)

