" after/ftplugin/php.vim

" ============================================================================
" StanAngeloff/php.vim
" ============================================================================
if exists("g:plugs['php.vim']")
  " Syntax highlighting in phpdoc blocks
  hi! def link phpDocTags  phpDefine
  hi! def link phpDocParam phpType
endif

" ============================================================================
" Insert phpdoc block
" ============================================================================
if exists("g:plugs['neosnippet']")

  inoremap <silent><buffer>
        \ <Leader>pd
        \ a<C-r>=neosnippet#expand('doc')<CR>

  nnoremap <silent><buffer><expr>
        \ <Leader>pd
        \ neosnippet#expand('doc')

endif

