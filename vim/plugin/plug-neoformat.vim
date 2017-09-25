" plugin/plug-neoformat.vim
scriptencoding utf-8

if !dko#IsLoaded('neoformat') | finish | endif

let g:neoformat_javascript_dkoprettier = {
      \   'exe':    'prettier',
      \   'args':   [
      \     '--stdin',
      \     '--config',
      \     expand('$DOTFILES/prettier/prettier.config.js')
      \   ],
      \   'stdin':  1,
      \ }

let g:neoformat_javascript_dkoprettiereslint = {
      \   'exe':    'prettier-eslint',
      \   'args':   [
      \     '--config',
      \     expand('$DOTFILES/prettier/prettier.config.js'),
      \     '--stdin',
      \   ],
      \   'stdin':  1,
      \ }

let g:neoformat_enabled_css = ['dkoprettier']
let g:neoformat_enabled_java = ['uncrustify']
let g:neoformat_enabled_javascript = ['dkoprettier']
let g:neoformat_enabled_json = ['dkoprettier']
let g:neoformat_enabled_python = ['autopep8', 'isort']
let g:neoformat_enabled_scss = ['dkoprettier']
