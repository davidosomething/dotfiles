" autoload/dko/neomake/bash.vim

" Called on *.sh, so we check the shebang
function! dko#neomake#bash#SetupShebang() abort
  if !dko#IsShebangBash() | return | endif
  call dko#neomake#bash#Setup()
endfunction

" Call any time to reconfigure makers in a buffer for bash
function! dko#neomake#bash#Setup() abort
  let b:neomake_sh_shellcheck_args = [
        \   '--format=gcc',
        \   '--external-sources',
        \   '--shell=bash',
        \ ]
endfunction
