" python

if exists("b:did_ftplugin") | finish | endif
let b:did_ftplugin = 1

" make Python follow PEP8 for whitespace
" http://www.python.org/dev/peps/pep-0008/
setlocal softtabstop=4 tabstop=4 shiftwidth=4
