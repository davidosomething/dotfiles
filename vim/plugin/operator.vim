" plugin/operator.vim
" vim-operator-user operators

if !dkoplug#plugins#Exists('vim-operator-user') | finish | endif

let s:cpo_save = &cpoptions
set cpoptions&vim

silent! unmap gc
silent! unmap gcc
silent! unmap gsc
silent! unmap gsa
silent! unmap gsd
silent! unmap gsr
silent! unmap <Leader>c

" ============================================================================

if dkoplug#plugins#Exists('caw.vim')
  " By default works like tcomment_vim (instantly)
  "let g:caw_operator_keymappings = 1

  nmap gc   <Plug>(caw:prefix)
  xmap gc   <Plug>(caw:prefix)

  nmap gcc   <Plug>(caw:hatpos:toggle)
  xmap gcc   <Plug>(caw:hatpos:toggle)

  map <silent> gsc   <Plug>(caw:hatpos:toggle:operator)
endif

if dkoplug#plugins#Exists('vim-operator-surround')
  " note: gs is mapped to <NOP> in after/plugin/mappings.vim
  map <silent>  gsa   <Plug>(operator-surround-append)
  map <silent>  gsd   <Plug>(operator-surround-delete)
  map <silent>  gsr   <Plug>(operator-surround-replace)
endif

if dkoplug#plugins#Exists('operator-camelize.vim')
  nmap <special> <Leader>c <Plug>(operator-camelize-toggle)
endif

" ============================================================================

let &cpoptions = s:cpo_save
unlet s:cpo_save
