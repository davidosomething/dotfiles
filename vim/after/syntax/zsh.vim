" after/syntax/zsh.vim

let s:cpo_save = &cpoptions
set cpoptions&vim

setlocal foldmethod=manual

let &cpoptions = s:cpo_save
unlet s:cpo_save
