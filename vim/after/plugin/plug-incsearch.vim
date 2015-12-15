if !exists("g:plugs['incsearch.vim']") | finish | endif
if !exists("incsearch#go") | finish | endif

map /   <Plug>(incsearch-forward)
map ?   <Plug>(incsearch-backward)
map g/  <Plug>(incsearch-stay)

