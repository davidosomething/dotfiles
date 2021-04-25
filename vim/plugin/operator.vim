" plugin/operator.vim
" vim-operator-user operators

if !dkoplug#Exists('vim-operator-user') | finish | endif

let s:cpo_save = &cpoptions
set cpoptions&vim

silent! unmap gc
silent! unmap gcc
silent! unmap gsc
silent! unmap <Leader>c

" ============================================================================

if dkoplug#Exists('caw.vim')
  " By default works like tcomment_vim (instantly)
  "let g:caw_operator_keymappings = 1

  nmap gc   <Plug>(caw:prefix)
  xmap gc   <Plug>(caw:prefix)

  nmap gcc   <Plug>(caw:hatpos:toggle)
  xmap gcc   <Plug>(caw:hatpos:toggle)

  map <silent> gsc   <Plug>(caw:hatpos:toggle:operator)
endif

if dkoplug#Exists('operator-camelize.vim')
  map <special> <Leader>c <Plug>(operator-camelize-toggle)
endif

" ============================================================================

let &cpoptions = s:cpo_save
unlet s:cpo_save
