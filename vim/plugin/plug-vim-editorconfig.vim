" plugin/plug-vim-editorconfig.vim
" sgur/vim-editorconfig

let g:editorconfig_verbose = 1

augroup dkovimeditorconfig
  autocmd!
  " Always load editorconfig upon opening a file
  autocmd BufNewFile,BufReadPost * nested call editorconfig#load()
augroup END
