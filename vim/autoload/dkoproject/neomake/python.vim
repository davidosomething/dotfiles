" autoload/dkoproject/neomake/python.vim

let s:pylint_default_args = neomake#makers#ft#python#pylint().args

" Runs on User vim-pyenv-activate-post
" Which is provided by lambdalisue/vim-pyenv
function! dkoproject#neomake#python#ActivatedPyenv() abort
  let g:neomake_python_pylint_exe = 'pyenv'
  " Use pylint in current pyenv
  let g:neomake_python_pylint_args = [ 'exec', 'pylint' ]
        \ + s:pylint_default_args
  echomsg 'Neomake will use `pyenv exec pylint` in python version '
        \ . pyenv#pyenv#get_activated_env()
endfunction

function! dkoproject#neomake#python#DeactivatedPyenv() abort
  unlet g:neomake_python_pylint_exe
  let g:neomake_python_pylint_args = s:pylint_default_args
  echomsg 'Neomake will use python in $PATH'
endfunction
