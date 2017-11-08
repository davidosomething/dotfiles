" plugin/plug-splitjoin.vim

if !dkoplug#plugins#IsLoaded('splitjoin.vim') | finish | endif

let g:splitjoin_trailing_comma = 1

let g:splitjoin_ruby_trailing_comma = 1
let g:splitjoin_ruby_hanging_args = 1
