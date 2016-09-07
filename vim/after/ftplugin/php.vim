" after/ftplugin/php.vim

" ============================================================================
" Unmap terrible mappings from $VIMRUNTIME/ftplugin/php.vim
" ============================================================================

nunmap <buffer> [[
nunmap <buffer> ]]
ounmap <buffer> [[
ounmap <buffer> ]]

" Remap them with my own
let s:matches = '\(<?php\|function\ \|class\ \|interface\ \)'
execute 'nmap <silent><buffer> [[ ?' . escape(s:matches, '|?') . '<CR>'
execute 'omap <silent><buffer> [[ ?' . escape(s:matches, '|?') . '<CR>'
execute 'nmap <silent><buffer> ]] /' . escape(s:matches, '|') . '<CR>'
execute 'omap <silent><buffer> ]] /' . escape(s:matches, '|') . '<CR>'

" ============================================================================
" EditorConfig overrides
" ============================================================================

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

