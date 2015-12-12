" ============================================================================
" Scrolling and movement
" ============================================================================

" Map the arrow keys to be based on display lines, not physical lines
vnoremap <Down> gj
vnoremap <Up>   gk

" Replace PgUp and PgDn with Ctrl-U/D
map   <PageUp>    <C-U>
map   <PageDown>  <C-D>
imap  <PageUp>    <C-O><C-U>
imap  <PageDown>  <C-O><C-D>

" Easier to type, and I never use the default behavior.
" From https://bitbucket.org/sjl/dotfiles/
" default is first line on screen
noremap H ^
" default is last line on screen
noremap L $
vnoremap L g_

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

