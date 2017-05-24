" plugin/restoreposition.vim

" ============================================================================
" From vim help docs on last-position-jump
" ============================================================================

" @see {@link http://stackoverflow.com/questions/6496778/vim-run-autocmd-on-all-filetypes-except}
let s:excluded_ft = [ 'gitbranchdescription', 'gitcommit' ]

function! s:RestorePosition() abort
  if index(s:excluded_ft, &filetype) < 0 && line("'\"") > 1 && line("'\"") <= line('$')
    execute "normal! g`\""
  endif
endfunction

augroup dkorestoreposition
  autocmd!
  autocmd BufReadPost * call s:RestorePosition()
augroup END

