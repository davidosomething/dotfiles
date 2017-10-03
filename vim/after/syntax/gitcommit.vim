" after/syntax/gitcommit.vim

" Use ; for gitcommit comments instead of # since I write markdown in my
" gitcommits
syntax clear   gitcommitComment    "^#.*"
syntax match   gitcommitComment    "^;.*"
