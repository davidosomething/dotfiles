" ============================================================================
" From vim help docs on last-position-jump
" ============================================================================

augroup restoreposition
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$")
        \| execute "normal! g`\""
        \| endif
augroup END

