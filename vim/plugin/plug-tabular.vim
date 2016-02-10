" plugin/plug-tabular.vim
if !exists("g:plugs['tabular']") | finish | endif

let s:cpo_save = &cpoptions
set cpoptions&vim

vnoremap  <unique>  <Leader>a"   :Tabularize /"<CR>
vnoremap  <unique>  <Leader>a&   :Tabularize /&<CR>
vnoremap  <unique>  <Leader>a-   :Tabularize /-<CR>
vnoremap  <unique>  <Leader>a=   :Tabularize /=<CR>
vnoremap  <unique>  <Leader>af   :Tabularize /=>/<CR>
" align the following without moving them
vnoremap  <unique>  <leader>a:   :Tabularize /:\zs/l0l1<CR>
vnoremap  <unique>  <leader>a,   :Tabularize /,\zs/l0l1<CR>

let &cpoptions = s:cpo_save
unlet s:cpo_save
