" ============================================================================
" Toggle display lines movement mode for normal mode
" ============================================================================

function! g:ToggleMovementMode()
  if !exists('b:movementmode')
    let b:movementmode = 'linewise'
  endif

  if b:movementmode == 'linewise'
    let b:movementmode = 'display'
    nnoremap j gj
    nnoremap k gk
    echo 'Moving by display lines'
  elseif b:movementmode == 'display'
    let b:movementmode = 'linewise'
    silent! nunmap j
    silent! nunmap k
    echo 'Moving by line numbers'
  endif
endfunction

nnoremap <silent> <Leader>t :call g:ToggleMovementMode()<CR>

