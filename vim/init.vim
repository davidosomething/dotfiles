" init.vim
" Neovim init (in place of vimrc)

set termguicolors

let g:dko_nvim_dir = fnamemodify(resolve(expand('$MYVIMRC')), ':p:h')

" ============================================================================
" :terminal emulator
" ============================================================================

tnoremap <C-b>  <C-\><C-n>

let g:terminal_scrollback_buffer_size = 100000

" Use gruvbox's termcolors
"
" @see https://github.com/ianks/gruvbox/blob/c7b13d9872af9fe1f5588d6ec56759489b0d7864/colors/gruvbox.vim#L137-L169
" @see https://github.com/morhetz/gruvbox/pull/93/files
function! s:SetTerminalColors() abort
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
endfunction
call s:SetTerminalColors()

" ============================================================================
" Python setup
" Skips if python is not installed in a pyenv virtualenv
" ============================================================================

" ----------------------------------------------------------------------------
" Python 2
" ----------------------------------------------------------------------------

let s:pyenv_python2 = glob(expand('$PYENV_ROOT/versions/neovim2/bin/python'))
if !empty(s:pyenv_python2)
  " CheckHealth and docs are inconsistent
  let g:python_host_prog  = s:pyenv_python2
  let g:python2_host_prog = s:pyenv_python2
else
  let g:loaded_python_provider = 1
endif

" ----------------------------------------------------------------------------
" Python 3
" ----------------------------------------------------------------------------

let s:pyenv_python3 = glob(expand('$PYENV_ROOT/versions/neovim3/bin/python'))
if !empty(s:pyenv_python3)
  let g:python3_host_prog = s:pyenv_python3
else
  let g:loaded_python3_provider = 1
endif

" =============================================================================

execute 'source ' . g:dko_nvim_dir . '/vimrc'

