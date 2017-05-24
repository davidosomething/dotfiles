" after/plugin/plug-unimpaired.vim

if !dko#IsLoaded('vim-unimpaired') | finish | endif

let s:cpo_save = &cpoptions
set cpoptions&vim

" ============================================================================
" Unimpaired overrides
" ============================================================================

" go to last error instead of bitching
function! s:LocationPrevious() abort
  try
    lprev
  catch /.*/
    silent! llast
  endtry
endfunction
nnoremap  <silent>  <Plug>unimpairedLPrevious
      \ :<C-U>call <SID>LocationPrevious()<CR>

" go to first error instead of bitching
function! s:LocationNext() abort
  try
    lnext
  catch /.*/
    silent! lfirst
  endtry
endfunction
nnoremap  <silent>  <Plug>unimpairedLNext
      \ :<C-U>call <SID>LocationNext()<CR>

" ============================================================================

let &cpoptions = s:cpo_save
unlet s:cpo_save
