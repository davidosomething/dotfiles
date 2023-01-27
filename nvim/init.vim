" init.vim
" Neovim init (in place of vimrc, sources vimrc)

" ============================================================================
" Settings vars
" ============================================================================

" Fallback for vims with no env access like Veonim
" used by plugin/*
let g:vdotdir = empty($VDOTDIR) ? expand('$XDG_CONFIG_DIR/nvim') : $VDOTDIR

let g:dko_rtp_original = &runtimepath

let g:mapleader = "\<Space>"

" Plugin settings
let g:dko_autoinstall_vim_plug = executable('git')
let g:dko_use_completion = has('nvim-0.3') && executable('node')
let g:dko_use_fzf = v:version >= 704 && exists('&autochdir')

let g:truecolor = has('termguicolors')
      \ && $TERM_PROGRAM !=# 'Apple_Terminal'
      \ && ($COLORTERM ==# 'truecolor' || $DOTFILES_OS ==# 'Darwin')

" ============================================================================
" Temporary fixes
" ============================================================================

if !has('nvim-0.4')
  " https://github.com/neovim/neovim/issues/7994
  augroup dkoneovimfixes
    autocmd!
    autocmd InsertLeave * set nopaste
  augroup END
endif

" ============================================================================
" Settings
" ============================================================================

set clipboard+=unnamedplus

" Bumped '100 to '1000 to save more previous files
" Bumped <50 to <100 to save more register lines
" Bumped s10 to s100 for to allow up to 100kb of data per item
set shada=!,'1000,<100,s100,h

" The default blinking cursor leaves random artifacts in display like "q" in
" old terminal emulators and some VTEs
" https://github.com/neovim/neovim/issues?utf8=%E2%9C%93&q=is%3Aissue+cursor+shape+q
set guicursor=
augroup dkonvim
  autocmd!
  autocmd OptionSet guicursor noautocmd set guicursor=
augroup END

" New neovim feature, it's like vim-over but hides the thing being replaced
" so it is not practical for now (makes it harder to remember what you're
" replacing/reference previous regex tokens). Default is off, but explicitly
" disabled here, too.
" https://github.com/neovim/neovim/pull/5226
set inccommand=

" Pretty quick... errorprone on old vim so only apply to nvim
set updatetime=250

" ============================================================================
" My defaults
" May be overridden by **/plugins, after/plugins and **/ftplugins
" ============================================================================

" Only check one line
if exists('+modelines') | set modelines=1 | endif
" Prior versions are super dangerous
if !has('patch-8.1.1365') && !has('nvim-0.3.6') | set nomodeline | endif

if exists('+pyxversion') && has('python3') | set pyxversion=3 | endif

" ----------------------------------------------------------------------------
" Display
" ----------------------------------------------------------------------------

set title                             " wintitle = filename - vim

" this is already set by modern terminal and removed from nvim
"set ttyfast

" no beeps or flashes
set novisualbell
set noerrorbells

set number
set numberwidth=5

" show context around current cursor position
set scrolloff=8
set sidescrolloff=16

set textwidth=78
" the line will be right after column 80, &tw+3
set colorcolumn=+3
set colorcolumn+=120
set cursorline

set synmaxcol=512                     " don't syntax highlight long lines

if exists('+signcolumn')
  let &signcolumn = has('nvim-0.4') ? 'auto:3' : 'yes'
endif

set showtabline=0                     " start OFF, toggle =2 to show tabline
set laststatus=2                      " always show all statuslines

" This is slow on some terminals and often gets hidden by msgs so leave it off
set noshowcmd
set noshowmode                        " don't show -- INSERT -- in cmdline

" ----------------------------------------------------------------------------
" Input
" ----------------------------------------------------------------------------

" Enable mouse
set mouse=a

" Typing key combos
set notimeout
set ttimeout

" ----------------------------------------------------------------------------
" Wild and file globbing stuff in command mode
" ----------------------------------------------------------------------------

set browsedir=buffer                  " browse files in same dir as open file
set wildmode=list:longest,full
let &wildignorecase = v:version >= 704

" wildignore prevents things from showing up in cmd completion
" It's for things you'd NEVER open in Vim, like caches and binary files
" https://github.com/tpope/vim-fugitive/issues/121#issuecomment-38720847
" https://github.com/kien/ctrlp.vim/issues/63
" https://github.com/tpope/vim-vinegar/issues/61#issuecomment-167432416
" http://tbaggery.com/2011/08/08/effortless-ctags-with-git.html#comment-1396330403
"
" So don't do this! There are cases where you'd edit them or their contents
"set wildignore+=.git
"set wildignore+=.hg,.svn
"set wildignore+=tags
"set wildignore+=*.manifest

" Binary
set wildignore+=*.aux,*.out,*.toc
set wildignore+=*.o,*.obj,*.exe,*.dll,*.jar,*.pyc,*.rbc,*.class
set wildignore+=*.ai,*.bmp,*.gif,*.ico,*.jpg,*.jpeg,*.png,*.psd,*.webp
set wildignore+=*.avi,*.m4a,*.mp3,*.oga,*.ogg,*.wav,*.webm
set wildignore+=*.eot,*.otf,*.ttf,*.woff
set wildignore+=*.doc,*.pdf
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz
" Cache
set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*.gem
set wildignore+=.sass-cache
set wildignore+=npm-debug.log
" Compiled
set wildignore+=*.marko.js
set wildignore+=*.min.*,*-min.*
" Temp/System
set wildignore+=*.*~,*~
set wildignore+=*.swp,.lock,.DS_Store,._*,tags.lock

" ----------------------------------------------------------------------------
" File saving
" ----------------------------------------------------------------------------

set fileformats=unix,mac,dos
" Not modifiable if no window (e.g. resourcing vimrc)
if !&modifiable | set fileformat=unix | endif

" If we have a swap conflict, FZF has issues opening the file (and doesn't
" prompt correctly)
set noswapfile

" Use backup files when writing (create new file, replace old one with new
" one)
" Disabled for coc.nvim compat
set nowritebackup
" but do not leave around backup.xyz~ files after that
set nobackup
" backupcopy=yes is the default, just be explicit. We need this for
" webpack-dev-server and hot module reloading -- preserves special file types
" like symlinks
set backupcopy=yes

" don't create backups for these paths
set backupskip+=/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*
" Make Vim able to edit crontab files again.
set backupskip+=/private/tmp/*"
set backupskip+=~/.secret/*

" undo files
" double slash means create dir structure to mirror file's path
set undofile
set undolevels=1000
set undoreload=10000

" ----------------------------------------------------------------------------
" Spellcheck
" ----------------------------------------------------------------------------

" Add symlinked aspell from dotfiles as default spellfile
"let &g:spellfile = glob(expand(dko#vim_dir . '/en.utf-8.add'))

" ----------------------------------------------------------------------------
" Built-in completion
" ----------------------------------------------------------------------------

" Don't consider = symbol as part filename.
set isfname-==

set complete-=t                       " don't complete tags
set completeopt-=longest              " ncm2 requirement
set completeopt-=preview              " don't open scratch (e.g. echodoc)
set completeopt+=noinsert             " ncm2 requirement
set completeopt+=noselect             " ncm2 don't select first thing
set completeopt+=menu,menuone         " show PUM, even for one thing

" ----------------------------------------------------------------------------
" Message output on vim actions
" ----------------------------------------------------------------------------

" Some of these are the defaults, but explicitly match vim and nvim-4.0
set shortmess+=ilmnrxoOtWI
" Disable "Pattern not found" messages
if has('patch-7.4.314') | set shortmess+=c | endif

" ----------------------------------------------------------------------------
" Window splitting and buffers
" ----------------------------------------------------------------------------

set splitbelow
set splitright
if exists('+splitkeep')
  set splitkeep=screen
endif

set hidden                            " remember undo after quitting

" reveal already opened files from the quickfix window instead of opening new
" buffers
set switchbuf=useopen

set nostartofline                     " don't jump to col1 on switch buffer

" ----------------------------------------------------------------------------
" Code folding
" ----------------------------------------------------------------------------

set foldlevel=999                     " very high === all folds open
set foldlevelstart=99                 " show all folds by default
set nofoldenable

" ----------------------------------------------------------------------------
" Trailing whitespace
" ----------------------------------------------------------------------------

set list
set listchars=
set listchars+=tab:→\ 
set listchars+=trail:·
set listchars+=extends:»              " show cut off when nowrap
set listchars+=precedes:«
set listchars+=nbsp:⣿

" maybe...
" if has('patch-7.4.785') | set fixendofline | endif

" ----------------------------------------------------------------------------
" Diffing
" ----------------------------------------------------------------------------

" Note this is += since fillchars was defined in the window config
set fillchars+=diff:⣿
set diffopt=vertical                  " Use in vertical diff mode
set diffopt+=filler                   " blank lines to keep sides aligned
set diffopt+=iwhite                   " Ignore whitespace changes

" ----------------------------------------------------------------------------
" Input auto-formatting (global defaults)
" Probably need to update these in after/ftplugin too since ftplugins will
" probably update it.
" ----------------------------------------------------------------------------

set formatoptions=
set formatoptions+=r                  " Continue comments by default
set formatoptions-=o                  " do not continue comment using o or O
set formatoptions-=a                  " auto-gq on type in comments?
set formatoptions+=n                  " Recognize numbered lists
set formatoptions+=2                  " Use indent from 2nd line of a paragraph
set formatoptions-=l                  " break lines that are already long?
set formatoptions+=1                  " Break before 1-letter words
" no // comment when joining commented lines. This is not a default neovim
" setting despite what :help says. Various filetypes override it
if has('patch-7.3.541') | set formatoptions+=j | endif

" ----------------------------------------------------------------------------
" Whitespace
" ----------------------------------------------------------------------------

set nowrap
set nojoinspaces                      " J command doesn't add extra space

" ----------------------------------------------------------------------------
" Indenting - overridden by indent plugins
" ----------------------------------------------------------------------------

" For autoindent, use same spaces/tabs mix as previous line, even if
" tabs/spaces are mixed. Helps for docblock, where the block comments have a
" space after the indent to align asterisks
"
" The test case what happens when using o/O and >> and << on these:
"
"     /**
"      *
"
" Refer also to formatoptions+=o (copy comment indent to newline)
set nocopyindent

" Try not to change the indent structure on "<<" and ">>" commands. I.e. keep
" block comments aligned with space if there is a space there.
set nopreserveindent

" Smart detect when in braces and parens. Has annoying side effect that it
" won't indent lines beginning with '#'. Relying on syntax indentexpr instead.
" 'smartindent' in general is a piece of garbage, never turn it on.
set nosmartindent

" Global setting. I don't edit C-style code all the time so don't default to
" C-style indenting.
set nocindent

" ----------------------------------------------------------------------------
" Tabbing - overridden by editorconfig, after/ftplugin
" ----------------------------------------------------------------------------

" use multiple of shiftwidth when shifting indent levels.
" this is OFF so block comments don't get fudged when using ">>" and "<<"
set noshiftround

" ----------------------------------------------------------------------------
" Match and search
" ----------------------------------------------------------------------------

set matchtime=1                       " tenths of a sec
set noshowmatch                       " briefly jump to matching paren?
set wrapscan                          " Searches wrap around end of the file.
set ignorecase
" Follow smartcase and ignorecase when doing tag search
if exists('+tagcase') && has('patch-7.4.2230') | set tagcase=followscs | endif
set smartcase

if !empty(dko#grepper#Get().command)
  let &g:grepprg = dko#grepper#Get().command . ' '
        \ . join(dko#grepper#Get().options, ' ')
  let &g:grepformat = dko#grepper#Get().format
endif

" ============================================================================
" Security
" ============================================================================

" Disallow unsafe local vimrc commands
" Leave down here since it trims local settings
set secure

" ============================================================================
" :terminal emulator
" ============================================================================

let g:terminal_scrollback_buffer_size = 100000

" ----------------------------------------------------------------------------
" Use gruvbox's termcolors
"
" https://github.com/ianks/gruvbox/blob/c7b13d9872af9fe1f5588d6ec56759489b0d7864/colors/gruvbox.vim#L137-L169
" https://github.com/morhetz/gruvbox/pull/93/files

" dark0 + gray
let g:terminal_color_0 = '#282828'
let g:terminal_color_8 = '#928374'

" neurtral_red + bright_red
let g:terminal_color_1 = '#cc241d'
let g:terminal_color_9 = '#fb4934'

" neutral_green + bright_green
let g:terminal_color_2 = '#98971a'
let g:terminal_color_10 = '#b8bb26'

" neutral_yellow + bright_yellow
let g:terminal_color_3 = '#d79921'
let g:terminal_color_11 = '#fabd2f'

" neutral_blue + bright_blue
let g:terminal_color_4 = '#458588'
let g:terminal_color_12 = '#83a598'

" neutral_purple + bright_purple
let g:terminal_color_5 = '#b16286'
let g:terminal_color_13 = '#d3869b'

" neutral_aqua + faded_aqua
let g:terminal_color_6 = '#689d6a'
let g:terminal_color_14 = '#8ec07c'

" light4 + light1
let g:terminal_color_7 = '#a89984'
let g:terminal_color_15 = '#ebdbb2'

" ============================================================================
" Neovim-only mappings
" ============================================================================

" Special key to get back to vim
tnoremap <special> <C-b>      <C-\><C-n>

" Move between windows using Alt-
" Ctrl- works only outside of terminal buffers
tnoremap <special> <A-Up>     <C-\><C-n><C-w>k
tnoremap <special> <A-Down>   <C-\><C-n><C-w>j
tnoremap <special> <A-Left>   <C-\><C-n><C-w>h
tnoremap <special> <A-Right>  <C-\><C-n><C-w>l
nnoremap <special> <A-Up>     <C-w>k
nnoremap <special> <A-Down>   <C-w>j
nnoremap <special> <A-Left>   <C-w>h
nnoremap <special> <A-Right>  <C-w>l
nnoremap <special> <A-k>      <C-w>k
nnoremap <special> <A-j>      <C-w>j
nnoremap <special> <A-h>      <C-w>h
nnoremap <special> <A-l>      <C-w>l

nnoremap <special> <Leader>vt :<C-U>vsplit term://$SHELL<CR>A

" ============================================================================

let g:loaded_node_provider = 0
let g:loaded_ruby_provider = 0
let g:loaded_perl_provider = 0

" disable python 2
let g:loaded_python_provider = 0

" ============================================================================
" Python setup
" Skips if python is not installed in a pyenv virtualenv
" ============================================================================

function! s:FindExecutable(paths) abort
  for l:path in a:paths
    let l:executable = glob(expand(l:path))
    if !empty(l:executable) && executable(l:executable)
      return l:executable
    endif
  endfor
  return ''
endfunction

" python 3
let s:py3 = s:FindExecutable([
      \   '$PYENV_ROOT/versions/neovim3/bin/python',
      \   '$ASDF_DIR/shims/python',
      \   '/usr/bin/python3',
      \ ])
if !empty(s:py3)
  let g:python3_host_prog = s:py3
else
  let g:loaded_python3_provider = 2
endif

" ----------------------------------------------------------------------------
" Syntax
" Needs to be in vimrc (or ftdetect) since syntax runs before ftplugin
" ----------------------------------------------------------------------------

" ----------------------------------------
" Filetype: markdown
" ----------------------------------------

" Variable to highlight markdown fenced code properly -- uses tpope's
" vim-markdown plugin (which is bundled with vim7.4 now)
" There are more syntaxes, but checking for them makes editing md very slow
let g:markdown_fenced_languages = [
      \   'javascript', 'js=javascript', 'javascriptreact',
      \   'json',
      \   'bash=sh', 'sh',
      \   'vim',
      \   'help',
      \ ]

" ----------------------------------------
" Filetype: php
" ----------------------------------------

" Additional syntax groups for php baselib
let g:php_baselib = 1
" Highlight unclosed ([]) - from $VIMRUNTIME/syntax/php.vim
let g:php_parentError = 1
" Assume strings contain HTML
let g:php_htmlInStrings = 1

" $VIMRUNTIME/indent/php.vim and 2072/
" Don't indent after <?php opening
let g:PHP_default_indenting = 0
" Don't outdent the <?php tags to the first column
let g:PHP_outdentphpescape  = 0

" ----------------------------------------
" Filetype: python
" ----------------------------------------

" $VIMRUNTIME/syntax/python.vim
let g:python_highlight_all = 1

" ----------------------------------------
" Filetype: sh
" ----------------------------------------

" $VIMRUNTIME/syntax/sh.vim - always assume bash
let g:is_bash = 1

" ----------------------------------------
" Filetype: vim
" ----------------------------------------

" $VIMRUNTIME/syntax/vim.vim
" disable mzscheme, tcl highlighting
let g:vimsyn_embed = 'lpPr'

" ============================================================================
" Plugins
" ============================================================================

" ----------------------------------------------------------------------------
" Plugins: Disable distributed plugins
" To re-enable you have to comment them out (checks if defined, not if truthy)
" ----------------------------------------------------------------------------

let g:loaded_2html_plugin = 1
let g:loaded_getscriptPlugin = 1
let g:loaded_gzip = 1
let g:loaded_man = 1
let g:loaded_LogiPat = 1
let g:loaded_tarPlugin = 1
let g:loaded_tutor_mode_plugin = 1
let g:loaded_zipPlugin = 1

" % matching replaced by vim-matchup, which sets the following
"let g:loaded_matchit = 1
" Upstream matchparen -- it is inaccurate. Replaced by vim-matchup
let g:loaded_matchparen = 1

" used to download spellfile and enable gx mapping
"let g:loaded_netrwPlugin = 0

" netrw in details format when no vimfiler
let g:netrw_liststyle      = 3
let g:netrw_home           = expand(g:dko#vim_dir . '/.tmp/cache')
let g:netrw_browsex_viewer = 'dko-open'

" ----------------------------------------------------------------------------
" Plugins: autoinstall vim-plug, define plugins, install plugins if needed
" ----------------------------------------------------------------------------

if g:dko_autoinstall_vim_plug
  let s:has_plug = !empty(glob(expand(g:dko#vim_dir . '/autoload/plug.vim')))
  " Load vim-plug and its plugins?
  if !s:has_plug && executable('curl')
    call dkoplug#install#Install()
    let s:has_plug = 1
  endif

  if s:has_plug
    augroup dkoplugupdates
      autocmd User dko-plugins-installed,dko-plugins-updated
            \   if exists(':UpdateRemotePlugins')
            \|    silent! UpdateRemotePlugins
            \|  endif
    augroup END

    command! PI PlugInstall | doautocmd User dko-plugins-installed
    command! PU PlugUpgrade | PlugUpdate | doautocmd User dko-plugins-updated

    let g:plug_window = 'tabnew'
    call plug#begin(g:dko#plug_absdir)
    if empty($VIMNOPLUGS) | call dkoplug#plugins#LoadAll() | endif
    call plug#end()
  endif
endif

" ============================================================================
" Autocommands
" ============================================================================

augroup dkowindow
  autocmd!
  autocmd VimResized * wincmd =

  " automatically close corresponding loclist when quitting a window
  if exists('##QuitPre')
    autocmd QuitPre * nested if &filetype != 'qf' | silent! lclose | endif
  endif
augroup END

augroup dkolines
  autocmd!
  if dkoplug#IsLoaded('coc.nvim')
    autocmd User CocNvimInit ++nested call dkoline#Init()
  elseif has('nvim')
    autocmd VimEnter * ++nested call dkoline#Init()
  endif
augroup END

augroup dkoproject
  autocmd!
  autocmd BufNewFile,BufRead,BufWritePost * call dko#project#MarkBuffer()
  autocmd User CocNvimInit call dko#lint#SetupCoc()
  autocmd User neomake call dko#lint#Setup()
augroup END

" Auto-reload the colorscheme if it was edited in vim
augroup dkocoloredit
  autocmd!
  autocmd BufWritePost */colors/*.vim so <afile>
augroup END

" Read only mode (un)mappings
augroup dkoreadonly
  autocmd!
  autocmd BufEnter * call dko#readonly#Unmap()
augroup END

" Disable linting and syntax highlighting for large and minified files
augroup dkohugefile
  autocmd BufReadPre *
        \   if getfsize(expand("%")) > 10000000
        \|    syntax off
        \|    let b:dko_hugefile = 1
        \|  endif
  autocmd BufReadPre *.min.* syntax off
augroup END

" Automatically assign file marks for filetype when switch buffer so you can
" easily go between e.g., css/html using `C `H
" https://old.reddit.com/r/vim/comments/df4jac/how_do_you_use_marks/f317a1l/
augroup dkoautomark
  autocmd!
  autocmd BufLeave *.css,*.less,*.scss  normal! mC
  autocmd BufLeave *.html               normal! mH
  autocmd BufLeave *.js*,*.ts*          normal! mJ
  autocmd BufLeave *.md                 normal! mM
  autocmd BufLeave *.yml,*.yaml         normal! mY
augroup END

augroup dkorestoreposition
  autocmd!
  autocmd BufWinEnter * call dko#RestorePosition()
augroup END

" vim: sw=2 :
