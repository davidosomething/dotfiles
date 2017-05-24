" plugin/plug-vim-bbye.vim

let s:cpo_save = &cpoptions
set cpoptions&vim

" Auto close loc list first
" Then close buffer
" Use vim-bbye to preserve window layout if possible
if dko#IsLoaded('vim-bbye')
  nnoremap  <silent><special>  <Leader>x  :<C-U>Bdelete<CR>
else
  nnoremap  <silent><special>  <Leader>x  :<C-U>lclose<CR>:bdelete<CR>
endif

let &cpoptions = s:cpo_save
unlet s:cpo_save
