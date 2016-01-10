" ftplugin/markdown.vim

if exists("g:plugs['vim-pandoc-syntax']")
  let g:pandoc#syntax#conceal#use = 0
endif

if exists("g:plugs['vim-instant-markdown']")
  let g:instant_markdown_autostart = 0
endif

