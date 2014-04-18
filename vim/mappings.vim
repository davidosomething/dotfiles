""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" keyboard - most of this is straight from Janus

" Map <Leader> to comma
let mapleader = ","

" Disable vim help
inoremap <F1> <nop>
nnoremap <F1> <nop>

" Toggle paste mode
nnoremap <silent> <F12> :set invpaste<CR>:set paste?<CR>
inoremap <silent> <F12> <ESC>:set invpaste<CR>:set paste?<CR>

" Map the arrow keys to be based on display lines, not physical lines
map <Down> gj
map <Up> gk

" Use Ctrl-U/D for pg up and pg dn, maintains cursor position on screen
" http://github.com/gf3/dotfiles/blob/fe8bba3711181728c670cad2d585705d8e68c5b7/.vimrc
map <PageUp> <C-U>
map <PageDown> <C-D>
imap <PageUp> <C-O><C-U>
imap <PageDown> <C-O><C-D>

" fix typo !W to !w
" https://bitbucket.org/sjl/dotfiles/src/tip/vim/.vimrc
command! -bang W w<bang>

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

" upper/lower word
nmap <Leader>u mQviwU`Q
nmap <Leader>l mQviwu`Q

" Toggle hlsearch with <Leader>hs
nnoremap <Leader>hs :set hlsearch! hlsearch?<CR>

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

" Keep search pattern at the center of the screen.
" http://vimbits.com/bits/92
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz
nnoremap <silent> g# g#zz

" Space to toggle folds.
" https://bitbucket.org/sjl/dotfiles/src/tip/vim/.vimrc
nnoremap <Space> za
vnoremap <Space> za

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" My Tab and Split manipulation
nnoremap <Leader>v :vsplit<cr>
" resize vertical splits
nmap <Leader>_ <C-w>>
nmap <Leader>+ <C-w><
" resize horizontal splits
nmap <Leader>- <C-w>-
nmap <Leader>= <C-w>+
" swap splits with ,mw (mark this one) and ,pw (swap with this one)
" http://stackoverflow.com/questions/2586984/how-can-i-swap-positions-of-two-open-files-in-splits-in-vim
function! MarkWindowSwap()
  let g:markedWinNum = winnr()
endfunction
function! DoWindowSwap()
  "Mark destination
  let curNum = winnr()
  let curBuf = bufnr( "%" )
  exe g:markedWinNum . "wincmd w"
  "Switch to source and shuffle dest->source
  let markedBuf = bufnr( "%" )
  "Hide and open so that we aren't prompted and keep history
  exe 'hide buf' curBuf
  "Switch to dest and shuffle source->dest
  exe curNum . "wincmd w"
  "Hide and open so that we aren't prompted and keep history
  exe 'hide buf' markedBuf
endfunction
nnoremap <silent> <Leader>mw :call MarkWindowSwap()<CR>
nnoremap <silent> <Leader>pw :call DoWindowSwap()<CR>

" Navigate splits
nnoremap <silent> <C-k> :wincmd k<CR>
nnoremap <silent> <C-j> :wincmd j<CR>
nnoremap <silent> <C-h> :wincmd h<CR>
nnoremap <silent> <C-l> :wincmd l<CR>

" Navigate tabs
nnoremap <silent> <Leader>[ :tabprevious<CR>
nnoremap <silent> <Leader>] :tabnext<CR>

" Clean code function
function! CleanCode()
  %retab " Replace tabs with spaces
  %s/\r/\r/eg " Turn DOS returns ^M into real returns
  %s= *$==e " Delete end of line blanks
  echo "Cleaned up this mess."
endfunction
nnoremap <Leader>ws :call CleanCode()<cr>
