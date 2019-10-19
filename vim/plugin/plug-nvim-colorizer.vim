" plugin/plug-nvim-colorizer.vim

if !dkoplug#IsLoaded('nvim-colorizer.lua') | finish | endif

lua require 'colorizer'.setup({ '*' }, { css = true })
