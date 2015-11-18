" ============================================================================
" WS - Clean up whitespace
" ============================================================================

function! g:CleanCode()
  %retab      " Replace tabs with spaces
  %s/\r/\r/eg " Turn DOS returns ^M into real returns
  %s= *$==e   " Delete end of line blanks
endfunction

nnoremap <Leader>ws :call g:CleanCode()<CR>

