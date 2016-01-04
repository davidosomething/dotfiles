" ============================================================================
" Mode toggling
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
" Commands
" ============================================================================
command! Q q

" cd to the directory containing the file in the buffer
nnoremap <silent> <Leader>cd :lcd %:h<CR>

" ============================================================================
" Search
" ============================================================================

" Don't move on */# (it automatically goes to next match)
" From https://bitbucket.org/sjl/dotfiles/
nnoremap <silent> *
      \ :let stay_star_view = winsaveview()<CR>*:call winrestview(stay_star_view)<CR>

" ============================================================================
" Editing
" ============================================================================

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

