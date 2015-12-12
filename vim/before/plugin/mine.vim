scriptencoding utf-8

" ============================================================================
" My sane defaults
" ============================================================================

" ============================================================================
" Modeline overrides
" ============================================================================

set modeline

" ============================================================================
" Faster response
" ============================================================================

set notimeout
set ttimeout
set ttimeoutlen=10

" ============================================================================
" For chruby
" ============================================================================

set shell=$SHELL

" ============================================================================
" Display
" ============================================================================

" no beeps or flashes
set visualbell t_vb=
set ttyfast

" don't update the display while executing macros
set lazyredraw

set synmaxcol=512                     " don't syntax highlight long lines

set colorcolumn=80
set title                             " wintitle = filename - vim
set number
set numberwidth=5
set cursorline
set scrolloff=8                       " show 2 lines of context
set sidescrolloff=16
set completeopt-=preview              " don't open scratch preview

" ============================================================================
" Status line - most of this is handled by vim-airline
" ============================================================================

set laststatus=2
set showcmd                           " incomplete commands on

" ============================================================================
" Code folding
" ============================================================================

set foldcolumn=2
set foldlevel=99                      " show all folds by default
set foldlevelstart=99                 " show all folds by default

" ============================================================================
" Splits
" ============================================================================

set splitbelow
set splitright

" ============================================================================
" Input
" ============================================================================

set formatoptions=
set formatoptions+=c                  " Auto-wrap comments using textwidth
set formatoptions+=r                  " Continue comments by default
set formatoptions-=o                  " do not continue comment using o or O
set formatoptions+=q                  " continue comments with gq
set formatoptions+=n                  " Recognize numbered lists
set formatoptions+=2                  " Use indent from 2nd line of a paragraph
set formatoptions+=l                  " Don't break lines that are already long
set formatoptions+=1                  " Break before 1-letter words
" Vim 7.4 only: no // comment when joining commented lines
if v:version >= 704 | set formatoptions+=j | endif
set nrformats-=octal                  " never use octal when <C-x> or <C-a>
set mouse=a
if !has('nvim') | set ttymouse=xterm | endif

" ============================================================================
" Whitespace
" ============================================================================

set nowrap
set nojoinspaces                      " J command doesn't add extra space

" ============================================================================
" Indenting newlines
" ============================================================================

set autoindent                        " indent when creating newline
set smartindent                       " add an indent level inside braces

" for autoindent, use same spaces/tabs mix as previous line, even if
" tabs/spaces are mixed. Helps for docblock, where the block comments have a
" space after the indent to align asterisks
set copyindent

" Try not to change the indent structure on "<<" and ">>" commands. I.e. keep
" block comments aligned with space if there is a space there.
set preserveindent

" ============================================================================
" Tabbing - overridden by editorconfig, IndentTab, after/ftplugin
" ============================================================================

set expandtab                         " default to spaces instead of tabs
set shiftwidth=2                      " softtabs are 2 spaces for expandtab

" Alignment tabs are two spaces, and never tabs. Negative means use same as
" shiftwidth (so the 2 actually doesn't matter).
set softtabstop=-2

" real tabs render 4 wide. Applicable to HTML, PHP, anything using real tabs.
" I.e., not applicable to JS.
set tabstop=4

" use multiple of shiftwidth when shifting indent levels.
" this is OFF so block comments don't get fudged when using ">>" and "<<"
set noshiftround

" When on, a <Tab> in front of a line inserts blanks according to
" 'shiftwidth'.  'tabstop' or 'softtabstop' is used in other places.  A
set smarttab

set backspace=indent,eol,start        " bs anything

" ============================================================================
" Trailing whitespace
" ============================================================================

set list
set listchars=""                      " reset
set listchars=tab:→\ 
set listchars+=trail:·
set listchars+=extends:»              " show cut off when nowrap
set listchars+=precedes:«

set fillchars=diff:⣿,vert:│
set fillchars=diff:⣿,vert:\|

" ============================================================================
" Diffing
" ============================================================================

set diffopt=vertical                  " Use in vertical diff mode
set diffopt+=filler                   " blank lines to keep sides aligned
set diffopt+=iwhite                   " Ignore whitespace changes

" ============================================================================
" Spellcheck
" ============================================================================

" Add symlinked aspell from dotfiles as default spellfile
execute 'set spellfile=' . glob(expand(g:dko_vim_dir . '/aspell.utf-8.add'))

