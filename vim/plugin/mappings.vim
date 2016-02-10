" plugin/mappings.vim

" ============================================================================
" Commands
" ============================================================================

command! Q q

" ============================================================================
" Buffer manip
" ============================================================================

" Prev buffer with <BS> in normal
nnoremap  <special> <BS> <C-^>

" close buffer with space-bd and auto close loc list first
nnoremap  <silent>  <Leader>bd :lclose<CR>:bdelete<CR>

" ============================================================================
" Split manip
" ============================================================================

" Navigate with ctrl+arrow
nnoremap <special> <C-Left>       :<C-u>wincmd h<CR>
inoremap <special> <C-Left>  <Esc>:<C-u>wincmd h<CR>
nnoremap <special> <C-Down>       :<C-u>wincmd j<CR>
inoremap <special> <C-Down>  <Esc>:<C-u>wincmd j<CR>
nnoremap <special> <C-Up>         :<C-u>wincmd k<CR>
inoremap <special> <C-Up>    <Esc>:<C-u>wincmd k<CR>
nnoremap <special> <C-Right>      :<C-u>wincmd l<CR>
inoremap <special> <C-Right> <Esc>:<C-u>wincmd l<CR>

" Cycle with tab in normal mode
nnoremap <special><Tab> <C-w>w

" Resize
nnoremap <special> <S-Left>  4<C-w><
nnoremap <special> <S-Down>  4<C-W>-
nnoremap <special> <S-Up>    4<C-W>+
nnoremap <special> <S-Right> 4<C-w>>
inoremap <special> <S-Left>  <Esc>4<C-w><
inoremap <special> <S-Down>  <Esc>4<C-W>-
inoremap <special> <S-Up>    <Esc>4<C-W>+
inoremap <special> <S-Right> <Esc>4<C-w>>

" ============================================================================
" Scrolling and movement
" ============================================================================

" Map the arrow keys to be based on display lines, not physical lines
vnoremap  <special>   <Down>      gj
vnoremap  <special>   <Up>        gk
nnoremap  <special>   <Leader>mm  :<C-u>call dkomovemode#toggle()<CR>

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

nnoremap <Leader>cd :<C-u>lcd %:h<CR>

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
  nnoremap <Leader>s vii:!sort<CR>
else
  " Auto select paragraph (bounded by blank lines) and sort
  nnoremap <Leader>s vip:!sort<CR>
endif
" Sort selection (no clear since in visual)
vnoremap <Leader>s :!sort<CR>

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

nnoremap <Leader>ws :<C-u>call dkowhitespace#clean()<CR>

" ----------------------------------------------------------------------------
" Horizontal rule
" ----------------------------------------------------------------------------

inoremap <Leader>f- <Esc>:<C-u>call dkorule#char('-')<CR>
inoremap <Leader>f= <Esc>:<C-u>call dkorule#char('=')<CR>
inoremap <Leader>f# <Esc>:<C-u>call dkorule#char('#')<CR>
inoremap <Leader>f* <Esc>:<C-u>call dkorule#char('*')<CR>
nnoremap <Leader>f- :<C-u>call dkorule#char('-')<CR>
nnoremap <Leader>f= :<C-u>call dkorule#char('=')<CR>
nnoremap <Leader>f# :<C-u>call dkorule#char('#')<CR>
nnoremap <Leader>f* :<C-u>call dkorule#char('*')<CR>

" ----------------------------------------------------------------------------
" Bubble and indent mappings  - REQUIRES tim pope's unimpaired
" ----------------------------------------------------------------------------

" Bubble single lines
nmap <special> <C-k> [e
nmap <special> <C-j> ]e

" Bubble multiple lines
vmap <special> <C-k> [egv
vmap <special> <C-j> ]egv

