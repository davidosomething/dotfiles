" init.vim
" Neovim init (in place of vimrc)

set termguicolors

let g:dko_nvim_dir = fnamemodify(resolve(expand('$MYVIMRC')), ':p:h')

" =============================================================================
" Python setup
" Python error? Try:
" - Check python is python >=3 (if not using pyenv shim)
" - Check `pip3 list` shows `neovim`
" - :UpdateRemotePlugins
" =============================================================================

let s:pyenv_python3 = glob('~/.local/pyenv/shims/python3')
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

