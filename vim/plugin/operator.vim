" plugin/operator.vim
"
" vim-operator-user operators
"

if !dko#IsPlugged('vim-operator-user') | finish | endif

let s:cpo_save = &cpoptions
set cpoptions&vim

" ============================================================================

if dko#IsPlugged('vim-operator-surround')
  " unmap just in case
  silent! unmap gsa
  silent! unmap gsd
  silent! unmap gsr

  " note: gs is mapped to <NOP> in after/plugin/mappings.vim
  map <silent>  gsa   <Plug>(operator-surround-append)
  map <silent>  gsd   <Plug>(operator-surround-delete)
  map <silent>  gsr   <Plug>(operator-surround-replace)
endif

if dko#IsPlugged('operator-camelize.vim')
  silent! unmap <Leader>c
  map <special> <Leader>c <Plug>(operator-camelize-toggle)
endif

" ============================================================================

let &cpoptions = s:cpo_save
unlet s:cpo_save
