" ============================================================================
" PUM key handling
" ============================================================================

" Select from PUM or insert tabs or alignment spaces
function! s:DKO_NextFieldOrTab()
  " Advance and select autocomplete result
  if pumvisible()
    return "\<C-n>"
  endif

  " If characters all the way back to start of line were all whitespace,
  " insert whatever expandtab setting is set to do.
  if strpart(getline('.'), 0, col('.') - 1) =~ '^\s*$'
    return "\<Tab>"
  endif

  " Insert alignment spaces
  " Calc how many spaces, support for negative sts
  let sts = (&sts <= 0) ? &sw : &sts
  let sp = (virtcol('.') % sts)
  if sp == 0 | let sp = sts | endif
  return strpart("                  ", 0, 1 + sts - sp)
endfunction


" S-Tab goes reverses selection or untabs
function! s:DKO_ReverseOrUntab()
  return pumvisible() ? "\<C-p>" : "\<C-d>"
endfunction


" <CR> accepts selection AND enter a real <CR>
" https://github.com/Shougo/neocomplete.vim/blob/master/doc/neocomplete.txt#L1559
function! s:DKO_AcceptAndCr()
  return pumvisible() ? "\<C-y>\<CR>" : "\<CR>"
endfunction


" <Esc> Original behavior is to leave whatever was selected and back to normal
" This changes it to cancel selection and goes to normal mode
function! s:DKO_RejectOrEsc()
  return pumvisible() ? "\<C-e>\<Esc>" : "\<Esc>"
endfunction

" ----------------------------------------------------------------------------
" Mappings
" ----------------------------------------------------------------------------

" requires noremap if returns original key
inoremap  <silent><expr>  <Tab>     <SID>DKO_NextFieldOrTab()
imap      <silent><expr>  <S-Tab>   <SID>DKO_ReverseOrUntab()
inoremap  <silent><expr>  <CR>      <SID>DKO_AcceptAndCr()
inoremap  <silent><expr>  <Esc>     <SID>DKO_RejectOrEsc()

