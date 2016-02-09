" ftplugin/markdown.vim
"
" There are additional settings in after/ftplugin/markdown.vim that are set to
" override formatting options provided by vim-pandoc and other plugins.
"

setlocal omnifunc=

if exists("g:plugs['vim-pandoc-syntax']")
  let g:pandoc#syntax#conceal#use = 0
endif

if exists("g:plugs['vim-instant-markdown']")
  let g:instant_markdown_autostart = 0
  nnoremap <silent><buffer> <Leader>m :InstantMarkdownPreview<CR>
endif

