" plugin/operator.vim

if !dko#IsPlugged('vim-operator-user') | finish | endif

let s:cpo_save = &cpoptions
set cpoptions&vim

" ============================================================================

if dko#IsPlugged('vim-operator-surround')
  " disable [s]ubstitute
  map   s   <Nop>

  " operators
  map   sa    <Plug>(operator-surround-append)
  map   sd    <Plug>(operator-surround-delete)
  map   sr    <Plug>(operator-surround-replace)

  " commands, not operators
  nmap   s'    <Plug>(operator-surround-append)iW'
  nmap   s"    <Plug>(operator-surround-append)iW"
  nmap   s)    <Plug>(operator-surround-append)iW)
  nmap   s}    <Plug>(operator-surround-append)iW)
  nmap   s]    <Plug>(operator-surround-append)iW]
  nmap   s>    <Plug>(operator-surround-append)iW>

  " visual mode
  vmap   s'    <Plug>(operator-surround-append)'
  vmap   s"    <Plug>(operator-surround-append)"
  vmap   s)    <Plug>(operator-surround-append))
  vmap   s}    <Plug>(operator-surround-append)}
  vmap   s]    <Plug>(operator-surround-append)]
  vmap   s>    <Plug>(operator-surround-append)>

  " accept block char on anyblock
  if dko#IsPlugged('vim-textobj-anyblock')
    nmap  say   <Plug>(operator-surround-append)<Plug>(textobj-anyblock-a)
    nmap  sdy   <Plug>(operator-surround-delete)<Plug>(textobj-anyblock-a)
    nmap  sry   <Plug>(operator-surround-replace)<Plug>(textobj-anyblock-a)
  endif
endif

if dko#IsPlugged('operator-camelize.vim')
  " operators
  map   <unique>  <Leader>c   <Plug>(operator-camelize-toggle)

  " commands, not operators
  map   ccb   <Plug>(operator-camelize-toggle)<Plug>(textobj-anyblock-a)
  map   ccc   <Plug>(operator-camelize-toggle)iWB
endif

" ============================================================================

let &cpoptions = s:cpo_save
unlet s:cpo_save
