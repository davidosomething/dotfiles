" ----------------------------------------------------------------------------
" Commands
" ----------------------------------------------------------------------------

command! Q q

" ----------------------------------------------------------------------------
" Allow [[ open,  [] close, back/forward to curly brace in any column
" see :h section
" ----------------------------------------------------------------------------

map [[ ?{<CR>w99[{
map [] k$][%?}<CR>
"map ][ /}<CR>b99]}
"map ]] j0[[%/{<CR>

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
" Toggle paste mode
" ----------------------------------------------------------------------------

nnoremap <silent> <F12> :set invpaste<CR>
inoremap <silent> <F12> <ESC>:set invpaste<CR>

" ----------------------------------------------------------------------------
" Unfuck my screen
" https://bitbucket.org/sjl/dotfiles/src/2c4aba25376c6c5cb5d4610cf80109d99b610505/vim/vimrc?at=default#cl-444
" ----------------------------------------------------------------------------

nnoremap U :syntax sync fromstart<CR>:redraw!<CR>

" ----------------------------------------------------------------------------
" cd to current buffer
" ----------------------------------------------------------------------------

nnoremap <silent> <Leader>cd :lcd %:h<CR>

" ============================================================================
" Editing
" ============================================================================

" ----------------------------------------------------------------------------
" Reselect visual block after indent
" ----------------------------------------------------------------------------

vnoremap < <gv
vnoremap > >gv

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
" Sort selection
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

nnoremap <Leader>ws :call dkowhitespace#clean()<CR>

" ----------------------------------------------------------------------------
" Horizontal rule
" ----------------------------------------------------------------------------

inoremap <Leader>f- <Esc>:call dkorule#char('-')<CR>
inoremap <Leader>f= <Esc>:call dkorule#char('=')<CR>
inoremap <Leader>f# <Esc>:call dkorule#char('#')<CR>
inoremap <Leader>f* <Esc>:call dkorule#char('*')<CR>
nnoremap <Leader>f- :call dkorule#char('-')<CR>
nnoremap <Leader>f= :call dkorule#char('=')<CR>
nnoremap <Leader>f# :call dkorule#char('#')<CR>
nnoremap <Leader>f* :call dkorule#char('*')<CR>

" ----------------------------------------------------------------------------
" Bubble and indent mappings from janus vim distribution
" ----------------------------------------------------------------------------

if has('gui_macvim') && has('gui_running')
  " Map command-[ and command-] to indenting or outdenting
  " while keeping the original selection in visual mode
  vmap <D-]> >gv
  vmap <D-[> <gv

  nmap <D-]> >>
  nmap <D-[> <<

  omap <D-]> >>
  omap <D-[> <<

  imap <D-]> <Esc>>>i
  imap <D-[> <Esc><<i

  " Bubble single lines - REQUIRES tim pope's unimpaired
  nmap <D-Up> [e
  nmap <D-Down> ]e
  nmap <D-k> [e
  nmap <D-j> ]e

  " Bubble multiple lines
  vmap <D-Up> [egv
  vmap <D-Down> ]egv
  vmap <D-k> [egv
  vmap <D-j> ]egv
else
  " Map command-[ and command-] to indenting or outdenting
  " while keeping the original selection in visual mode
  vmap <A-]> >gv
  vmap <A-[> <gv

  nmap <A-]> >>
  nmap <A-[> <<

  omap <A-]> >>
  omap <A-[> <<

  imap <A-]> <Esc>>>i
  imap <A-[> <Esc><<i

  " Bubble single lines - REQUIRES tim pope's unimpaired
  nmap <C-Up> [e
  nmap <C-Down> ]e
  nmap <C-k> [e
  nmap <C-j> ]e

  " Bubble multiple lines
  vmap <C-Up> [egv
  vmap <C-Down> ]egv
  vmap <C-k> [egv
  vmap <C-j> ]egv
endif

