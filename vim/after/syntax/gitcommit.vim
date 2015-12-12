" gitcommit.vim

" Use ; for gitcommit comments instead of # since I write markdown in my
" gitcommits
syn clear   gitcommitComment    "^#.*"
syn match   gitcommitComment    "^;.*"
