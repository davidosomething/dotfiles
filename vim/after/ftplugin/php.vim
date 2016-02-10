" after/ftplugin/php.vim

" ============================================================================
" StanAngeloff/php.vim
" ============================================================================
if exists("g:plugs['php.vim']")
  " Syntax highlighting in phpdoc blocks
  function! g:PhpSyntaxOverride()
    hi! def link phpDocTags  phpDefine
    hi! def link phpDocParam phpType
  endfunction
  call g:PhpSyntaxOverride()
endif

" ============================================================================
" pdv.vim
" ============================================================================
if exists("g:plugs['pdv']")
  let g:pdv_template_dir =
        \ expand(g:dko_plug_absdir . '/pdv/templates')

  nnoremap <silent><buffer> <Leader>pd :<C-u>call pdv#DocumentCurrentLine()<CR>
endif

