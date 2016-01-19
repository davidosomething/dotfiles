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
  if strpart(getline('.'), 0, col('.') - 1) =~ '^\s*$'
    return "\<Tab>"
  endif

  " Insert alignment spaces
  " Calc how many spaces, support for negative sts
  let sts = (&sts <= 0) ? &sw : &sts
  let sp = (virtcol('.') % sts)
  if sp == 0 | let sp = sts | endif
  return repeat(' ', 1 + sts - sp)
endfunction


" S-Tab goes reverses selection or untabs
function! s:DKO_STab()
  return pumvisible() ? "\<C-p>" : "\<C-d>"
endfunction


" <Esc> Original behavior is to leave whatever was selected and back to normal
" If PUM open, cancel selection and continue typing in insert mode
function! s:DKO_Esc()
  return pumvisible() ? "\<C-e>\<Esc>" : "\<Esc>"
endfunction


" <CR> Original behavior depends on completion plugin -- see neocomplete docs.
" if completing
"   selected:     Accept, and continue insertion (<S-CR> to actually insert
"                 a new line)
"   not selected: Close popup.
" not completing
"   <CR>
function! s:DKO_CR()
  if pumvisible()
    if exists("g:plugs['neocomplete.vim']")
      return "\<C-y>" . neocomplete#cancel_popup()
    endif
  endif

  return "\<CR>"
endfunction

" ----------------------------------------------------------------------------
" Mappings
" ----------------------------------------------------------------------------

" requires noremap if returns original key
inoremap  <silent><expr>  <Tab>     <SID>DKO_Tab()
imap      <silent><expr>  <S-Tab>   <SID>DKO_STab()
" inoremap  <silent><expr>  <Esc>     <SID>DKO_Esc()
" inoremap  <silent><expr>  <CR>      <SID>DKO_CR()

