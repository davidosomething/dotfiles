" init.vim
" Neovim init (in place of vimrc, sources vimrc)

let g:dko_nvim_dir = fnamemodify(resolve(expand('$MYVIMRC')), ':p:h')

" ============================================================================
" Temporary fixes
" ============================================================================

if $TERM ==# 'xterm-kitty'
  " https://github.com/kovidgoyal/kitty#using-a-color-theme-with-a-background-color-does-not-work-well-in-vim
  let &t_ut=''
endif

if !has('nvim-0.4')
  " https://github.com/neovim/neovim/issues/7994
  augroup dkoneovimfixes
    autocmd!
    autocmd InsertLeave * set nopaste
  augroup END
endif

" ============================================================================
" GUI editors
" ============================================================================

if exists('g:fvim_loaded')
  set termguicolors
elseif exists('g:vv')
  VVset windowheight=100%
  VVset windowwidth=40%
  VVset windowleft=0
  VVset windowtop=0
  VVset fontfamily=FuraMonoNerdFontCompleteM-Medium
  VVset fontsize=13
  VVset lineheight=1.42
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

let g:loaded_ruby_provider = 0
let g:loaded_node_provider = 0

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

" disable python 2
let g:loaded_python_provider = 0

" python 3
let s:pyenv_py3 = s:FindExecutable([
      \   '$PYENV_ROOT/versions/neovim3/bin/python',
      \   '/usr/bin/python3',
      \ ])
if !empty(s:pyenv_py3)
  let g:python3_host_prog = s:pyenv_py3
else
  let g:loaded_python3_provider = !exists('g:fvim_loaded') ? 2 : 0
endif

" =============================================================================

execute 'source ' . g:dko_nvim_dir . '/vimrc'

" vim: sw=2 :
