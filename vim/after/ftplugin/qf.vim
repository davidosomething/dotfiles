" after/ftplugin/qf.vim

let s:cpo_save = &cpoptions
set cpoptions&vim

" ============================================================================

" Don't include quickfix buffers when cycling
setlocal nobuflisted

" Quit with q
nnoremap  <buffer>    Q   q

" Open result in horizontal split window
nnoremap  <buffer>    s   <C-w><CR>

" Open result in verical split window
" https://github.com/romainl/vim-qf/blob/master/after/ftplugin/qf.vim
nnoremap  <buffer><expr>
      \ v
      \ &splitright
      \   ? "\<C-w>\<CR>\<C-w>L\<C-w>p\<C-w>J\<C-w>p"
      \   : "\<C-w>\<CR>\<C-w>H\<C-w>p\<C-w>J\<C-w>p"

" Open result in new tab
nnoremap  <buffer>    t   <C-w><CR><C-w>T

" ============================================================================

let &cpoptions = s:cpo_save
unlet s:cpo_save
