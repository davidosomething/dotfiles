" after/ftplugin/qf.vim

if exists('b:did_after_ftplugin') | finish | endif

let s:cpo_save = &cpoptions
set cpoptions&vim

" ============================================================================

" Don't include quickfix buffers when cycling
setlocal nobuflisted

" Quit with q
nnoremap  <buffer>    Q   q

" ----------------------------------------------------------------------------
" These are mappings from vim-qf, but I don't want to turn on ALL of the
" qf_mapping_ack_style settings
" ----------------------------------------------------------------------------

" Open result in horizontal split window
nnoremap  <buffer>    s   <C-w><CR>

" Open result in verical split window
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
