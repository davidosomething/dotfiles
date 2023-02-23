" ============================================================================
" Git helpers
" ============================================================================

" Get git root
"
" @param {string} [path] to run in
" @return {string} git root
function! dko#git#GetRoot(...) abort
  let l:path = a:0 && type(a:1) == type('') ? a:1 : ''
  let l:cmd = 'git rev-parse --show-toplevel 2>/dev/null'
  let l:result = split(
        \ ( empty(l:path)
        \   ? system(l:cmd)
        \   : system('cd -- "' . l:path . '" && ' . l:cmd)
        \ ), '\n')
  if v:shell_error | return '' | endif
  return len(l:result) ? l:result[0] : ''
endfunction
