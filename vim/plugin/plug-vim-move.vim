" plugin/plug-vim-move.vim

if !dko#IsPlugged('vim-move') | finish | endif

" Use <C-j/k> to bubble
let g:move_key_modifier = 'C'

" Don't reindent after each move
let g:move_auto_indent = 0
