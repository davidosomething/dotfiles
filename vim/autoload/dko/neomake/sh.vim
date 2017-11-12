" autoload/dko/neomake/sh.vim

function! dko#neomake#sh#ShellcheckPosix() abort
  " https://github.com/neomake/neomake/blob/master/autoload/neomake/makers/ft/sh.vim
  let b:neomake_sh_shellcheck_args = [
        \   '--format=gcc',
        \   '--external-sources',
        \   '--shell=sh',
        \ ]
endfunction
