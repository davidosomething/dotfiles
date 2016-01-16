" php

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
        \ expand(g:dko_vim_dir . g:dko_plugdir . '/pdv/templates')

  nnoremap <buffer> <silent> <Leader>pd :call pdv#DocumentCurrentLine()<CR>
endif

