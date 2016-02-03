" ============================================================================
" Toggle display lines movement mode for normal mode
" ============================================================================

function! movemode#setByLine() abort
  let b:movementmode = 'linewise'
  silent! nunmap <buffer> j
  silent! nunmap <buffer> k
endfunction

function! movemode#setByDisplay() abort
  let b:movementmode = 'display'
  nnoremap <buffer> j gj
  nnoremap <buffer> k gk
endfunction

function! movemode#toggle() abort
  if !exists('b:movementmode') | let b:movementmode = 'linewise'
  endif
  if b:movementmode     ==? 'linewise' | call movemode#setByDisplay()
  elseif b:movementmode ==? 'display'  | call movemode#setByLine()
  endif
endfunction

