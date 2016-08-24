" after/ftplugin/php.vim

function! DKO_EditorConfigPhp(config)
  setlocal tabstop=2
  setlocal shiftwidth=2
  setlocal softtabstop=-2
  return 0
endfunction

if exists("g:plugs['editorconfig-vim']")
  call editorconfig#AddNewHook(function('DKO_EditorConfigPhp'))
endif

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

  nnoremap <silent><buffer>
        \ <Leader>pd
        \ O<C-r>=neosnippet#expand('doc')<CR>
endif

