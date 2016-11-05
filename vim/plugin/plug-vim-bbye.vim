" plugin/plug-vim-bbye.vim

" Auto close loc list first
" Then close buffer
" Use vim-bbye to preserve window layout if possible
if dko#IsPlugged('vim-bbye')
  nnoremap  <silent><special>  <Leader>x  :<C-U>Bdelete<CR>
else
  nnoremap  <silent><special>  <Leader>x  :<C-U>lclose<CR>:bdelete<CR>
endif

