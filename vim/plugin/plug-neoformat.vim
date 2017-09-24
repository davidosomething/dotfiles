" plugin/plug-neoformat.vim
scriptencoding utf-8

if !dko#IsLoaded('neoformat') | finish | endif

let g:neoformat_enabled_css = ['prettier']
let g:neoformat_enabled_java = ['uncrustify']
let g:neoformat_enabled_javascript = ['prettier-eslint']
let g:neoformat_enabled_json = ['prettier']
let g:neoformat_enabled_python = ['autopep8', 'isort']
let g:neoformat_enabled_scss = ['prettier']
