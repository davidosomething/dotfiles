" plugin/plug-vim-smallcaps.vim
if !dko#IsPlugged('vim-smallcaps') | finish | endif

let s:cpo_save = &cpoptions
set cpoptions&vim

vmap <special> <Leader>C <Plug>(dkosmallcaps)

let &cpoptions = s:cpo_save
unlet s:cpo_save
