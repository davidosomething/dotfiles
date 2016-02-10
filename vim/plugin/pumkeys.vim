" plugin/pumkeys.vim

" ============================================================================
" PUM key handling
" ============================================================================

" Select from PUM or insert tabs or alignment spaces
function! s:DKO_Tab()
  " Advance and select autocomplete result
  if pumvisible()
    return "\<C-n>"
  endif

  " If characters all the way back to start of line were all whitespace,
  " insert whatever expandtab setting is set to do.
  if strpart(getline('.'), 0, col('.') - 1) =~? '^\s*$'
    return "\<Tab>"
  endif

  " Insert alignment spaces
  " Calc how many spaces, support for negative sts
  let l:sts = (&sts <= 0) ? &sw : &sts
  let l:sp = (virtcol('.') % l:sts)
  if l:sp == 0 | let l:sp = l:sts | endif
  return repeat(' ', 1 + l:sts - l:sp)
endfunction


" S-Tab goes reverses selection or untabs
function! s:DKO_STab()
  return pumvisible() ? "\<C-p>" : "\<C-d>"
endfunction

" ----------------------------------------------------------------------------
" Mappings
" ----------------------------------------------------------------------------

" requires noremap if returns original key
inoremap  <silent><special><expr>  <Tab>     <SID>DKO_Tab()
imap      <silent><special><expr>  <S-Tab>   <SID>DKO_STab()

