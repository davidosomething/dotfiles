" plugin/operator.vim

if !exists("g:plugs['vim-operator-user']") | finish | endif

let s:cpo_save = &cpoptions
set cpoptions&vim

if exists("g:plugs['vim-operator-surround']")
  " disable [s]ubstitute
  map   s   <Nop>

  " operators
  map   sa    <Plug>(operator-surround-append)
  map   sd    <Plug>(operator-surround-delete)
  map   sr    <Plug>(operator-surround-replace)

  " commands, not operators
  map   s'    <Plug>(operator-surround-append)iW'
  map   s"    <Plug>(operator-surround-append)iW"
  map   s)    <Plug>(operator-surround-append)iW)
  map   s}    <Plug>(operator-surround-append)iW)
  map   s]    <Plug>(operator-surround-append)iW]
  map   s>    <Plug>(operator-surround-append)iW>

  " accept block char on anyblock
  if exists("g:plugs['vim-textobj-anyblock']")
    nmap  say   <Plug>(operator-surround-append)<Plug>(textobj-anyblock-a)
    nmap  sdy   <Plug>(operator-surround-delete)<Plug>(textobj-anyblock-a)
    nmap  sry   <Plug>(operator-surround-replace)<Plug>(textobj-anyblock-a)
  endif
endif

if exists("g:plugs['operator-camelize.vim']")
  " operators
  map   <unique>  <Leader>c   <Plug>(operator-camelize-toggle)

  " commands, not operators
  map   ccb          <Plug>(operator-camelize-toggle)<Plug>(textobj-anyblock-a)
  map   ccc          <Plug>(operator-camelize-toggle)iWB
endif

let &cpoptions = s:cpo_save
unlet s:cpo_save
