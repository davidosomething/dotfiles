function! dkoproject#neomake#sh#ShellcheckPosix() abort
  " https://github.com/neomake/neomake/blob/master/autoload/neomake/makers/ft/sh.vim
  let b:neomake_sh_shellcheck_args = [ '-fgcc', '--shell=sh' ]
endfunction
