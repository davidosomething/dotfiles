" ============================================================================
" DKO project plugin
" ============================================================================

augroup dkoproject
  autocmd!
  autocmd BufNew,BufEnter * call dkoproject#GetProjectRoot()
augroup END

