" php

" ============================================================================
" PHP-Indenting-for-VIm.vim
" ============================================================================
if exists("g:plugs['PHP-Indenting-for-VIm']")
  " The plugin expects this var to be set before it loads and doesn't read it
  " again afterwards, so we update it again for the buffer
  let b:PHP_outdentphpescape = 0
endif

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
" phpcomplete.vim
" ============================================================================
if exists("g:plugs['phpcomplete.vim']")
  let g:phpcomplete_parse_docblock_comments = 1
endif

" ============================================================================
" pdv.vim
" ============================================================================
if exists("g:plugs['pdv']")
  let g:pdv_template_dir =
        \ expand(g:dko_vim_dir . g:dko_plugdir . '/pdv/templates')

  nnoremap <buffer> <silent> <Leader>pd :call pdv#DocumentCurrentLine()<CR>
endif

