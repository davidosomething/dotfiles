" autoload/dko/neomake/sh.vim

function! dko#neomake#sh#ShellcheckPosix() abort
  " https://github.com/neomake/neomake/blob/master/autoload/neomake/makers/ft/sh.vim
  let b:neomake_sh_shellcheck_args = [
        \   '--format=gcc',
        \   '--external-sources',
        \   '--shell=sh',
        \ ]
  call dko#InitDict('b:neomake_sh_enabled_makers')
  let b:neomake_sh_enabled_makers += neomake#makers#ft#sh#EnabledMakers()
endfunction
