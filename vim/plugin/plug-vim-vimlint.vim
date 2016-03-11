" plugin/plug-vim-vimlint.vim

if !exists("g:plugs['vim-vimlint']") | finish | endif

call dko#InitObject('g:vimlint#config')
let g:vimlint#config.EVL103 = 1

