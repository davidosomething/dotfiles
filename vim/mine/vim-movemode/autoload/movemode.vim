" ============================================================================
" Toggle display lines movement mode for normal mode
" ============================================================================

function! movemode#setByLine() abort
  let b:movementmode = 'linewise'
  echo 'Move by real newlines'
  silent! nunmap <buffer> j
  silent! nunmap <buffer> k
endfunction

" Move by display lines unless a count is given
" https://bluz71.github.io/2017/05/15/vim-tips-tricks.html
function! movemode#setByDisplay() abort
  let b:movementmode = 'display'
  echo 'Move by display lines'
  nnoremap <buffer><expr>   j   v:count ? 'j' : 'gj'
  nnoremap <buffer><expr>   k   v:count ? 'k' : 'gk'
endfunction

function! movemode#toggle() abort
  let b:movementmode = get(b:, 'movementmode', 'linewise')
  if b:movementmode     ==? 'linewise' | call movemode#setByDisplay()
  elseif b:movementmode ==? 'display'  | call movemode#setByLine()
  endif
endfunction

