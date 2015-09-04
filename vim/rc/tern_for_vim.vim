autocmd vimrc FileType coffee,javascript,typescript call tern#Enable()
autocmd vimrc FileType coffee,javascript,typescript setlocal omnifunc=tern#Complete

" tern config
let g:tern_show_argument_hints = 'on_hold'
let g:tern_show_signature_in_pum = 1

" neocomplete tern integration ===============================================
" safer here since it is dependent on tern instead of neocomplete

" neocomplete variable definition --------------------------------------------
if !exists('g:neocomplete#sources#omni#functions')
  let g:neocomplete#sources#omni#functions = {}
endif

if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif

" JavaScript -----------------------------------------------------------------
let g:neocomplete#sources#omni#functions.javascript = 'tern#Complete'
let g:neocomplete#sources#omni#input_patterns.javascript = '\h\w*\|[^. \t]\.\w*'

" CoffeeScript ---------------------------------------------------------------
let g:neocomplete#sources#omni#functions.coffee = 'tern#Complete'
let g:neocomplete#sources#omni#input_patterns.coffee = '\h\w*\|[^. \t]\.\w*'

" TypeScript -----------------------------------------------------------------
let g:neocomplete#sources#omni#functions.typescript = 'tern#Complete'

