" plugin/plug-pgmnt.vim

if !dkoplug#plugins#IsLoaded('pgmnt.vim') | finish | endif

let s:cpo_save = &cpoptions
set cpoptions&vim

silent! nunmap zs
nnoremap <silent> zs :<C-U>PgmntDevInspect<CR>

let &cpoptions = s:cpo_save
unlet s:cpo_save
