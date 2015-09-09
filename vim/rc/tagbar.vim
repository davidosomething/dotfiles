let g:tagbar_autoclose = 1            " close after jumping
let g:tagbar_autofocus = 1
let g:tagbar_compact = 1
let g:tagbar_show_linenumbers = 1     " Show absolute line numbers

nnoremap <silent><F10> :TagbarToggle<CR>
inoremap <silent><F10> <Esc>:TagbarToggle<CR>
vnoremap <silent><F10> <Esc>:TagbarToggle<CR>
