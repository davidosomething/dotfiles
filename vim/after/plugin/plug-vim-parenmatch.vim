" after/plugin/plug-vim-parenmatch.vim

if !dkoplug#IsLoaded('vim-parenmatch') | finish | endif

" Disable resetting the colors on colorscheme change
let g:parenmatch_highlight = 1

" My custom colors
highlight default ParenMatch guibg=#990000 guifg=#FFFFFF gui=undercurl cterm=undercurl
