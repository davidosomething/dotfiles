augroup vim-meh
  autocmd!
augroup END

" Override vim-pandoc-syntax highlighting
autocmd vim-meh Syntax *pandoc*
      \ colorscheme meh
      \| meh#PandocColors()
