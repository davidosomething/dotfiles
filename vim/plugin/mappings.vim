" ============================================================================
" Commands
" ============================================================================

command! Q q

" ============================================================================
" Scrolling and movement
" ============================================================================

" Map the arrow keys to be based on display lines, not physical lines
vnoremap <Down> gj
vnoremap <Up>   gk

" Replace PgUp and PgDn with Ctrl-U/D
map   <special> <PageUp>    <C-U>
map   <special> <PageDown>  <C-D>
imap  <special> <PageUp>    <C-O><C-U>
imap  <special> <PageDown>  <C-O><C-D>

" Easier to type, and I never use the default behavior.
" From https://bitbucket.org/sjl/dotfiles/
" default is first line on screen
noremap   H   ^
" default is last line on screen
noremap   L   $
vnoremap  L   g_

nnoremap <silent><special> <Leader>t :<C-u>call dkomovemode#toggle()<CR>

" ============================================================================
" Mode and env
" ============================================================================

" ----------------------------------------------------------------------------
" Toggle visual/normal mode with space-space
" ----------------------------------------------------------------------------

nnoremap <Leader><Leader> V
vnoremap <Leader><Leader> <Esc>

" ----------------------------------------------------------------------------
" Back to normal mode
" ----------------------------------------------------------------------------

imap jj <Esc>
cmap jj <Esc>

" ----------------------------------------------------------------------------
" Unfuck my screen
" https://bitbucket.org/sjl/dotfiles/src/2c4aba25376c6c5cb5d4610cf80109d99b610505/vim/vimrc?at=default#cl-444
" ----------------------------------------------------------------------------

nnoremap U :<C-u>syntax sync fromstart<CR>:redraw!<CR>

" ----------------------------------------------------------------------------
" cd to current buffer
" ----------------------------------------------------------------------------

nnoremap <silent> <Leader>cd :<C-u>lcd %:h<CR>

" ============================================================================
" Editing
" ============================================================================

" ----------------------------------------------------------------------------
" Allow [[ open,  [] close, back/forward to curly brace in any column
" see :h section
" ----------------------------------------------------------------------------

map     [[  ?{<CR>w99[{
map     []  k$][%?}<CR>
"map    ][  /}<CR>b99]}
"map    ]]  j0[[%/{<CR>

" ----------------------------------------------------------------------------
" Reselect visual block after indent
" ----------------------------------------------------------------------------

vnoremap  <   <gv
vnoremap  >   >gv

" ----------------------------------------------------------------------------
" Sort lines
" https://bitbucket.org/sjl/dotfiles/src/2c4aba25376c6c5cb5d4610cf80109d99b610505/vim/vimrc?at=default#cl-288
" ----------------------------------------------------------------------------

if exists("g:plugs['vim-textobj-indent']")
  " Auto select indent-level and sort
  nnoremap <special> <Leader>s vii:!sort<CR>
else
  " Auto select paragraph (bounded by blank lines) and sort
  nnoremap <special> <Leader>s vip:!sort<CR>
endif
" Sort selection (no clear since in visual)
vnoremap <special> <Leader>s :!sort<CR>

" ----------------------------------------------------------------------------
" Uppercase / lowercase word
" ----------------------------------------------------------------------------

nnoremap <Leader>u mQviwU`Q
nnoremap <Leader>l mQviwu`Q

" ----------------------------------------------------------------------------
" Join lines without space
" ----------------------------------------------------------------------------

nnoremap <Leader>j VjgJ

" ----------------------------------------------------------------------------
" Clean up whitespace
" ----------------------------------------------------------------------------

nnoremap <special> <Leader>ws :<C-u>call dkowhitespace#clean()<CR>

" ----------------------------------------------------------------------------
" Horizontal rule
" ----------------------------------------------------------------------------

inoremap <special> <Leader>f- <Esc>:<C-u>call dkorule#char('-')<CR>
inoremap <special> <Leader>f= <Esc>:<C-u>call dkorule#char('=')<CR>
inoremap <special> <Leader>f# <Esc>:<C-u>call dkorule#char('#')<CR>
inoremap <special> <Leader>f* <Esc>:<C-u>call dkorule#char('*')<CR>
nnoremap <special> <Leader>f- :<C-u>call dkorule#char('-')<CR>
nnoremap <special> <Leader>f= :<C-u>call dkorule#char('=')<CR>
nnoremap <special> <Leader>f# :<C-u>call dkorule#char('#')<CR>
nnoremap <special> <Leader>f* :<C-u>call dkorule#char('*')<CR>

" ----------------------------------------------------------------------------
" Bubble and indent mappings  - REQUIRES tim pope's unimpaired
" ----------------------------------------------------------------------------

" Bubble single lines
nmap <C-k> [e
nmap <C-j> ]e

" Bubble multiple lines
vmap <C-k> [egv
vmap <C-j> ]egv

