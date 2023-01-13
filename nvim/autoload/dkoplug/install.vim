" autoload/dkoplug/install.vim

function! dkoplug#install#Install() abort
  execute 'silent !curl -fLo '
        \ . g:dko#vim_dir . '/autoload/plug.vim '
        \ . 'https://raw.githubusercontent.com/'
        \ . 'junegunn/vim-plug/master/plug.vim'
endfunction
