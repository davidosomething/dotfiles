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

function movemode#setByLine()
  let b:movementmode = 'linewise'
  silent! nunmap <buffer> j
  silent! nunmap <buffer> k
endfunction

function movemode#setByDisplay()
  let b:movementmode = 'display'
  nnoremap <buffer> j gj
  nnoremap <buffer> k gk
endfunction

function! movemode#toggle()
  if !exists('b:movementmode') | let b:movementmode = 'linewise'
  endif
  if b:movementmode     == 'linewise' | call movemode#setByDisplay()
  elseif b:movementmode == 'display'  | call movemode#setByLine()
  endif
endfunction

nnoremap <silent> <Leader>t :call movemode#toggle()<CR>

