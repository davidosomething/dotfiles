" plugin/plug-extract.vim

if !dkoplug#IsLoaded('Extract') | finish | endif

let g:extract_maxCount = 20
let g:extract_useDefaultMappings = 0
let g:extract_loadNCM = 1

let s:cpo_save = &cpoptions
set cpoptions&vim

nmap p <Plug>(extract-put)
nmap P <Plug>(extract-Put)
vmap p <Plug>(extract-put)
vmap P <Plug>(extract-Put)
map <c-s> <Plug>(extract-sycle)
map <c-S> <Plug>(extract-Sycle)

let &cpoptions = s:cpo_save
unlet s:cpo_save
