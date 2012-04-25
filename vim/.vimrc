""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" plugin management
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'
" My bundles -------------------------------------------------------------------
" appearance
Bundle 'altercation/vim-colors-solarized'
Bundle 'kien/rainbow_parentheses.vim'
Bundle 'Lokaltog/vim-powerline'
Bundle 'nathanaelkane/vim-indent-guides'
Bundle 'vim-scripts/IndexedSearch'
Bundle 'vim-scripts/kwbdi.vim'
" editing
Bundle 'edsono/vim-matchit'
Bundle 'ervandew/supertab'
Bundle 'godlygeek/tabular'
Bundle 'scrooloose/nerdcommenter'
Bundle 'Shougo/neocomplcache'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-speeddating'
Bundle 'michaeljsmith/vim-indent-object'
Bundle 'nishigori/vim-sunday'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-unimpaired'
Bundle 'vim-scripts/AnsiEsc.vim'
Bundle 'vim-scripts/YankRing.vim'
" menus and special features
Bundle 'gmarik/sudo-gui.vim'
Bundle 'jeetsukumaran/vim-buffergator'
Bundle 'kien/ctrlp.vim'
Bundle 'majutsushi/tagbar'
Bundle 'scrooloose/nerdtree'
Bundle 'tpope/vim-fugitive'
" syntax
Bundle 'acustodioo/vim-tmux'
Bundle 'hail2u/vim-css3-syntax'
Bundle 'itspriddle/vim-jquery'
Bundle 'pangloss/vim-javascript'
Bundle 'scrooloose/syntastic'
Bundle 'skammer/vim-css-color'
Bundle 'tpope/vim-git'
Bundle 'tpope/vim-haml'
Bundle 'tpope/vim-markdown'
Bundle 'tpope/vim-ragtag'
Bundle 'tpope/vim-rails'
Bundle 'vim-ruby/vim-ruby'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" syntax
syntax on
filetype plugin indent on

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
set foldlevel=99                      " show all folds by default
set foldlevelstart=99                 " show all folds by default
set splitbelow
set splitright
set mouse=a

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
set noswapfile                        " eff that
set directory=~/.vim/_temp//          " where to put swap files.
set nobackup                          " hate those
set backupdir=~/.vim/_backup//        " defunct now
set hidden                            " remember undo after quitting

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
set nojoinspaces

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use Ack instead of Grep when available
" https://github.com/thoughtbot/dotfiles/blob/master/vimrc
if executable("ack")
  set grepprg=ack\ -H\ --nogroup\ --nocolor
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" filetype specific
if has("autocmd")
  " Makefiles, Python use real tabs
  au FileType gitconfig   set noexpandtab
  au FileType make        set noexpandtab
  au FileType python      set noexpandtab
  " stupid folding
  au FileType php         set foldlevel=99 foldlevelstart=99
  " Enable soft-wrapping for text files
  autocmd FileType text,txt,markdown,html,xhtml,eruby setlocal wrap linebreak nolist textwidth=80
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" befores -- plugin settings and keybindings
for f in split(glob('~/.dotfiles/vim/before/*.vim'), '\n')
  exe 'source' f
endfor

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Local config
if filereadable($HOME . "/.vimrc.local")
  source ~/.vimrc.local
endif
