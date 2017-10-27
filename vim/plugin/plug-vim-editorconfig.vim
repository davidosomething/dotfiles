" plugin/plug-vim-editorconfig.vim
" sgur/vim-editorconfig

let g:editorconfig_verbose = 1

augroup dkovimeditorconfig
  autocmd!

  " Always load editorconfig upon opening a file
  " Fills in the gap that vim-editorconfig strangely ignores
  autocmd BufNewFile,BufReadPost * nested
        \ if !isdirectory(expand('%:p:h')) | call editorconfig#load() | endif
augroup END
