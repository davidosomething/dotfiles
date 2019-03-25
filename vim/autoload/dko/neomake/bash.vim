" autoload/dko/neomake/bash.vim

function! dko#neomake#bash#Setup() abort
  " Called on *.sh, so we check the shebang
  let l:shebang = getline(1)
  if l:shebang !~# '^#!.*/.*\s\+bash\>'
    return
  endif

  let b:neomake_sh_shellcheck_args = [
        \   '--format=gcc',
        \   '--external-sources',
        \   '--shell=bash',
        \ ]
endfunction
