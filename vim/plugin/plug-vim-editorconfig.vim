" plugin/plug-vim-editorconfig.vim
" sgur/vim-editorconfig

augroup dkovimeditorconfig
  autocmd!
augroup END

if !dkoplug#IsLoaded('vim-editorconfig') | finish | endif

let g:editorconfig_verbose = 1

" Always load editorconfig upon opening a file
" default skips new files in non-existent directories
" see https://github.com/sgur/vim-editorconfig/issues/17
autocmd dkovimeditorconfig
      \ BufNewFile,BufReadPost *
      \ nested
      \ call editorconfig#load()
