" ftplugin/coffee.vim

call dko#TwoSpace()

if dkoplug#Exists('vim-coffee-script')
  let g:coffee_compile_vert = 1
  let g:coffee_watch_vert = 1
endif
