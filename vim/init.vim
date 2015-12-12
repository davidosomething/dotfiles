" neovim init

let g:dko_nvim_dir = fnamemodify(resolve(expand("$MYVIMRC")), ":p:h")

" disable python2
let g:loaded_python_provider = 1

" set python3
let g:python3_host_prog = '/usr/local/bin/python3'

execute 'source ' g:dko_nvim_dir . '/vimrc'

if has('gui_running')
  source gvimrc
endif

