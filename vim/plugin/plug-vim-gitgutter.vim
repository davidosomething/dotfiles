" plugin/plug-vim-gitgutter.vim
scriptencoding utf-8

if !dko#IsPlugged('vim-gitgutter') | finish | endif

let s:cpo_save = &cpoptions
set cpoptions&vim

" off until toggled on
let g:gitgutter_enabled = 0

let g:gitgutter_sign_modified = 'Δ'

nmap <silent><special> <C-g> :<C-U>GitGutterToggle<CR>

let &cpoptions = s:cpo_save
unlet s:cpo_save
