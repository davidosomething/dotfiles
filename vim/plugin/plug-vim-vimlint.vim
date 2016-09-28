" plugin/plug-vim-vimlint.vim

if !dko#IsPlugged('vim-vimlint') | finish | endif

call dko#InitObject('g:vimlint#config')
let g:vimlint#config.EVL103 = 1

