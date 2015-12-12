" ============================================================================
" mode toggling
" ============================================================================

" toggle visual/normal mode
nnoremap <Leader><Leader> V
vnoremap <Leader><Leader> <Esc>

" Back to normal mode
imap jj <Esc>
cmap jj <Esc>

" Toggle paste mode
nnoremap <silent> <F12> :set invpaste<CR>:set paste?<CR>
inoremap <silent> <F12> <ESC>:set invpaste<CR>:set paste?<CR>

" Unfuck my screen
" https://bitbucket.org/sjl/dotfiles/src/2c4aba25376c6c5cb5d4610cf80109d99b610505/vim/vimrc?at=default#cl-444
nnoremap U :syntax sync fromstart<CR>:redraw!<CR>

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
" Search
" ============================================================================

" Don't move on */# (it automatically goes to next match)
" From https://bitbucket.org/sjl/dotfiles/
nnoremap <silent> *
      \ :let stay_star_view = winsaveview()<CR>*:call winrestview(stay_star_view)<CR>

" ============================================================================
" Commands
" ============================================================================
command Q q

" cd to the directory containing the file in the buffer
nnoremap <silent> <Leader>cd :lcd %:h<CR>

" ============================================================================
" Editing
" ============================================================================

" insert date, e.g. 2015-02-19
nnoremap <Leader>d "=strftime("%Y-%m-%d")<CR>P

" insert file dir
inoremap <Leader>fd <C-R>=expand('%:h')<CR>

" insert file name
inoremap <Leader>fn <C-R>=expand('%:t')<CR>

" insert full filepath
inoremap <Leader>fp <C-R>=expand('%:p:h')<CR>

" Sort lines
" https://bitbucket.org/sjl/dotfiles/src/2c4aba25376c6c5cb5d4610cf80109d99b610505/vim/vimrc?at=default#cl-288
nnoremap <Leader>s vip:!sort<CR>
vnoremap <Leader>s :!sort<CR>

" upper/lower word
nnoremap <Leader>u mQviwU`Q
nnoremap <Leader>l mQviwu`Q

" join lines without space
nnoremap <Leader>j VjgJ

" reselect visual block after indent
vnoremap < <gv
vnoremap > >gv

if has('gui_macvim') && has("gui_running")
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

" ============================================================================
" Buffer manip
" ============================================================================

" close buffer with space-bd and auto close loc list first
nnoremap  <Leader>bd :lclose<CR>:bdelete<CR>
cabbrev   <silent>bd lclose\|bdelete

" ============================================================================
" Split manip
" ============================================================================

" Navigate with ctrl+arrow
nnoremap <silent> <C-Left>       :wincmd h<CR>
inoremap <silent> <C-Left>  <Esc>:wincmd h<CR>
nnoremap <silent> <C-Down>       :wincmd j<CR>
inoremap <silent> <C-Down>  <Esc>:wincmd j<CR>
nnoremap <silent> <C-Up>         :wincmd k<CR>
inoremap <silent> <C-Up>    <Esc>:wincmd k<CR>
nnoremap <silent> <C-Right>      :wincmd l<CR>
inoremap <silent> <C-Right> <Esc>:wincmd l<CR>
nmap <A-x> :close<CR>

" Cycle with tab in normal mode
nnoremap <Tab> <C-w>w

" Resize
nnoremap <silent> <S-Left>  4<C-w><
nnoremap <silent> <S-Down>  4<C-W>-
nnoremap <silent> <S-Up>    4<C-W>+
nnoremap <silent> <S-Right> 4<C-w>>
inoremap <silent> <S-Left>  <Esc>4<C-w><
inoremap <silent> <S-Down>  <Esc>4<C-W>-
inoremap <silent> <S-Up>    <Esc>4<C-W>+
inoremap <silent> <S-Right> <Esc>4<C-w>>

