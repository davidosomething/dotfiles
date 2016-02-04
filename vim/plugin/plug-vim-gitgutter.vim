" plugin/plug-vim-gitgutter.vim

if !exists("g:plugs['vim-gitgutter']") | finish | endif

let g:gitgutter_enabled = 0
nmap <C-g> :GitGutterToggle<CR>

