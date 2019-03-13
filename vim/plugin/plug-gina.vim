" plugin/plug-gina.vim
scriptencoding utf-8

if !dkoplug#IsLoaded('gina.vim') | finish | endif

let g:gina#command#blame#formatter#format = '%ti %au %su'
let g:gina#command#blame#formatter#separator = '…'
let g:gina#command#blame#formatter#timestamp_months = 0
let g:gina#command#blame#formatter#timestamp_format1 = '%Y-%m-%d'
let g:gina#command#blame#formatter#timestamp_format2 = '%Y-%m-%d'

call gina#custom#mapping#nmap(
      \   'blame',
      \   '<Tab>',
      \   '<Plug>(gina-blame-echo)'
      \)
