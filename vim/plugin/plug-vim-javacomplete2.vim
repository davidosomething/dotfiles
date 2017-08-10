" plugin/plug-vim-javacomplete2.vim

if !dko#IsPlugged('vim-javacomplete2') | finish | endif

augroup dkojavacomplete
  autocmd!
augroup END

let g:JavaComplete_ClosingBrace = 0
let g:JavaComplete_ShowExternalCommandsOutput = 1
