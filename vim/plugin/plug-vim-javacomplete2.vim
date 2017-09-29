" plugin/plug-vim-javacomplete2.vim

if !dkoplug#plugins#Exists('vim-javacomplete2') | finish | endif

augroup dkojavacomplete
  autocmd!
  autocmd FileType java
        \ setlocal omnifunc=javacomplete#Complete
augroup END

let g:JavaComplete_ClosingBrace = 0
let g:JavaComplete_ShowExternalCommandsOutput = 1
