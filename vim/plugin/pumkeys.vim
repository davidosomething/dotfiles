" plugin/pumkeys.vim
if exists('g:loaded_dko_pumkeys') | finish | endif
let g:loaded_dko_pumkeys = 1

let s:cpo_save = &cpoptions
set cpoptions&vim

" ============================================================================
" PUM key handling
" ============================================================================

" Select from PUM or insert tabs or alignment spaces
function! s:DKO_Tab() abort
  " Advance and select autocomplete result
  if pumvisible()
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
  let l:sts = (&softtabstop <= 0) ? &shiftwidth : &softtabstop
  let l:sp = (virtcol('.') % l:sts)
  if l:sp == 0 | let l:sp = l:sts | endif
  return repeat(' ', 1 + l:sts - l:sp)
endfunction

" S-Tab goes reverses selection or untabs
function! s:DKO_STab() abort
  return pumvisible() ? "\<C-p>" : "\<C-d>"
endfunction

" ----------------------------------------------------------------------------
" Mappings
" ----------------------------------------------------------------------------

" Tab - requires noremap since it may return a regular <Tab>
inoremap  <silent><special><expr>  <Tab>     <SID>DKO_Tab()

" Shift-Tab
silent!   iunmap  <S-Tab>
imap      <silent><special><expr>  <S-Tab>   <SID>DKO_STab()

" ============================================================================

let &cpoptions = s:cpo_save
unlet s:cpo_save
