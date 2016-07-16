" after/syntax/zsh.vim

let s:cpo_save = &cpo
set cpo&vim

setlocal foldmethod=manual

let &cpo = s:cpo_save
unlet s:cpo_save
