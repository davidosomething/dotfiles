" plugin/plug-neoformat.vim
scriptencoding utf-8

if !dkoplug#IsLoaded('neoformat') | finish | endif

let g:neoformat_enabled_java = [ 'uncrustify' ]
let g:neoformat_enabled_javascript = [ 'standard' ]
let g:neoformat_enabled_less = [ 'dkoprettier' ]
let g:neoformat_enabled_lua = [ 'luafmt', 'luaformatter' ]
let g:neoformat_enabled_markdown = [ 'dkoremark' ]
let g:neoformat_enabled_python = [ 'autopep8', 'isort' ]
let g:neoformat_enabled_scss = [ 'dkoprettier' ]

function! s:MaybeNeoformat() abort
  if expand('%:t') ==# 'package.json'
    return
  endif
  Neoformat
endfunction

augroup dkoneoformat
  autocmd!
  autocmd BufWritePre *.json call s:MaybeNeoformat()
augroup END
