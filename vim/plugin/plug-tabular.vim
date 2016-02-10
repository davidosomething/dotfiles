" plugin/plug-tabular.vim
if !exists("g:plugs['tabular']") | finish | endif

vnoremap <Leader>a"   :Tabularize /"<CR>
vnoremap <Leader>a&   :Tabularize /&<CR>
vnoremap <Leader>a-   :Tabularize /-<CR>
vnoremap <Leader>a=   :Tabularize /=<CR>
vnoremap <Leader>af   :Tabularize /=>/<CR>
" align the following without moving them
vnoremap <leader>a:   :Tabularize /:\zs/l0l1<CR>
vnoremap <leader>a,   :Tabularize /,\zs/l0l1<CR>

