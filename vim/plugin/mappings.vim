" Disable vim help
inoremap <F1> <nop>
nnoremap <F1> <nop>

" mode toggling ----------------------------------------------------------------
" visual line mode with space space
nmap <Leader><Leader> V

imap jj <Esc>
cmap jj <Esc>

" Toggle paste mode
nnoremap <silent> <F12> :set invpaste<CR>:set paste?<CR>
inoremap <silent> <F12> <ESC>:set invpaste<CR>:set paste?<CR>

" Unfuck my screen
" https://bitbucket.org/sjl/dotfiles/src/2c4aba25376c6c5cb5d4610cf80109d99b610505/vim/vimrc?at=default#cl-444
nnoremap U :syntax sync fromstart<CR>:redraw!<CR>

" Scrolling and movement -------------------------------------------------------

" Toggle display lines movement mode for normal mode
let b:movementmode = "linewise"
function! ToggleMovementMode()
  if exists("b:movementmode") && b:movementmode == "linewise"
    let b:movementmode = "display"
    nnoremap j gj
    nnoremap k gk
    echo 'Moving by display lines'
  elseif exists("b:movementmode") && b:movementmode == "display"
    let b:movementmode = "linewise"
    silent! nunmap j
    silent! nunmap k
    echo 'Moving by line numbers'
  endif
endfunction
nnoremap <silent> <F11> :call ToggleMovementMode()<CR>
inoremap <silent> <F11> <ESC>:call ToggleMovementMode()<CR>

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
noremap H ^
noremap L $
vnoremap L g_

" Keep search pattern at the center of the screen.
" http://vimbits.com/bits/92
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz
nnoremap <silent> g# g#zz

" Don't move on *
" From https://bitbucket.org/sjl/dotfiles/
nnoremap <silent> * :let stay_star_view = winsaveview()<CR>*:call winrestview(stay_star_view)<CR>

" Commands ---------------------------------------------------------------------
" Remap :W to :w
command W w
command Q q

" cd to the directory containing the file in the buffer
nnoremap <silent> <Leader>cd :lcd %:h<CR>

" Editing ----------------------------------------------------------------------
" insert date, e.g. 2015-02-19
nnoremap <Leader>d "=strftime("%Y-%m-%d")<CR>P

" Sort lines
" https://bitbucket.org/sjl/dotfiles/src/2c4aba25376c6c5cb5d4610cf80109d99b610505/vim/vimrc?at=default#cl-288
nnoremap <Leader>s vip:!sort<CR>
vnoremap <Leader>s :!sort<CR>

" upper/lower word
nnoremap <Leader>u mQviwU`Q
nnoremap <Leader>l mQviwu`Q

" join lines without space
nnoremap <Leader>j VjgJ

" Clean code function
function! CleanCode()
  %retab      " Replace tabs with spaces
  %s/\r/\r/eg " Turn DOS returns ^M into real returns
  %s= *$==e   " Delete end of line blanks
endfunction
nnoremap <Leader>ws :call CleanCode()<CR>

" reselect visual block after indent
vnoremap < <gv
vnoremap > >gv

if g:is_macvim && has("gui_running")
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

" Tab manip --------------------------------------------------------------------
" Navigate tabs
nnoremap <silent> <C-Left> :tabprevious<CR>
nnoremap <silent> <C-Right> :tabnext<CR>
inoremap <silent> <C-Left> <Esc>:tabprevious<CR>
inoremap <silent> <C-Right> <Esc>:tabnext<CR>

" <C-9> is last tab like chrome - more than 4 tabs? you fucked up
if g:is_macvim && has("gui_running")
  " Map Command-# to switch tabs
  map  <D-0> 0gt
  imap <D-0> <Esc>0gt
  map  <D-1> 1gt
  imap <D-1> <Esc>1gt
  map  <D-2> 2gt
  imap <D-2> <Esc>2gt
  map  <D-3> 3gt
  imap <D-3> <Esc>3gt
  map  <D-4> 4gt
  imap <D-4> <Esc>4gt
  map  <D-9> :tablast<CR>
  imap <D-9> <Esc>:tablast<CR>
else
  " Map Control-# to switch tabs
  map  <C-0> 0gt
  imap <C-0> <Esc>0gt
  map  <C-1> 1gt
  imap <C-1> <Esc>1gt
  map  <C-2> 2gt
  imap <C-2> <Esc>2gt
  map  <C-3> 3gt
  imap <C-3> <Esc>3gt
  map  <C-4> 4gt
  imap <C-4> <Esc>4gt
  map  <C-9> :tablast<CR>
  imap <C-9> <Esc>:tablast<CR>
endif

" Buffer manip -----------------------------------------------------------------
" Tab in normal mode will quick-switch to  buffer
nnoremap <BS> :b#<CR>

" close buffer with space-bd and auto close loc list first
nnoremap <Leader>bd :lclose<CR>:bdelete<CR>
cabbrev <silent>bd lclose\|bdelete

" Split manip ------------------------------------------------------------------
" Backspace in normal mode will switch between loclist and prev split
function! SwitchToLocationList()
  if &buftype == "quickfix"
    wincmd w
  else
    lwindow
  endif
endfunction
nnoremap <silent><Tab> :call SwitchToLocationList()<CR>

" Resize
nnoremap <silent> <S-Left>  4<C-w><
nnoremap <silent> <S-Down>  4<C-W>-
nnoremap <silent> <S-Up>    4<C-W>+
nnoremap <silent> <S-Right> 4<C-w>>
inoremap <silent> <S-Left>  <Esc>4<C-w><
inoremap <silent> <S-Down>  <Esc>4<C-W>-
inoremap <silent> <S-Up>    <Esc>4<C-W>+
inoremap <silent> <S-Right> <Esc>4<C-w>>

" Navigate
nmap <silent> <A-Up> :wincmd k<CR>
nmap <silent> <A-Down> :wincmd j<CR>
nmap <silent> <A-Left> :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>

" quickfix and location list ---------------------------------------------------
" same as unimpaired []ql -- lets find something better...
" nnoremap <Up>     :lprevious<CR>
" inoremap <Up>     <Esc>:lprevious<CR>
" nnoremap <Down>   :lnext<CR>
" inoremap <Down>   <Esc>:lnext<CR>
" nnoremap <Left>   :cprevious<CR>
" inoremap <Left>   <Esc>:cprevious<CR>
" nnoremap <Right>  :cnext<CR>
" inoremap <Right>  <Esc>:cnext<CR>

