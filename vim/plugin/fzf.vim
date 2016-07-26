" plugin/fzf.vim
scriptencoding utf-8

if !g:dko_use_fzf | finish | endif

execute dko#BindFunction('<F5>', 'FZF')

