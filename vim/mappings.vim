imap jj <Esc>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" keyboard - most of this is straight from Janus

" Disable vim help
inoremap <F1> <nop>
nnoremap <F1> <nop>

" Toggle paste mode
nnoremap <silent> <F12> :set invpaste<CR>:set paste?<CR>
inoremap <silent> <F12> <ESC>:set invpaste<CR>:set paste?<CR>

" Toggle hlsearch with <Leader>hs
nnoremap <Leader>hs :set hlsearch! hlsearch?<CR>

" Space to toggle folds.
" https://bitbucket.org/sjl/dotfiles/src/tip/vim/.vimrc
nnoremap <Space> za
vnoremap <Space> za

" Unfuck my screen
" https://bitbucket.org/sjl/dotfiles/src/2c4aba25376c6c5cb5d4610cf80109d99b610505/vim/vimrc?at=default#cl-444
nnoremap U :syntax sync fromstart<cr>:redraw!<cr>

""
" Scrolling
" Map the arrow keys to be based on display lines, not physical lines
vnoremap <Down> gj
vnoremap <Up>   gk

" Replace PgUp and PgDn with Ctrl-U/D
map   <PageUp>    <C-U>
map   <PageDown>  <C-D>
imap  <PageUp>    <C-O><C-U>
imap  <PageDown>  <C-O><C-D>

" Keep search pattern at the center of the screen.
" http://vimbits.com/bits/92
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz
nnoremap <silent> g# g#zz

""
" Commands
" Remap :W to :w
command W w

""
" zeal lookup
if g:is_term
  nnoremap <leader>K :!zeal --query "<cword>"&<CR><CR>
endif

""
" Traversal / Filesystem
" cd to the directory containing the file in the buffer
nnoremap <silent> <Leader>cd :lcd %:h<CR>

function! ChangeToVCSRoot()
  let cph = expand('%:p:h', 1)
  if match(cph, '\v^<.+>://') >= 0 | retu | en
  for mkr in ['.git/', '.hg/', '.svn/', '.bzr/', '_darcs/', '.vimprojects']
    let wd = call('find'.(mkr =~ '/$' ? 'dir' : 'file'), [mkr, cph.';'])
    if wd != '' | let &acd = 0 | brea | en
  endfo
  exe 'lc!' fnameescape(wd == '' ? cph : substitute(wd, mkr.'$', '.', ''))
endfunction
nnoremap <silent> <Leader>cdr :call ChangeToVCSRoot()<CR>

" Create the directory containing the file in the buffer
nnoremap <silent> <Leader>md :!mkdir -p %:p:h<CR>

""
" Editing

" Sort lines
" https://bitbucket.org/sjl/dotfiles/src/2c4aba25376c6c5cb5d4610cf80109d99b610505/vim/vimrc?at=default#cl-288
nnoremap <Leader>s vip:!sort<cr>
vnoremap <Leader>s :!sort<cr>

" reselect visual block after indent
vnoremap < <gv
vnoremap > >gv

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
nnoremap <Leader>ws :call CleanCode()<cr>

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
  map  <D-5> 5gt
  imap <D-5> <Esc>5gt
  map  <D-6> 6gt
  imap <D-6> <Esc>6gt
  map  <D-7> 7gt
  imap <D-7> <Esc>7gt
  map  <D-8> 8gt
  imap <D-8> <Esc>8gt
  map  <D-9> 9gt
  imap <D-9> <Esc>9gt
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

  " Bubble single lines
  nmap <C-Up> [e
  nmap <C-Down> ]e
  nmap <C-k> [e
  nmap <C-j> ]e

  " Bubble multiple lines
  vmap <C-Up> [egv
  vmap <C-Down> ]egv
  vmap <C-k> [egv
  vmap <C-j> ]egv

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
  map  <C-5> 5gt
  imap <C-5> <Esc>5gt
  map  <C-6> 6gt
  imap <C-6> <Esc>6gt
  map  <C-7> 7gt
  imap <C-7> <Esc>7gt
  map  <C-8> 8gt
  imap <C-8> <Esc>8gt
  map  <C-9> 9gt
  imap <C-9> <Esc>9gt
endif

""
" Tab and Split manipulation

" Resize splits
nnoremap <silent> <Left>  4<C-w><
nnoremap <silent> <Down>  4<C-W>-
nnoremap <silent> <Up>    4<C-W>+
nnoremap <silent> <Right> 4<C-w>>
inoremap <silent> <Left>  <Esc>4<C-w><
inoremap <silent> <Down>  <Esc>4<C-W>-
inoremap <silent> <Up>    <Esc>4<C-W>+
inoremap <silent> <Right> <Esc>4<C-w>>

" Navigate tabs
nnoremap <silent> <S-Left> :tabprevious<CR>
nnoremap <silent> <S-Right> :tabnext<CR>
inoremap <silent> <S-Left> :tabprevious<CR>
inoremap <silent> <S-Right> :tabnext<CR>
