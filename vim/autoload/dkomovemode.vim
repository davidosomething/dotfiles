" ============================================================================
" Toggle display lines movement mode for normal mode
" ============================================================================

function! dkomovemode#setByLine() abort
  let b:movementmode = 'linewise'
  silent! nunmap <buffer> j
  silent! nunmap <buffer> k
endfunction

function! dkomovemode#setByDisplay() abort
  let b:movementmode = 'display'
  nnoremap <buffer> j gj
  nnoremap <buffer> k gk
endfunction

function! dkomovemode#toggle() abort
  let b:movementmode = get(b:, 'movementmode', 'linewise')
  if b:movementmode     ==? 'linewise' | call dkomovemode#setByDisplay()
  elseif b:movementmode ==? 'display'  | call dkomovemode#setByLine()
  endif
endfunction

