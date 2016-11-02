" after/ftplugin/qf.vim

let s:cpo_save = &cpoptions
set cpoptions&vim

" ============================================================================

" Don't include quickfix buffers when cycling
setlocal nobuflisted

" Quit with q
nnoremap  <buffer>    Q   q

" Horizontal split
nnoremap  <buffer>    s   <C-w><CR>

" Verical split
" https://github.com/romainl/vim-qf/blob/master/after/ftplugin/qf.vim
nnoremap  <buffer><expr>
      \ v
      \ &splitright
      \   ? "\<C-w>\<CR>\<C-w>L\<C-w>p\<C-w>J\<C-w>p"
      \   : "\<C-w>\<CR>\<C-w>H\<C-w>p\<C-w>J\<C-w>p"

" New tab
nnoremap  <buffer>    t   <C-w><CR><C-w>T

" ============================================================================

let &cpoptions = s:cpo_save
unlet s:cpo_save
