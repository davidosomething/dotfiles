" plugin/plug-tabular.vim
if !dko#IsPlugged('tabular') | finish | endif

let s:cpo_save = &cpoptions
set cpoptions&vim

vnoremap  <special> <Leader>a"   :Tabularize /"<CR>
vnoremap  <special> <Leader>a&   :Tabularize /&<CR>
vnoremap  <special> <Leader>a-   :Tabularize /-<CR>
vnoremap  <special> <Leader>a=   :Tabularize /=<CR>
vnoremap  <special> <Leader>af   :Tabularize /=>/<CR>
" align the following as `noSpaceBefore: spaceAfter`
vnoremap  <special> <Leader>a:   :Tabularize /:\zs/l0l1<CR>
vnoremap  <special> <Leader>a,   :Tabularize /,\zs/l0l1<CR>

let &cpoptions = s:cpo_save
unlet s:cpo_save
