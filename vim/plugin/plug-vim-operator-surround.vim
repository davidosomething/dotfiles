" plugin/plug-vim-operator-surround.vim

if !exists("g:plugs['vim-operator-surround']") | finish | endif

" operator mappings
silent! unmap s
map   <silent>sa    <Plug>(operator-surround-append)
map   <silent>sd    <Plug>(operator-surround-delete)
map   <silent>sr    <Plug>(operator-surround-replace)

" delete or replace most inner surround
if exists("g:plugs['vim-textobj-anyblock']")
  nmap  <silent>saa   <Plug>(operator-surround-append)<Plug>(textobj-anyblock-a)
  nmap  <silent>sdd   <Plug>(operator-surround-delete)<Plug>(textobj-anyblock-a)
  nmap  <silent>srr   <Plug>(operator-surround-replace)<Plug>(textobj-anyblock-a)
endif