" ============================================================================
" Match and search
" ============================================================================

set showmatch                         " hl matching parens
set hlsearch
set incsearch
set wrapscan                          " Searches wrap around end of the file.
set ignorecase
set smartcase

" The Silver Searcher
if executable('ag') | set grepprg=ag\ --nogroup\ --nocolor | endif

" ============================================================================
" Wild and file globbing stuff
" ============================================================================

set browsedir=buffer                  " browse files in same dir as open file
set wildmenu                          " Enhanced command line completion.
set wildmode=list:longest             " Complete files like a shell.
set wildignorecase
" output, VCS
set wildignore+=.git,.hg,.svn
set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*/.sass-cache/*,*.gem
set wildignore+=*.aux,*.out,*.toc
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest,*.rbc,*.class
set wildignore+=*.ai,*.bmp,*.gif,*.ico,*.jpg,*.jpeg,*.png,*.psd,*.webp
set wildignore+=*.avi,*.m4a,*.mp3,*.oga,*.ogg,*.wav,*.webm
set wildignore+=*.eot,*.otf,*.ttf,*.woff
set wildignore+=*.doc,*.pdf
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz
set wildignore+=*.swp,.lock,.DS_Store,._*

" ============================================================================
" File saving
" ============================================================================

"set autoread                         " reload files if they were edited
                                      " elsewhere
set fileformats=unix,mac,dos
set fileformat=unix

" info file
if !has('nvim')
  execute 'set viminfo+=n' . expand(g:dko_vim_dir . '/.tmp/cache/.viminfo')
else
  execute 'set viminfo+=n' . expand(g:dko_nvim_dir . '/.tmp/cache/.nviminfo')
endif

" From https://github.com/swizzard/dotfiles/blob/master/.vimrc
" Don't keep .viminfo information for files in temporary directories or shared
" memory filesystems; this is because they're used as scratch spaces for tools
" like sudoedit(8) and pass(1) and hence could present a security problem
if has('viminfo') && has('autocmd')
  augroup viminfoskip
    autocmd!
    silent! autocmd BufNewFile,BufReadPre
        \ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*
        \ setlocal viminfo=
  augroup END
endif

" swap - useless
set noswapfile

" backups
set backupskip=/tmp/*
" Make Vim able to edit crontab files again.
if has('autocmd')
  set backupskip+=,/private/tmp/*"
  if has('mac')
    autocmd vimrc BufEnter /private/tmp/crontab.* setlocal backupcopy=yes
  endif
endif
execute 'set backupdir=' . g:dko_vim_dir . '/.tmp/backup//'
set backup

" undo files
" double slash means create dir structure to mirror file's path
set undofile
set undolevels=500
set undoreload=500
execute 'set undodir=' . g:dko_vim_dir . '/.tmp/undo//'
execute 'set directory=' . g:dko_vim_dir . '/.tmp/swap//'

" ============================================================================
" Buffer reuse
" ============================================================================

set hidden                            " remember undo after quitting

" reveal already opened files from the quickfix window instead of opening new
" buffers
set switchbuf=useopen

" ============================================================================
" Clipboard -- use os clipboard
" ============================================================================

if (exists("$DISPLAY") || has('mac')) && has('clipboard')
  set clipboard=unnamed  " Share system clipboard.
  " Share X windows clipboard.
  if has('unnamedplus') | set clipboard+=unnamedplus | endif
endif

" ============================================================================
" Syntax
" ============================================================================

" Variable to highlight markdown fenced code properly -- uses tpope's
" vim-markdown plugin (which is bundled with vim7.4 now)
" There are more syntaxes, but checking for them makes editing md very slow
let g:markdown_fenced_languages = [
      \ 'html',
      \ 'javascript', 'js=javascript', 'json=javascript',
      \ 'sass',
      \ ]

" ============================================================================
" Autocommands
" ============================================================================

if has('autocmd')
  " Resize splits when the window is resized
  autocmd vimrc VimResized * :wincmd =

  " No EOL character on files -- specifically for WP VIP PHP
  autocmd vimrc BufRead,BufNewFile */wp-content/themes/vip/*
        \ setlocal noeol binary fileformat=dos

  " see after/ftplugin/*.vim for more filetype specific stuff
endif

" leave this down here since it trims local settings
set secure                            " no unsafe local vimrc commands

