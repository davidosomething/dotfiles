set nocompatible                      " vi mode off

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" plugin management
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" display
set title                             " wintitle = filename - vim
set titleold=""                       " restore title on exit
set t_Co=256
set background=light
colorscheme solarized
if &term == 'linux'                   " not tty mode
  set t_Co=16
  colorscheme elflord
endif
set number
set numberwidth=5
set cursorline
set scrolloff=3                       " show 2 lines of context
set foldlevelstart=99                 " show all folds by default

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" syntax
syntax on
filetype plugin indent on

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" search
set hlsearch
set incsearch
set ignorecase
set smartcase
" fix regexes
nnoremap / /\v
vnoremap / /\v

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" status line - most of this is handled by vim-powerline
set laststatus=2
set showcmd                           " incomplete commands on
"set ruler
"set showmode
"set statusline=%t\ %y\ format:\ %{&ff};\ [%l,%c]

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Wild and file globbing stuff
set browsedir=buffer                  " browse files in same dir as open file
set wildmenu                          " Enhanced command line completion.
set wildmode=list:longest             " Complete files like a shell.
" output, VCS
set wildignore+=*.o,*.out,*.obj,*.exe,*.dll,.git,*.rbc,*.class,.svn,*.gem
set wildignore+=*.gif,*.jpg,*.jpeg,*.png,*.psd,*.ico
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz
" bundler and SASS
set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*/.sass-cache/*
" JUNK
set wildignore+=*.swp,.lock,.DS_Store,._*

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" file saving
set autoread                          " reload files if they were edited elsewhere
set fileformats=unix,mac,dos
set fileformat=unix
set encoding=utf-8

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" backups
set nobackup                          " hate those
set backupdir=~/.vim/_backup//        " defunct now
set directory=~/.vim/_temp//          " where to put swap files.

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" whitespace
set nowrap
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set backspace=indent,eol,start        " bs anything
set noeol
"set smartindent -- using filetype indenting
" Trailing whitespace
set list
set listchars=""                      " reset
set listchars=tab:→\ 
set listchars+=trail:·
set listchars+=extends:»              " show cut off when nowrap
set listchars+=precedes:«

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" keyboard - most of this is straight from Janus
" Map <Leader> to comma
" let mapleader = ","
" use :w!! to write to a file using sudo if you forgot to 'sudo vim file'
" (it will prompt for sudo password when writing)
cmap w!! %!sudo tee > /dev/null %
" upper/lower word
nmap <leader>u mQviwU`Q
nmap <leader>l mQviwu`Q
" cd to the directory containing the file in the buffer
nmap <silent> <leader>cd :lcd %:h<CR>
" Create the directory containing the file in the buffer
nmap <silent> <leader>md :!mkdir -p %:p:h<CR>
" Map the arrow keys to be based on display lines, not physical lines
map <Down> gj
map <Up> gk
" Toggle hlsearch with <leader>hs
nmap <leader>hs :set hlsearch! hlsearch?<CR>
" Toggle paste mode
nmap <silent> <F4> :set invpaste<CR>:set paste?<CR>
imap <silent> <F4> <ESC>:set invpaste<CR>:set paste?<CR>
if has("gui_macvim") && has("gui_running")
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

  " Make shift-insert work like in Xterm
  map <S-Insert> <MiddleMouse>
  map! <S-Insert> <MiddleMouse>

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

" shortcuts for resizing splits
" split wider
nmap <leader>] <C-w>>
" split narrower
nmap <leader>[ <C-w><
" split shorter
nmap <leader>- <C-w>-
" split taller
nmap <leader>+ <C-w>+

" swap splits with \mw (mark this one) and \pw (swap with this one)
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

nmap <silent> <leader>mw :call MarkWindowSwap()<CR>
nmap <silent> <leader>pw :call DoWindowSwap()<CR>

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

" fix typo !W to !w
" https://bitbucket.org/sjl/dotfiles/src/tip/vim/.vimrc
command! -bang W w<bang>

nmap <silent> <leader>rc :so $MYVIMRC<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" plugin specific (and not from janus)
call togglebg#map("<F12>")            " F12 to swap solarized palette
let g:yankring_history_file = '.vim/.yankring-history'
" We don't want to use Ctrl-p as the mapping because
" it interferes with YankRing (paste, then hit ctrl-p)
let g:ctrlp_map = '<C-t>'

" run syntastic on file open
let g:syntastic_check_on_open = 1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" filetype specific
" Makefiles, Python use real tabs
au FileType make   set noexpandtab
au FileType python set noexpandtab
" wrap textfiles at 80
autocmd FileType text,txt setlocal textwidth=80

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Local config
if filereadable("~/.vimrc.local")
  source ~/.vimrc.local
endif
