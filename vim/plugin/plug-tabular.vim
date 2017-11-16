" plugin/plug-tabular.vim

if !dkoplug#Exists('tabular') | finish | endif

let s:cpo_save = &cpoptions
set cpoptions&vim

xnoremap  <silent><special> <Leader>a"   :Tabularize /"<CR>
xnoremap  <silent><special> <Leader>a&   :Tabularize /&<CR>
xnoremap  <silent><special> <Leader>a-   :Tabularize /-<CR>
xnoremap  <silent><special> <Leader>a=   :Tabularize /=<CR>
xnoremap  <silent><special> <Leader>af   :Tabularize /=>/<CR>
" align the following as `noSpaceBefore: spaceAfter`
xnoremap  <silent><special> <Leader>a:   :Tabularize /:\zs/l0l1<CR>
xnoremap  <silent><special> <Leader>a,   :Tabularize /,\zs/l0l1<CR>

let &cpoptions = s:cpo_save
unlet s:cpo_save
