" mode toggling ----------------------------------------------------------------
" toggle visual/normal mode
nnoremap <Leader><Leader> V
vnoremap <Leader><Leader> <Esc>

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
nnoremap <silent> \| :call ToggleMovementMode()<CR>

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

" Don't move on * (it automatically goes to next match)
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

" insert line fill to textwidth
" http://stackoverflow.com/a/3400528/230473
function! FillLine( str )
  " set tw to the desired total length
  let tw = &textwidth
  if tw==0 | let tw = 80 | endif
  " strip trailing spaces first
  .s/[[:space:]]*$//
  " calculate total number of 'str's to insert
  let reps = (tw - col("$")) / len(a:str)
  " insert them, if there's room, removing trailing spaces (though forcing
  " there to be one)
  if reps > 0
    .s/$/\=(' '.repeat(a:str, reps))/
  endif
endfunction
inoremap <Leader>f- <Esc>:call FillLine('-')<CR>
inoremap <Leader>f= <Esc>:call FillLine('=')<CR>
inoremap <Leader>f# <Esc>:call FillLine('#')<CR>
inoremap <Leader>f* <Esc>:call FillLine('*')<CR>
nnoremap <Leader>f- :call FillLine('-')<CR>
nnoremap <Leader>f= :call FillLine('=')<CR>
nnoremap <Leader>f# :call FillLine('#')<CR>
nnoremap <Leader>f* :call FillLine('*')<CR>

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

" Tab manip --------------------------------------------------------------------
" Navigate tabs
nnoremap <silent> <C-Left> :tabprevious<CR>
nnoremap <silent> <C-Right> :tabnext<CR>
inoremap <silent> <C-Left> <Esc>:tabprevious<CR>
inoremap <silent> <C-Right> <Esc>:tabnext<CR>

" Buffer manip -----------------------------------------------------------------
" close buffer with space-bd and auto close loc list first
nnoremap <Leader>bd :lclose<CR>:bdelete<CR>
cabbrev <silent>bd lclose\|bdelete

" Split manip ------------------------------------------------------------------
" Navigate with alt+arrow
nmap <silent> <A-Up> :wincmd k<CR>
nmap <silent> <A-Down> :wincmd j<CR>
nmap <silent> <A-Left> :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>

" Resize
nnoremap <silent> <S-Left>  4<C-w><
nnoremap <silent> <S-Down>  4<C-W>-
nnoremap <silent> <S-Up>    4<C-W>+
nnoremap <silent> <S-Right> 4<C-w>>
inoremap <silent> <S-Left>  <Esc>4<C-w><
inoremap <silent> <S-Down>  <Esc>4<C-W>-
inoremap <silent> <S-Up>    <Esc>4<C-W>+
inoremap <silent> <S-Right> <Esc>4<C-w>>

