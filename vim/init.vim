" init.vim
" Neovim init (in place of vimrc)

set termguicolors

let g:dko_nvim_dir = fnamemodify(resolve(expand('$MYVIMRC')), ':p:h')

" =============================================================================
" Python 2 setup
" =============================================================================

" python2 off
let s:pyenv_python2 = glob(expand('$PYENV_ROOT/versions/neovim2/bin/python'))
if !empty(s:pyenv_python2)
  let g:python_host_prog = s:pyenv_python2
endif

" =============================================================================
" Python 3 setup
" =============================================================================

let s:pyenv_python3 = glob(expand('$PYENV_ROOT/versions/neovim3/bin/python'))
if !empty(s:pyenv_python3)
  let g:python3_host_prog = s:pyenv_python3
endif

" =============================================================================
" GUI variants setup
" =============================================================================

try
  " Neovim-qt Guifont command
  command -nargs=? Guifont call rpcnotify(0, 'Gui', 'SetFont', "<args>") | let g:Guifont="<args>"
  " Set the font to DejaVu Sans Mono:h13
  Guifont Fira Mono For Powerline:h8
endtry

execute 'source ' . g:dko_nvim_dir . '/vimrc'

