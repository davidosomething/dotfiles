" plugin/plug-vim-editorconfig.vim
" sgur/vim-editorconfig

let g:editorconfig_verbose = 1

" Disable default autocmd which only loads editorconfig on files that have
" a directory
autocmd! plugin-editorconfig

" Always load editorconfig upon opening a file
augroup dkovimeditorconfig
  autocmd!
  autocmd BufNewFile,BufReadPost * nested call editorconfig#load()
augroup END
