" plugin/plug-unimpaired.vim

if !dko#IsPlugged('vim-unimpaired') | finish | endif

" ============================================================================
" Unimpaired overrides
" ============================================================================

" go to last error instead of bitching
function! s:LocationPrevious()
  try
    lprev
  catch /.*/
    silent! llast
  endtry
endfunction
nnoremap  <silent>  <Plug>unimpairedLPrevious
      \ :<C-U>call <SID>LocationPrevious()<CR>

" go to first error instead of bitching
function! s:LocationNext()
  try
    lnext
  catch /.*/
    silent! lfirst
  endtry
endfunction
nnoremap  <silent>  <Plug>unimpairedLNext
      \ :<C-U>call <SID>LocationNext()<CR>

" ----------------------------------------------------------------------------
" Bubble remaps
" ----------------------------------------------------------------------------

nmap <special> <C-k> <Plug>unimpairedMoveUp
nmap <special> <C-j> <Plug>unimpairedMoveDown
vmap <special> <C-k> <Plug>unimpairedMoveSelectionUp
vmap <special> <C-j> <Plug>unimpairedMoveSelectionDown

