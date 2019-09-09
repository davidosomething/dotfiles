" after/ftplugin/css.vim

call dko#TwoSpace()
" fix highlighting problems on: vertical-align, box-shadow, and others
" Might breaks 'sans-serif' font stack keyowrd
setlocal iskeyword+=-
