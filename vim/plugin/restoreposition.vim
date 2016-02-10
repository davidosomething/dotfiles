" plugin/restoreposition.vim

" ============================================================================
" From vim help docs on last-position-jump
" ============================================================================

" http://stackoverflow.com/questions/6496778/vim-run-autocmd-on-all-filetypes-except
let s:excluded_ft = ['gitcommit']

function! s:RestorePosition()
  if index(s:excluded_ft, &ft) < 0 && line("'\"") > 1 && line("'\"") <= line('$')
    execute "normal! g`\""
  endif
endfunction

augroup dkorestoreposition
  autocmd!
  autocmd BufReadPost * call s:RestorePosition()
augroup END

