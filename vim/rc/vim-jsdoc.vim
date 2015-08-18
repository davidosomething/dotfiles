let g:jsdoc_default_mapping = 0
let g:jsdoc_underscore_private = 1
autocmd vimrc FileType javascript nnoremap <Leader>pd :JsDoc<CR>
autocmd vimrc FileType javascript vnoremap <Leader>pd :JsDoc<CR>
