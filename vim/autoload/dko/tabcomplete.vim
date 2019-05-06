" ============================================================================
" PUM key handling
" ============================================================================

" Select from PUM or insert tabs or alignment spaces
function! s:DKO_Tab() abort
  " Advance and select autocomplete result
  if g:dko_tab_completion && pumvisible()
    return "\<C-n>"
  endif

  " If characters all the way back to start of line were all whitespace,
  " insert whatever expandtab setting is set to do.
  if strpart(getline('.'), 0, col('.') - 1) =~? '^\s*$'
    return "\<Tab>"
  endif

  " The PUM is closed and characters before the cursor are not all whitespace
  " so we need to insert alignment spaces (always spaces)
  " Calc how many spaces, support for negative &sts values
  let l:sts = (&softtabstop <= 0) ? shiftwidth() : &softtabstop
  let l:sp = (virtcol('.') % l:sts)
  if l:sp == 0 | let l:sp = l:sts | endif
  return repeat(' ', 1 + l:sts - l:sp)
endfunction

" S-Tab goes reverses selection or untabs
function! s:DKO_STab() abort
  return g:dko_tab_completion && pumvisible() ? "\<C-p>" : "\<C-d>"
endfunction

function! dko#tabcomplete#Init() abort
  silent! iunmap <Tab>
  silent! iunmap <S-Tab>

  " Tab - requires noremap since it may return a regular <Tab>
  inoremap  <silent><special><expr>  <Tab>     <SID>DKO_Tab()
  imap      <silent><special><expr>  <S-Tab>   <SID>DKO_STab()
endfunction
