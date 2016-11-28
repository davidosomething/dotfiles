" plugin/plug-vim-move.vim

if !dko#IsPlugged('vim-move') | finish | endif

" Use <C-j/k> to bubble
let g:move_key_modifier = 'C'
