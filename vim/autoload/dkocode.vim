" ============================================================================
" Code parsing
" ============================================================================

" @param {String} [1] cursor position to look, defaults to current cursorline
" @return {String}
function! dkocode#GetFunctionInfo() abort

  " --------------------------------------------------------------------------
  " By current-func-info.vim
  " --------------------------------------------------------------------------

  if dko#IsLoaded('current-func-info.vim')
    return {
          \   'name':   cfi#get_func_name(),
          \   'source': 'cfi',
          \ }
  endif

  " --------------------------------------------------------------------------
  " By VimL
  " --------------------------------------------------------------------------

  "let l:position = get(a:, 1, getline('.')[:col('.')-2])
  let l:position = getline('.')
  let l:matches = matchlist(l:position, '\(()\s[a-zA-Z0-9_]*\)([^()]*$')
  if empty(l:matches) || empty(l:matches[1])
    return {}
  endif
  return {
        \   'name':   l:matches[1],
        \   'source': 'viml',
        \ }

endfunction

