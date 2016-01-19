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
noremap   H   ^
" default is last line on screen
noremap   L   $
vnoremap  L   g_

nnoremap <silent> <Leader>t :call movemode#toggle()<CR>

