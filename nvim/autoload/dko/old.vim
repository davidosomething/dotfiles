scriptencoding utf-8

" autoload/dko/old.vim
"
" Settings for old vim
"

function! dko#old#Settings() abort

  " ----------------------------------------------------------------------------
  " Clipboard -- use os clipboard
  " ----------------------------------------------------------------------------

  " nvim has bracketed paste built in
  set pastetoggle=<F12>

  " ----------------------------------------------------------------------------
  " Display
  " ----------------------------------------------------------------------------

  " macros don't update display
  set lazyredraw
  " visualbell term code
  set t_vb=

  " ----------------------------------------------------------------------------
  " Window splitting and buffers
  " ----------------------------------------------------------------------------

  set fillchars=vert:│                  " Vertical sep between windows (unicode)

  " ----------------------------------------------------------------------------
  " Built-in completion
  " ----------------------------------------------------------------------------

  set complete-=i                       " don't complete includes

  " ----------------------------------------------------------------------------
  " Input
  " ----------------------------------------------------------------------------

  set ttimeoutlen=10

  " ----------------------------------------------------------------------------
  " Wild and file globbing stuff in command mode
  " ----------------------------------------------------------------------------

  set wildmenu                          " Enhanced command line completion.

  " ----------------------------------------------------------------------------
  " Input auto-formatting (global defaults)
  " Probably need to update these in after/ftplugin too since ftplugins will
  " probably update it.
  " ----------------------------------------------------------------------------

  set formatoptions+=c                  " Auto-wrap comments using textwidth
  set formatoptions+=q                  " continue comments with gq

  set nrformats-=octal                  " never use octal when <C-x> or <C-a>

  " ----------------------------------------------------------------------------
  " Indenting - overridden by indent plugins
  " ----------------------------------------------------------------------------

  set autoindent                        " indent when creating newline

  " --------------------------------------------------------------------------
  " Tabing
  " --------------------------------------------------------------------------

  " When on, a <Tab> in front of a line inserts blanks according to
  " 'shiftwidth'. 'tabstop' or 'softtabstop' is used in other places.
  set smarttab

  set backspace=indent,eol,start        " bs anything

  " ----------------------------------------------------------------------------
  " Match and search
  " ----------------------------------------------------------------------------

  set hlsearch
  set incsearch

  " ----------------------------------------------------------------------------
  " Wild and file globbing stuff in command mode
  " ----------------------------------------------------------------------------

  " ----------------------------------------------------------------------------
  " File saving
  " ----------------------------------------------------------------------------

  " From https://github.com/swizzard/dotfiles/blob/master/.vimrc
  " Don't keep .viminfo information for files in temporary directories or shared
  " memory filesystems; this is because they're used as scratch spaces for tools
  " like sudoedit(8) and pass(1) and hence could present a security problem
  if has('viminfo')
    let &g:viminfo .= ',n' . expand(g:dko#vim_dir . '/.tmp/cache/.viminfo')
    augroup dkoviminfo
      autocmd!
      silent! autocmd BufNewFile,BufReadPre
            \ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*
            \ setlocal viminfo=
    augroup END
  endif

  " ----------------------------------------------------------------------------
  " Temp dirs
  " ----------------------------------------------------------------------------

  let &g:directory = g:dko#vim_dir . '/.tmp/swap//'
  let &g:backupdir = g:dko#vim_dir . '/.tmp/backup//'
  let &g:undodir = g:dko#vim_dir . '/.tmp/undo//'

endfunction
