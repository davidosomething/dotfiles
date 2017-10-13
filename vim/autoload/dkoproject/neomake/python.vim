" autoload/dkoproject/neomake/python.vim

" Runs on User vim-pyenv-activate-post
" Which is provided by lambdalisue/vim-pyenv
function! dkoproject#neomake#python#ActivatedPyenv() abort
  let g:neomake_python_pylint_exe = 'pyenv'
  let g:neomake_python_pylint_args = [ 'exec', 'pylint' ]
        \ + neomake#makers#ft#python#pylint().args

  let g:neomake_python_flake8_exe = 'pyenv'
  let g:neomake_python_flake8_args = [ 'exec', 'flake8' ]
        \ + neomake#makers#ft#python#flake8().args

  echomsg 'Neomake will use `pyenv exec` in python version '
        \ . pyenv#pyenv#get_activated_env()
endfunction

function! dkoproject#neomake#python#DeactivatedPyenv() abort
  unlet g:neomake_python_pylint_exe
  let g:neomake_python_pylint_args = neomake#makers#ft#python#pylint().args
  let g:neomake_python_flake8_args = neomake#makers#ft#python#flake8().args
  echomsg 'Neomake will use python in $PATH'
endfunction
