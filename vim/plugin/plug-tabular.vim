" plugin/plug-tabular.vim
if !exists("g:plugs['tabular']") | finish | endif

let s:cpo_save = &cpoptions
set cpoptions&vim

vnoremap  <Leader>a"   :Tabularize /"<CR>
vnoremap  <Leader>a&   :Tabularize /&<CR>
vnoremap  <Leader>a-   :Tabularize /-<CR>
vnoremap  <Leader>a=   :Tabularize /=<CR>
vnoremap  <Leader>af   :Tabularize /=>/<CR>
" align the following as `noSpaceBefore: spaceAfter`
vnoremap  <Leader>a:   :Tabularize /:\zs/l0l1<CR>
vnoremap  <Leader>a,   :Tabularize /,\zs/l0l1<CR>

let &cpoptions = s:cpo_save
unlet s:cpo_save
