" after/ftplugin/markdown.vim

setlocal spell
setlocal wrap
setlocal linebreak
setlocal textwidth=80

if exists("g:plugs['vim-pandoc-syntax']")
  let g:pandoc#syntax#conceal#use = 0
endif
