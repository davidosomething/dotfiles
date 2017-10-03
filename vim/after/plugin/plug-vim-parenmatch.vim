" after/plugin/plug-vim-parenmatch.vim

if !dkoplug#plugins#IsLoaded('vim-parenmatch') | finish | endif

" Disable resetting the colors on colorscheme change
let g:parenmatch_highlight = 1

" My custom colors
highlight ParenMatch guibg='#990000' guifg='#FFFFFF' gui='undercurl' cterm='undercurl'
