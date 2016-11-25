" plugin/operator.vim
"
" vim-operator-user operators
"

if !dko#IsPlugged('vim-operator-user') | finish | endif

let s:cpo_save = &cpoptions
set cpoptions&vim

" ============================================================================

if dko#IsPlugged('vim-operator-surround')
  map <special> <Leader>sa <Plug>(operator-surround-append)
  map <special> <Leader>sd <Plug>(operator-surround-delete)
  map <special> <Leader>sr <Plug>(operator-surround-replace)
endif

if dko#IsPlugged('operator-camelize.vim')
  map <special> <Leader>c <Plug>(operator-camelize-toggle)
endif

" ============================================================================

let &cpoptions = s:cpo_save
unlet s:cpo_save
