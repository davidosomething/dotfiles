" ============================================================================
" Special keys in PUM
" ============================================================================

" This does the work of IndentTab#SuperTabIntegration#GetExpr() with the other
" plugins in consideration
" Tab advances selection or inserts tab
function! s:DKO_NextFieldOrTab()
  " Advance and select autocomplete result
  if pumvisible()
    return "\<C-n>"

  " Insert a real tab using IndentTab
  elseif exists('g:plugs["IndentTab"]')
    return IndentTab#Tab()

  endif

  " Insert a real tab -- only if there's no IndentTab
  return "\<Tab>"
endfunction
" IndentTab requires noremap!
inoremap  <silent><expr>  <Tab>     <SID>DKO_NextFieldOrTab()

" S-Tab goes reverses selection or untabs
function! s:DKO_ReverseOrUntab()
  return pumvisible() ? "\<C-p>" : "\<C-d>"
endfunction
imap      <silent><expr>  <S-Tab>   <SID>DKO_ReverseOrUntab()

" CR accepts selection AND enter a real <CR>
function! s:DKO_AcceptAndCr()
  return pumvisible() ? "\<C-y>\<CR>" : "\<CR>"
endfunction

" https://github.com/Shougo/neocomplete.vim/blob/master/doc/neocomplete.txt#L1559
inoremap  <silent><expr>  <CR>      <SID>DKO_AcceptAndCr()

