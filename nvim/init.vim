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
" Settings
" ============================================================================

lua require('dko.opt')

lua require('dko.builtin-plugins')

lua require('dko.providers')

if !empty(dko#grepper#Get().command)
  let &g:grepprg = dko#grepper#Get().command . ' '
        \ . join(dko#grepper#Get().options, ' ')
  let &g:grepformat = dko#grepper#Get().format
endif

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

" ============================================================================
" Security
" ============================================================================

" Disallow unsafe local vimrc commands
" Leave down here since it trims local settings
set secure

" vim: sw=2 :
