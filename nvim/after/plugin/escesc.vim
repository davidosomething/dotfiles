" after/plugin/escesc.vim
"
" Clear things on <Esc><Esc>

let s:cpo_save = &cpoptions
set cpoptions&vim

silent!   nunmap      <Esc><Esc>

" ============================================================================

function! g:DKOClearUI() abort
  let @/ = ''
  nohlsearch
  redraw!
endfunction

nnoremap <silent><special> <Esc><Esc> :<C-U>call g:DKOClearUI()<CR>
