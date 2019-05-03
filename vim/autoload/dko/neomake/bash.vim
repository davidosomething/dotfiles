" autoload/dko/neomake/bash.vim

" Called on *.sh, so we check the shebang or for extension contains bash
function! dko#neomake#bash#Setup() abort
  if dko#IsShebangBash() || expand('%:e') =~# 'bash'
    call dko#neomake#bash#Setup()
  endif
endfunction

" Call any time to reconfigure makers in a buffer for bash
function! dko#neomake#bash#Setup() abort
  let b:neomake_sh_shellcheck_args = [
        \   '--format=gcc',
        \   '--external-sources',
        \   '--shell=bash',
        \ ]
endfunction
