" plugin/plug-vim-hr.vim

if !dkoplug#IsLoaded('vim-hr') | finish | endif

call hr#map('_')
call hr#map('-')
call hr#map('=')
call hr#map('#')
call hr#map('*')
