" plugin/plug-vim-gitgutter.vim
scriptencoding utf-8
if !exists("g:plugs['vim-gitgutter']") | finish | endif

" off until toggled on
let g:gitgutter_enabled = 0

let g:gitgutter_sign_modified = 'Δ'

nmap <special> <C-g> :<C-u>GitGutterToggle<CR>

