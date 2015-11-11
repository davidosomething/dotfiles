" neovim init

" disable python2
let g:loaded_python_provider = 1

" set python3
let g:python3_host_prog = '/usr/local/bin/python3'

source $VIM_DOTFILES/vimrc

if has('gui_running')
  source $VIM_DOTFILES/gvimrc
endif
